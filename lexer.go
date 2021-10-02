package parser

import (
	"bytes"
	"fmt"
	"github.com/sjjian/oracle_sql_parser/ast"
	"github.com/timtadh/lexmachine"
	"github.com/timtadh/lexmachine/machines"
	"strconv"
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
	`,`:  int(','),
	`;`:  int(';'),
}

var keywordMap = map[string]int{
	"select":        _select,
	"from":          _from,
	"add":           _add,
	"table":         _table,
	"alter":         _alter,
	"char":          _char,
	"byte":          _byte,
	"varchar2":      _varchar2,
	"nchar":         _nchar,
	"nvarchar2":     _nvarchar2,
	"number":        _number,
	"float":         _float,
	"binary_float":  _binaryFloat,
	"binary_double": _binaryDouble,
	"long":          _long,
	"raw":           _raw,
	"date":          _date,
	"timestamp":     _timestamp,
	"with":          _with,
	"local":         _local,
	"time":          _time,
	"zone":          _zone,
	"interval":      _interval,
	"year":          _year,
	"to":            _to,
	"mouth":         _mouth,
	"day":           _day,
	"second":        _second,
	"blob":          _blob,
	"clob":          _clob,
	"nclob":         _nclob,
	"bfile":         _bfile,
	"rowid":         _rowid,
	"urowid":        _urowid,
	"character":     _character,
	"varying":       _varying,
	"varchar":       _varchar,
	"national":      _national,
	"numeric":       _numeric,
	"decimal":       _decimal,
	"dec":           _dec,
	"interger":      _interger,
	"int":           _int,
	"smallint":      _smallInt,
	"double":        _double,
	"precision":     _precision,
	"real":          _real,
	"collate":       _collate,
	"sort":          _sort,
	"invisible":     _invisible,
	"visible":       _visible,
	"encrypt":       _encrypt,
	"using":         _using,
	"identified":    _identified,
	"by":            _by,
	"no":            _no,
	"salt":          _salt,
	"constraint":    _constraint,
	"key":           _key,
	"not":           _not,
	"null":          _null,
	"primary":       _primary,
	"unique":        _unique,
	"references":    _references,
	"cascade":       _cascade,
	"delete":        _delete,
	"on":            _on,
	"set":           _set,
	"deferrable":    _deferrable,
	"deferred":      _deferred,
	"immediate":     _immediate,
	"initially":     _initially,
	"norely":        _norely,
	"rely":          _rely,
	"is":            _is,
	"scope":         _scope,
	"default":       _default,
	"always":        _always,
	"as":            _as,
	"generated":     _generated,
	"identity":      _identity,
	"cache":         _cache,
	"cycle":         _cycle,
	"increment":     _increment,
	"limit":         _limit,
	"maxvalue":      _maxvalue,
	"minvalue":      _minvalue,
	"nocache":       _nocache,
	"nocycle":       _nocycle,
	"nomaxvalue":    _nomaxvalue,
	"nominvalue":    _nominvalue,
	"noorder":       _noorder,
	"order":         _order,
	"start":         _start,
	"value":         _value,
	"modify":        _modify,
	"drop":          _drop,
	"decrypt":       _decrypt,
	"all":           _all,
	"at":            _at,
	"column":        _column,
	"levels":        _levels,
	"substitutable": _substitutable,
	"force":         _force,
	"columns":       _columns,
	"continue":      _continue,
	"unused":        _unused,
	"constraints":   _constraints,
	"invalidate":    _invalidate,
	"online":        _online,
	"checkpoint":    _checkpoint,
	"rename":        _rename,
	"create":        _create,
	"blockchain":    _blockchain,
	"duplicated":    _duplicated,
	"global":        _global,
	"immutable":     _immutable,
	"private":       _private,
	"sharded":       _sharded,
	"temporary":     _temporary,
	"data":          _data,
	"extended":      _extended,
	"metadata":      _metadata,
	"none":          _none,
	"sharding":      _sharding,
	"parent":        _parent,
	"commit":        _commit,
	"definition":    _definition,
	"preserve":      _preserve,
	"rows":          _rows,
	"for":           _for,
	"memoptimize":   _memoptimize,
	"read":          _read,
	"write":         _write,
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
	lexer.Add([]byte("[a-zA-Z]+\\w+"), token(_nonquotedIdentifier))

	lexer.Add([]byte(`[0-9]+`), func(s *lexmachine.Scanner, m *machines.Match) (interface{}, error) {
		v, err := strconv.Atoi(string(m.Bytes))
		if err != nil {
			return nil, err
		}
		return s.Token(_intNumber, v, m), nil
	})

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
	token   *lexmachine.Token
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
	tok, err, eof := l.scanner.Next()
	if err != nil {
		fmt.Println(err)
		l.err = err
		return 0
	}
	if eof {
		return 0
	}
	token := tok.(*lexmachine.Token)
	l.token = token
	switch v := token.Value.(type) {
	case string:
		lval.str = v
	case int:
		lval.i = v
	}
	return token.Type
}

func (l *yyLexImpl) Error(s string) {
	l.err = fmt.Errorf("syntax error, %s, at line %d:%d", s, l.token.StartLine, l.token.TC)
}
