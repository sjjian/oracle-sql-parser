%{
package main

%}

%union {
    ident	struct{}
    str		string
}

%token<ident>
	_select
	_from
	_alter
	_table

%token<str>
	_singleQuoteStr 	"single quotes string"
	_doubleQuoteStr 	"double quotes string"

%start Statement

%%

Statement:
	AlterTableStmt

AlterTableStmt:
	_alter _table MemoptimizeReadClause MemoptimizeWriteClause AddColumnClause


MemoptimizeReadClause:

MemoptimizeWriteClause:

AddColumnClause:
	_add "(" ")" ColumnProperties

%%