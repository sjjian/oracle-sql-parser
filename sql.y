%{
package oralce_sql_parser

%}

%union {
    nothing	struct{}
    str		string
    node 	ast.Node
    anything 	interface{}
}

%token	<nothing>
	_select
	_from
	_alter
	_table
	_add

%token	<str>
	_singleQuoteStr 	"single quotes string"
	_doubleQuoteStr 	"double quotes string"
	_nonquotedIdentifier    "nonquoted identifier"

// define type for all structure
%type 	<str>
	_singleQuoteStr
	_doubleQuoteStr
	_nonquotedIdentifier

%type	<node>
	Statement 		"all statement"
	AlterTableStmt		"*ast.AlterTableStmt"

%type	<anything>
	TableName		"*ast.tableName"
	Identifier		"*ast.Identifier"

%start Start

%%

Start:
	Statement
	{
		yylex.(*yyLexImpl).result = $1
	}

Statement:
	AlterTableStmt

// see: https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/ALTER-TABLE.html#GUID-552E7373-BF93-477D-9DA3-B2C9386F2877
AlterTableStmt:
	_alter _table TableName MemoptimizeReadClause MemoptimizeWriteClause  ColumnClause
	{
		$$ = &ast.AlterTableStmt{
			TableName: $3.(*ast.TableName),
		}
	}

TableName:
	Identifier
	{
		$$ = &ast.TableName{
			Table: $1.(*ast.Identifier),
		}
	}
|	Identifier '.' Identifier
	{
		$$ = &ast.TableName{
			Schema:	$1.(*ast.Identifier),
			Table: 	$3.(*ast.Identifier),
		}
	}

Identifier:
	_nonquotedIdentifier
	{
		$$ = &ast.Identifier{
			Typ: ast.IdentifierTypeNonQuoted,
			Value: $1,
		}
	}
|	_doubleQuoteStr
	{
		$$ = &ast.Identifier{
			Typ: ast.IdentifierTypeQuoted,
			Value: $1,
		}
	}

MemoptimizeReadClause:

MemoptimizeWriteClause:

ColumnClause:
	ChangeColumnClauseList
|	RenameColumnClause

ChangeColumnClauseList:
	ChangeColumnClause
|	ChangeColumnClauseList ChangeColumnClause

ChangeColumnClause:
	AddColumnClause
|	ModidyColumnClause
|	DropColumnClause

AddColumnClause:
	_add '(' ColumnDefinitionList ')' ColumnProperties '(' OutOfLinePartStorageList ')'

ModidyColumnClause:

DropColumnClause:

RenameColumnClause:

ColumnDefinitionList:
	ColumnDefinition
|	ColumnDefinitionList ',' ColumnDefinition

ColumnDefinition:
	RealColumnDefinition
//|	VirtualColumnDefinition // TODO； support

RealColumnDefinition:
	ColumnName DataType CollateClause
%%