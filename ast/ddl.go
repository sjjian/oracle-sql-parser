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

type ColumnDef struct {
	ColumnName *element.Identifier
	Datatype   element.Datatype
	Collation  *Collation
	Props      []ColumnProp
	Default    *ColumnDefault
}

type AddColumnClause struct {
	columnClause
	Columns []*ColumnDef
}

type ModifyColumnClause struct {
	columnClause
	Columns []*ColumnDef
}

type DropColumnType int

const (
	DropColumnTypeDrop DropColumnType = iota
	DropColumnTypeSetUnused
	DropColumnTypeDropUnusedColumns
	DropColumnTypeDropColumnsContinue
)

type DropColumnProp int

const (
	DropColumnPropEmpty DropColumnProp = iota
	DropColumnPropCascade
	DropColumnPropInvalidate
	DropColumnPropOnline
)

type DropColumnClause struct {
	columnClause
	Type       DropColumnType
	Columns    []*element.Identifier
	Props      []DropColumnProp
	CheckPoint *int
}

type RenameColumnClause struct {
	columnClause
	OldName *element.Identifier
	NewName *element.Identifier
}

type CreateTableStmt struct {
	node
	TableName *TableName
	RelTable  *RelTableDef
}

type RelTableDef struct {
	Columns []*ColumnDef
}
