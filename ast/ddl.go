package ast

import "github.com/sjjian/oralce_sql_parser/ast/datatype"

type AlterTableStmt struct {
	node
	TableName 		*TableName
	ColumnClauses 	[]ColumnClause
}

type ColumnClause interface {
	IsColumnClause()
}

type columnClause struct {}

func (c *columnClause) IsColumnClause(){}

type AddColumnClause struct {
	columnClause
	Columns []*ColumnDefine
}

type ColumnDefine struct {
	ColumnName *Identifier
	Datatype datatype.Datatype
}