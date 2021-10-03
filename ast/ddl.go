package ast

import (
	"github.com/sjjian/oracle_sql_parser/ast/element"
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
	Columns []*ColumnDef
}

type ColumnDef struct {
	ColumnName    *element.Identifier
	Datatype      element.Datatype
	Collation     *Collation
	Sort          SortProp
	InvisibleProp *InvisibleProp
}

type ModifyColumnClause struct {
	columnClause
}

type DropColumnClause struct {
	columnClause
}

type RenameColumnClause struct {
	columnClause
}

type CreateTableStmt struct {
	node
}
