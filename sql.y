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
	_char
	_byte
	_varchar2
	_nchar
        _nvarchar2
        _number
        _float
        _binaryFloat
        _binaryDouble
        _long
        _raw
        _date
        _timestamp
        _with
        _local
        _time
        _zone
        _interval
        _year
        _to
        _mouth
        _day
        _second
        _blob
        _clob
        _nclob
        _bfile
        _rowid
        _urowid
        _character
        _varying
        _varchar
        _national
        _numeric
        _decimal
        _dec
        _interger
        _int
        _smallInt
        _double
        _precision
        _real

%token	<str>
	_intNumber 		"int number"
	_singleQuoteStr 	"single quotes string"
	_doubleQuoteStr 	"double quotes string"
	_nonquotedIdentifier    "nonquoted identifier"

// define type for all structure
%type 	<str>
	_intNumber
	_singleQuoteStr
	_doubleQuoteStr
	_nonquotedIdentifier

%type	<node>
	Statement 		"all statement"
	AlterTableStmt		"*ast.AlterTableStmt"

%type	<anything>
	TableName		"*ast.tableName"
	Identifier		"*ast.Identifier"
	ColumnName

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

ColumnProperties:

OutOfLinePartStorageList:

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
	ColumnName DataType CollateClause SortProperty InvisibleProperty DefaultProperties

ColumnName:
	Identifier
	{
		$$ = $1
	}

CollateClause:

SortProperty:

InvisibleProperty:

DefaultProperties:


// see: https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/Data-Types.html#GUID-A3C0D836-BADB-44E5-A5D4-265BA5968483
DataType:
	OralceBuiltInDataTypes
|	AnsiSupportDataTypes

OralceBuiltInDataTypes:
	CharacterDataTypes
|	NumberDataTypes
|	LongAndRawDataTypes
|	DatetimeDataTypes
|	LargeObjectDataTypes
|	RowIdDataTypes

CharacterDataTypes:
	_char
|	_char '(' _intNumber ')'
|	_char '(' _intNumber _byte ')'
|	_char '(' _intNumber _char ')'
|	_varchar2 '(' _intNumber ')'
|	_varchar2 '(' _intNumber _byte ')'
|	_varchar2 '(' _intNumber _char ')'
|	_nchar
|	_nchar '(' _intNumber ')'
|	_nvarchar2 '(' _intNumber ')'

/*
NUMBER [ (p [, s]) ]:
Number having precision p and scale s. The precision p can range from 1 to 38. The scale s can range from -84 to 127.
Both precision and scale are in decimal digits. A NUMBER value requires from 1 to 22 bytes.

FLOAT [(p)]
A subtype of the NUMBER data type having precision p. A FLOAT value is represented internally as NUMBER.
The precision p can range from 1 to 126 binary digits. A FLOAT value requires from 1 to 22 bytes.
 */
NumberDataTypes:
	_number
|	_number '(' _intNumber ')'
|	_number '(' _intNumber '.' _intNumber ')'
|	_float
|	_float '(' _intNumber ')'
|	_binaryFloat
|	_binaryDouble

/*
RAW(size):
Raw binary data of length size bytes. You must specify size for a RAW value. Maximum size is:
- 32767 bytes if MAX_STRING_SIZE = EXTENDED
- 2000 bytes if MAX_STRING_SIZE = STANDARD
 */
LongAndRawDataTypes:
	_long
|	_long _raw
|	_raw '(' _intNumber ')'

/*
TIMESTAMP [(fractional_seconds_precision)]:
Year, month, and day values of date, as well as hour, minute, and second values of time,
where fractional_seconds_precision is the number of digits in the fractional part of the SECOND datetime field.
Accepted values of fractional_seconds_precision are 0 to 9. The default is 6.

INTERVAL YEAR [(year_precision)] TO MONTH:
Stores a period of time in days, hours, minutes, and seconds, where
- day_precision is the maximum number of digits in the DAY datetime field.
  Accepted values are 0 to 9. The default is 2.

- fractional_seconds_precision is the number of digits in the fractional part of the SECOND field.
  Accepted values are 0 to 9. The default is 6.
 */
DatetimeDataTypes:
	_date
|	_timestamp
|	_timestamp '(' _intNumber ')'
|	_timestamp '(' _intNumber ')' _with _time _zone
|	_timestamp '(' _intNumber ')' _with _local _time _zone
|	_interval _year _to _mouth
|	_interval _year '(' _intNumber ')' _to _mouth
|	_interval _day _to _second
|	_interval _day '(' _intNumber ')' _to _second
|	_interval _day '(' _intNumber ')' _to _second '(' _intNumber ')'
|	_interval _day _to _second '(' _intNumber ')'

LargeObjectDataTypes:
	_blob
|	_clob
|	_nclob
|	_bfile

/*
UROWID [(size)]:
Base 64 string representing the logical address of a row of an index-organized table.
The optional size is the size of a column of type UROWID. The maximum size and default is 4000 bytes.
*/
RowIdDataTypes:
	_rowid
|	_urowid
|	_urowid '(' _intNumber ')'

AnsiSupportDataTypes:
	_character '(' _intNumber ')'
|	_character _varying '(' _intNumber ')'
|	_char _varying '(' _intNumber ')'
|	_nchar _varying '(' _intNumber ')'
|	_varchar '(' _intNumber ')'
|	_national _character '(' _intNumber ')'
|	_national _character _varying '(' _intNumber ')'
|	_national _char '(' _intNumber ')'
|	_national _char _varying '(' _intNumber ')'
|	_numeric
|	_numeric '(' _intNumber ')'
|	_numeric '(' _intNumber '.' _intNumber ')'
|	_decimal
|	_decimal '(' _intNumber ')'
|	_decimal '(' _intNumber '.' _intNumber ')'
|	_dec
|	_dec '(' _intNumber ')'
|	_dec '(' _intNumber '.' _intNumber ')'
|	_interger
|	_int
|	_smallInt
//|	_float
//|	_float '(' _intNumber ')'
|	_double _precision
|	_real


%%