%{
package oralce_sql_parser

import (
	"github.com/sjjian/oralce_sql_parser/ast"
	"github.com/sjjian/oralce_sql_parser/ast/datatype"
)

%}

%union {
    nothing	    struct{}
    i           int
    str		    string
    node 	    ast.Node
    anything 	interface{}
    dt          datatype.Datatype
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

%token <i>
	_intNumber 		"int number"

%token	<str>
	_singleQuoteStr 	"single quotes string"
	_doubleQuoteStr 	"double quotes string"
	_nonquotedIdentifier    "nonquoted identifier"

// define type for all structure
%type 	<i>
	_intNumber

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
	ColumnName

%type   <dt>
    Datatype
    OralceBuiltInDataTypes
    CharacterDataTypes
    NumberDataTypes
    LongAndRawDataTypes
    DatetimeDataTypes
    LargeObjectDataTypes
    RowIdDataTypes
    AnsiSupportDataTypes

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
	ColumnName Datatype CollateClause SortProperty InvisibleProperty DefaultProperties

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
Datatype:
	OralceBuiltInDataTypes
	{
        $$ = $1
    }
|	AnsiSupportDataTypes
	{
	    $$ = $1
	}

OralceBuiltInDataTypes:
	CharacterDataTypes
	{
	    $$ = $1
	}
|	NumberDataTypes
	{
	    $$ = $1
	}
|	LongAndRawDataTypes
	{
	    $$ = $1
	}
|	DatetimeDataTypes
	{
	    $$ = $1
	}
|	LargeObjectDataTypes
	{
	    $$ = $1
	}
|	RowIdDataTypes
	{
	    $$ = $1
	}

CharacterDataTypes:
	_char
	{
	    d := &datatype.Char{}
	    d.SetDataDefine(datatype.DataDefineChar)
	    $$ = d
	}
|	_char '(' _intNumber ')'
    {
        size := $3
        d := &datatype.Char{Size: &size}
        d.SetDataDefine(datatype.DataDefineChar)
        $$ = d
    }
|	_char '(' _intNumber _byte ')'
    {
        size := $3
        d := &datatype.Char{Size: &size, IsByteSize: true}
        d.SetDataDefine(datatype.DataDefineChar)
        $$ = d
    }
|	_char '(' _intNumber _char ')'
    {
        size := $3
        d := &datatype.Char{Size: &size, IsCharSize: true}
        d.SetDataDefine(datatype.DataDefineChar)
        d.SetDataDefine(datatype.DataDefineChar)
        $$ = d
    }
|	_varchar2 '(' _intNumber ')'
    {
        size := $3
        d := &datatype.Varchar2{}
        d.Size = &size
        d.SetDataDefine(datatype.DataDefineVarchar2)
        $$ = d
    }
|	_varchar2 '(' _intNumber _byte ')'
    {
        size := $3
        d := &datatype.Varchar2{}
        d.Size = &size
        d.IsByteSize = true
        d.SetDataDefine(datatype.DataDefineVarchar2)
        $$ = d
    }
|	_varchar2 '(' _intNumber _char ')'
    {
        size := $3
        d := &datatype.Varchar2{}
        d.Size = &size
        d.IsCharSize = true
        d.SetDataDefine(datatype.DataDefineVarchar2)
        $$ = d
    }
|	_nchar
    {
        d := &datatype.NChar{}
        d.SetDataDefine(datatype.DataDefineNChar)
        $$ = d
    }
|	_nchar '(' _intNumber ')'
    {
        size := $3
        d := &datatype.NChar{Size: &size}
        d.SetDataDefine(datatype.DataDefineNChar)
        $$ = d
    }
|	_nvarchar2 '(' _intNumber ')'
    {
        size := $3
        d := &datatype.NVarchar2{}
        d.Size = &size
        d.SetDataDefine(datatype.DataDefineNVarChar2)
        $$ = d
    }

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
	{
	    d := &datatype.Number{}
	    d.SetDataDefine(datatype.DataDefineNumber)
	    $$ = d
	}
|	_number '(' _intNumber ')'
	{
	    precision := $3
	    d := &datatype.Number{Precision: &precision}
	    d.SetDataDefine(datatype.DataDefineNumber)
	    $$ = d
	}
|	_number '(' _intNumber ',' _intNumber ')'
	{
	    precision := $3
	    scale := $5
	    d := &datatype.Number{Precision: &precision, Scale: &scale}
	    d.SetDataDefine(datatype.DataDefineNumber)
	    $$ = d
	}
|	_float
	{
	    d := &datatype.Float{}
	    d.SetDataDefine(datatype.DataDefineFloat)
	    $$ = d
	}
|	_float '(' _intNumber ')'
	{
		precision := $3
	    d := &datatype.Float{Precision: &precision}
	    d.SetDataDefine(datatype.DataDefineFloat)
	    $$ = d
	}
|	_binaryFloat
	{
	    d := &datatype.BinaryFloat{}
	    d.SetDataDefine(datatype.DataDefineBinaryFloat)
        $$ = d
	}
|	_binaryDouble
	{
	    d := &datatype.BinaryDouble{}
	    d.SetDataDefine(datatype.DataDefineBinaryDouble)
        $$ = d
	}

/*
RAW(size):
Raw binary data of length size bytes. You must specify size for a RAW value. Maximum size is:
- 32767 bytes if MAX_STRING_SIZE = EXTENDED
- 2000 bytes if MAX_STRING_SIZE = STANDARD
 */
LongAndRawDataTypes:
	_long
	{
	    d := &datatype.Long{}
	    d.SetDataDefine(datatype.DataDefineLong)
    	$$ = d
    }
|	_long _raw
	{
	    d := &datatype.LongRaw{}
	    d.SetDataDefine(datatype.DataDefineLongRaw)
    	$$ = d
	}
|	_raw '(' _intNumber ')'
	{
	    size := $3
	    d := &datatype.Raw{Size: &size}
	    d.SetDataDefine(datatype.DataDefineRaw)
    	$$ = d
	}

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
	{
        d := &datatype.Date{}
        d.SetDataDefine(datatype.DataDefineDate)
        $$ = d
    }
|	_timestamp
	{
        d := &datatype.Timestamp{}
        d.SetDataDefine(datatype.DataDefineTimestamp)
        $$ = d
	}
|	_timestamp '(' _intNumber ')'
	{
	    precision := $3
        d := &datatype.Timestamp{FractionalSecondsPrecision: &precision}
        d.SetDataDefine(datatype.DataDefineTimestamp)
        $$ = d
	}
|	_timestamp '(' _intNumber ')' _with _time _zone
	{
	    precision := $3
        d := &datatype.Timestamp{FractionalSecondsPrecision: &precision, WithTimeZone: true}
        d.SetDataDefine(datatype.DataDefineTimestamp)
        $$ = d
	}
|	_timestamp '(' _intNumber ')' _with _local _time _zone
	{
	    precision := $3
        d := &datatype.Timestamp{FractionalSecondsPrecision: &precision, WithLocalTimeZone: true}
        d.SetDataDefine(datatype.DataDefineTimestamp)
        $$ = d
	}
|	_interval _year _to _mouth
	{
        d := &datatype.IntervalYear{}
        d.SetDataDefine(datatype.DataDefineIntervalYear)
        $$ = d
	}
|	_interval _year '(' _intNumber ')' _to _mouth
	{
	    precision := $4
        d := &datatype.IntervalYear{Precision: &precision}
        d.SetDataDefine(datatype.DataDefineIntervalYear)
        $$ = d
	}
|	_interval _day _to _second
	{
        d := &datatype.IntervalDay{}
        d.SetDataDefine(datatype.DataDefineIntervalDay)
        $$ = d
	}
|	_interval _day '(' _intNumber ')' _to _second
	{
	    precision := $4
        d := &datatype.IntervalDay{Precision: &precision}
        d.SetDataDefine(datatype.DataDefineIntervalDay)
        $$ = d
	}
|	_interval _day '(' _intNumber ')' _to _second '(' _intNumber ')'
	{
	    precision := $4
	    sPrecision := $9
        d := &datatype.IntervalDay{Precision: &precision, FractionalSecondsPrecision: &sPrecision}
        d.SetDataDefine(datatype.DataDefineIntervalDay)
        $$ = d
	}
|	_interval _day _to _second '(' _intNumber ')'
	{
	    sPrecision := $6
        d := &datatype.IntervalDay{FractionalSecondsPrecision: &sPrecision}
        d.SetDataDefine(datatype.DataDefineIntervalDay)
        $$ = d
	}

LargeObjectDataTypes:
	_blob
	{
        d := &datatype.Blob{}
        d.SetDataDefine(datatype.DataDefineBlob)
        $$ = d
    }
|	_clob
	{
        d := &datatype.Clob{}
        d.SetDataDefine(datatype.DataDefineClob)
        $$ = d
	}
|	_nclob
	{
        d := &datatype.NClob{}
        d.SetDataDefine(datatype.DataDefineNClob)
        $$ = d
	}
|	_bfile
	{
        d := &datatype.BFile{}
        d.SetDataDefine(datatype.DataDefineBFile)
        $$ = d
	}

/*
UROWID [(size)]:
Base 64 string representing the logical address of a row of an index-organized table.
The optional size is the size of a column of type UROWID. The maximum size and default is 4000 bytes.
*/
RowIdDataTypes:
	_rowid
	{
        d := &datatype.RowId{}
        d.SetDataDefine(datatype.DataDefineRowId)
        $$ = d
    }
|	_urowid
	{
        d := &datatype.URowId{}
        d.SetDataDefine(datatype.DataDefineURowId)
        $$ = d
	}
|	_urowid '(' _intNumber ')'
	{
	    size := $3
        d := &datatype.URowId{Size: &size}
        d.SetDataDefine(datatype.DataDefineURowId)
        $$ = d
	}

AnsiSupportDataTypes:
	_character '(' _intNumber ')'
	{
	    d := &datatype.Char{}
	    d.SetDataDefine(datatype.DataDefineCharacter)
	    $$ = d
    }
|	_character _varying '(' _intNumber ')'
	{
	    size := $4
	    d := &datatype.Varchar2{}
	    d.Size = &size
	    d.SetDataDefine(datatype.DataDefineCharacterVarying)
	    $$ = d
	}
|	_char _varying '(' _intNumber ')'
	{
	    size := $4
	    d := &datatype.Varchar2{}
	    d.Size = &size
	    d.SetDataDefine(datatype.DataDefineCharVarying)
	    $$ = d
	}
|	_nchar _varying '(' _intNumber ')'
	{
        size := $4
        d := &datatype.NVarchar2{}
        d.Size = &size
        d.SetDataDefine(datatype.DataDefineNCharVarying)
        $$ = d
	}
|	_varchar '(' _intNumber ')'
	{
	    size := $3
	    d := &datatype.Varchar2{}
	    d.Size = &size
	    d.SetDataDefine(datatype.DataDefineVarchar)
	    $$ = d
	}
|	_national _character '(' _intNumber ')'
	{
	    size := $4
	    d := &datatype.NChar{Size: &size}
	    d.SetDataDefine(datatype.DataDefineNationalCharacter)
	    $$ = d
	}
|	_national _character _varying '(' _intNumber ')'
	{
	    size := $5
	    d := &datatype.NVarchar2{}
	    d.Size = &size
	    d.SetDataDefine(datatype.DataDefineNationalCharacterVarying)
	    $$ = d
	}
|	_national _char '(' _intNumber ')'
	{
	    size := $4
	    d := &datatype.NChar{Size: &size}
	    d.SetDataDefine(datatype.DataDefineNationalChar)
	    $$ = d
	}
|	_national _char _varying '(' _intNumber ')'
	{
	    size := $5
	    d := &datatype.NVarchar2{}
	    d.Size = &size
	    d.SetDataDefine(datatype.DataDefineNationalCharVarying)
	    $$ = d
	}
|	_numeric
	{
	    d := &datatype.Number{}
	    d.SetDataDefine(datatype.DataDefineNumeric)
	    $$ = d
	}
|	_numeric '(' _intNumber ')'
	{
	    precision := $3
	    d := &datatype.Number{Precision: &precision}
	    d.SetDataDefine(datatype.DataDefineNumeric)
	    $$ = d
	}
|	_numeric '(' _intNumber '.' _intNumber ')'
	{
	    precision := $3
	    scale := $5
	    d := &datatype.Number{Precision: &precision, Scale: &scale}
	    d.SetDataDefine(datatype.DataDefineNumeric)
	    $$ = d
	}
|	_decimal
	{
	    d := &datatype.Number{}
	    d.SetDataDefine(datatype.DataDefineDecimal)
	    $$ = d
	}
|	_decimal '(' _intNumber ')'
	{
	    precision := $3
	    d := &datatype.Number{Precision: &precision}
	    d.SetDataDefine(datatype.DataDefineDecimal)
	    $$ = d
	}
|	_decimal '(' _intNumber '.' _intNumber ')'
	{
	    precision := $3
	    scale := $5
	    d := &datatype.Number{Precision: &precision, Scale: &scale}
	    d.SetDataDefine(datatype.DataDefineDecimal)
	    $$ = d
	}
|	_dec
	{
	    d := &datatype.Number{}
	    d.SetDataDefine(datatype.DataDefineDec)
	    $$ = d
	}
|	_dec '(' _intNumber ')'
	{
	    precision := $3
	    d := &datatype.Number{Precision: &precision}
	    d.SetDataDefine(datatype.DataDefineDec)
	    $$ = d
	}
|	_dec '(' _intNumber '.' _intNumber ')'
	{
	    precision := $3
	    scale := $5
	    d := &datatype.Number{Precision: &precision, Scale: &scale}
	    d.SetDataDefine(datatype.DataDefineDec)
	    $$ = d
	}
|	_interger
	{
	    precision := 38
	    d := &datatype.Number{Precision: &precision}
	    d.SetDataDefine(datatype.DataDefineInteger)
	    $$ = d
	}
|	_int
	{
	    precision := 38
	    d := &datatype.Number{Precision: &precision}
	    d.SetDataDefine(datatype.DataDefineInt)
	    $$ = d
	}
|	_smallInt
	{
	    precision := 38
	    d := &datatype.Number{Precision: &precision}
	    d.SetDataDefine(datatype.DataDefineSmallInt)
	    $$ = d
	}
|	_double _precision
	{
		precision := 126
	    d := &datatype.Float{Precision: &precision}
	    d.SetDataDefine(datatype.DataDefineDoublePrecision)
	    $$ = d
	}
|	_real
	{
		precision := 63
	    d := &datatype.Float{Precision: &precision}
	    d.SetDataDefine(datatype.DataDefineReal)
	    $$ = d
	}
%%