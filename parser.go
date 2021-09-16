package oralce_sql_parser

import (
	"fmt"
	"github.com/sjjian/oralce_sql_parser/ast"
)

func Parser(query string) (ast.Node, error) {
	l, err := NewLexer(query)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}
	yyParse(l)
	if l.err != nil {
		return nil, l.err
	}
	return l.result, nil
}
