package main

import "fmt"

func main() {
	err := Parser(`select * FROM 'a'`)
	if err != nil {
		fmt.Println(err)
	}
}

func Parser(query string) error {
	l, err := NewLexer(query)
	if err != nil {
		fmt.Println(err)
		return err
	}
	yyParse(l)
	if l.err != nil {
		return l.err
	}
	return nil
}
