package ast

import (
	"github.com/sjjian/oralce_sql_parser/ast/element"
)

type AlterTableStmt struct {
	node
	TableName     *TableName
	ColumnClauses []ColumnClause
}

type ColumnClause interface {
	IsColumnClause()
}

type columnClause struct{}

func (c *columnClause) IsColumnClause() {}

type AddColumnClause struct {
	columnClause
	Columns []*ColumnDefine
}

type ColumnDefine struct {
	ColumnName        *element.Identifier
	Datatype          element.Datatype
	Collation         *Collation
	Sort              SortProperty
	InvisibleProperty *InvisibleProperty
}

type ModifyColumnClause struct {
	columnClause
}