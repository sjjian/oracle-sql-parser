package ast

type AlterTableStmt struct {
	node
	TableName *TableName
	//AddColumnClause
}
