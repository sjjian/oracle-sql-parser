package ast

import (
	"github.com/sjjian/oralce_sql_parser/ast/element"
)

type TableName struct {
	Schema *element.Identifier
	Table  *element.Identifier
}

