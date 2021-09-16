package oralce_sql_parser

import (
	"bytes"
	"fmt"
	"github.com/sjjian/oralce_sql_parser/ast"
	"github.com/timtadh/lexmachine"
	"github.com/timtadh/lexmachine/machines"
	"strings"
)

var lexer *lexmachine.Lexer

func token(tokenId int) lexmachine.Action {
	return func(s *lexmachine.Scanner, m *machines.Match) (interface{}, error) {
		return s.Token(tokenId, string(m.Bytes), m), nil
	}
}

func skip(*lexmachine.Scanner, *machines.Match) (interface{}, error) {
	return nil, nil
}

func AddTokenBetween(tokenId int, start []byte, end byte) {
	lexer.Add(start, func(scan *lexmachine.Scanner, match *machines.Match) (interface{}, error) {
		var buf bytes.Buffer
		match.EndLine = match.StartLine
		match.EndColumn = match.StartColumn
		for tc := scan.TC; tc < len(scan.Text); tc++ {
			curByte := scan.Text[tc]

			// calculate location
			match.EndColumn += 1
			if curByte == '\n' {
				match.EndLine += 1
			}
			// match end
			if curByte == end {
				scan.TC = tc + 1
				match.TC = scan.TC
				match.Bytes = buf.Bytes()
				return scan.Token(tokenId, buf.String(), match), nil
			} else {
				// between start and end
				buf.WriteByte(curByte)
			}
		}
		return nil, fmt.Errorf("unclosed %s with %s, staring at %d, (%d, %d)",
			string(start), string(end), match.TC, match.StartLine, match.StartColumn)
	})
}

func AddIdentToken(tokenId int, rs string) {
	l := strings.ToLower(rs)
	u := strings.ToUpper(rs)
	var regex bytes.Buffer
	for i := range l {
		if u[i] == l[i] {
			regex.WriteByte(u[i])
		} else {
			regex.WriteString("[")
			regex.WriteByte(u[i])
			regex.WriteByte(l[i])
			regex.WriteString("]")
		}
	}
	lexer.Add(regex.Bytes(), token(tokenId))
}

var stdTokenMap = map[string]int{
	`\*`: int('*'),
	`\(`: int('('),
	`\)`: int(')'),
	`\.`: int('.'),
}

var keywordMap = map[string]int{
	"SELECT": _select,
	"FROM":   _from,
	"ADD":    _add,
	"TABLE":  _table,
	"ALTER":  _alter,
}

func init() {
	lexer = lexmachine.NewLexer()

	for keyword, tokenId := range stdTokenMap {
		AddIdentToken(tokenId, keyword)
	}
	for keyword, tokenId := range keywordMap {
		AddIdentToken(tokenId, keyword)
	}

	lexer.Add([]byte("( |\t|\n|\r)+"), skip)

	lexer.Add([]byte("[a-zA-Z]+\\w+"), token(_nonquotedIdentifier))

	AddTokenBetween(_doubleQuoteStr, []byte(`"`), byte('"'))
	AddTokenBetween(_singleQuoteStr, []byte(`'`), byte('\''))
	err := lexer.Compile()
	if err != nil {
		panic(err)
	}
}

type yyLexImpl struct {
	scanner *lexmachine.Scanner
	err     error
	result  ast.Node
}

func NewLexer(s string) (*yyLexImpl, error) {
	scanner, err := lexer.Scanner([]byte(s))
	if err != nil {
		return nil, err
	}
	return &yyLexImpl{
		scanner: scanner,
	}, nil
}

func (l *yyLexImpl) Lex(lval *yySymType) int {
	fmt.Println("================")
	tok, err, eof := l.scanner.Next()
	if err != nil {
		fmt.Println(1)
		fmt.Println(err)
		l.err = err
		return 0
	}
	if eof {
		fmt.Println(2)
		return 0
	}
	token := tok.(*lexmachine.Token)
	fmt.Println(3)
	fmt.Printf("[%d]\n", token.Type)
	lval.str = string(token.Lexeme)
	fmt.Printf("[%s]\n", string(token.Lexeme))
	return token.Type

}

func (l *yyLexImpl) Error(s string) {
	l.err = fmt.Errorf(s)
}
