package main

import (
	"bytes"
	"fmt"
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
		str := make([]byte, 0, 10)
		str = append(str, match.Bytes...)
		match.EndLine = match.StartLine
		match.EndColumn = match.StartColumn
		for tc := scan.TC; tc < len(scan.Text); tc++ {
			str = append(str, scan.Text[tc])
			match.EndColumn += 1
			text := scan.Text[tc]
			if text == '\n' {
				match.EndLine += 1
			}
			if text == end {
				match.TC = scan.TC
				scan.TC = tc + 1
				match.Bytes = str
				x, _ := token(tokenId)(scan, match)
				t := x.(*lexmachine.Token)
				v := t.Value.(string)
				t.Value = v[1 : len(v)-1]
				return t, nil
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
}

var keywordMap = map[string]int{
	"SELECT": _select,
	"FROM":   _from,
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
	fmt.Println(string(token.Lexeme))
	return token.Type

}

func (l *yyLexImpl) Error(s string) {
	l.err = fmt.Errorf(s)
}
