package ast

import (
	"github.com/sjjian/oracle_sql_parser/ast/element"
)

type TableName struct {
	Schema *element.Identifier
	Table  *element.Identifier
}

type Collation struct {
	Name *element.Identifier
}

type SortProperty bool

const (
	InvisiblePropertyInvisible = iota
	InvisiblePropertyVisible
)

type InvisibleProperty struct {
	Type int
}