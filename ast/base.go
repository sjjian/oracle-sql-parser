package ast

type TableName struct {
	Schema *Identifier
	Table  *Identifier
}

const (
	IdentifierTypeQuoted    = iota // "schema" . "table"
	IdentifierTypeNonQuoted        // schema . table
)

type Identifier struct {
	Typ   int
	Value string
}
