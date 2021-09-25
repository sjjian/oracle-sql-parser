%{
package oralce_sql_parser

import (
	"github.com/sjjian/oralce_sql_parser/ast"
	"github.com/sjjian/oralce_sql_parser/ast/element"
)

%}

%union {
    nothing	    struct{}
    i           int
    b           bool
    str		    string
    node 	    ast.Node
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
    _collate
    _sort
    _invisible
    _visible

%token <i>
	_intNumber 		"int number"

%token	<str>
	_singleQuoteStr 	"single quotes string"
	_doubleQuoteStr 	"double quotes string"
	_nonquotedIdentifier    "nonquoted identifier"

// define type for all structure
%type 	<i>
	_intNumber

%type <b>
    SortProperty

%type 	<str>
	_singleQuoteStr
	_doubleQuoteStr
	_nonquotedIdentifier

%type	<node>
	Statement 		"all statement"
	AlterTableStmt		"*ast.AlterTableStmt"

%type	<anything>
	TableName
	Identifier
	ColumnName
	Datatype
    OralceBuiltInDataTypes
    CharacterDataTypes
    NumberDataTypes
    LongAndRawDataTypes
    DatetimeDataTypes
    LargeObjectDataTypes
    RowIdDataTypes
    AnsiSupportDataTypes
    ColumnClauses
    ChangeColumnClauseList
    ChangeColumnClause
    RenameColumnClause
    AddColumnClause
    ModidyColumnClause
    RealColumnDefinition
    ColumnDefinitionList
    ColumnDefinition
    DropColumnClause
    NumberOrAsterisk
    CollateClause
    InvisibleProperty

%start Start

%%

Start:
	Statement
	{
		yylex.(*yyLexImpl).result = $1
	}

Statement:
	AlterTableStmt
	{
	    $$ = $1
	}
|   AlterTableStmt ';'
	{
	    $$ = $1
	}

/* +++++++++++++++++++++++++++++++++++++++++++++ base stmt ++++++++++++++++++++++++++++++++++++++++++++ */

TableName:
	Identifier
	{
		$$ = &ast.TableName{
			Table: $1.(*element.Identifier),
		}
	}
|	Identifier '.' Identifier
	{
		$$ = &ast.TableName{
			Schema:	$1.(*element.Identifier),
			Table: 	$3.(*element.Identifier),
		}
	}

Identifier:
	_nonquotedIdentifier
	{
		$$ = &element.Identifier{
			Typ: element.IdentifierTypeNonQuoted,
			Value: $1,
		}
	}
|	_doubleQuoteStr
	{
		$$ = &element.Identifier{
			Typ: element.IdentifierTypeQuoted,
			Value: $1,
		}
	}

/* +++++++++++++++++++++++++++++++++++++++++++++ alter table ++++++++++++++++++++++++++++++++++++++++++++ */

// see: https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/ALTER-TABLE.html#GUID-552E7373-BF93-477D-9DA3-B2C9386F2877
AlterTableStmt:
	_alter _table TableName MemoptimizeReadClause MemoptimizeWriteClause ColumnClauses
	{
		$$ = &ast.AlterTableStmt{
			TableName:      $3.(*ast.TableName),
			ColumnClauses:  $6.([]ast.ColumnClause),
		}
	}

MemoptimizeReadClause:
    {
        // TODO
    }

MemoptimizeWriteClause:
    {
        // TODO
    }

ColumnClauses:
	ChangeColumnClauseList
	{
	    $$ = $1
	}
|	RenameColumnClause
    {
        $$ = $1
    }

RenameColumnClause:
    {
        // todo:
    }


ChangeColumnClauseList:
	ChangeColumnClause
	{
	    $$ = []ast.ColumnClause{$1.(ast.ColumnClause)}
	}
|	ChangeColumnClauseList ChangeColumnClause
    {
        $$ = append($1.([]ast.ColumnClause), $2.(ast.ColumnClause))
    }

ChangeColumnClause:
	AddColumnClause
	{
	    $$ = $1
	}
|	ModidyColumnClause
	{
	    $$ = $1
	}
|	DropColumnClause
	{
	    $$ = $1
	}

AddColumnClause:
	_add '(' ColumnDefinitionList ')' ColumnProperties  OutOfLinePartStorageList
	{
		$$ = &ast.AddColumnClause{
			Columns:    $3.([]*ast.ColumnDefine),
		}
	}

ModidyColumnClause:
    {
        // todo:
    }

DropColumnClause:
    {
        // todo:
    }

ColumnProperties:
    {
        // TODO
    }

OutOfLinePartStorageList:
    {
        // TODO
    }


ColumnDefinitionList:
	ColumnDefinition
	{
	    $$ = []*ast.ColumnDefine{$1.(*ast.ColumnDefine)}
	}
|	ColumnDefinitionList ',' ColumnDefinition
    {
        $$ = append($1.([]*ast.ColumnDefine), $3.(*ast.ColumnDefine))
    }

ColumnDefinition:
	RealColumnDefinition
	{
	    $$ = $1
	}
//|	VirtualColumnDefinition // TODO； support

RealColumnDefinition:
	ColumnName Datatype CollateClause SortProperty InvisibleProperty DefaultProperties
	{
	    var collation *ast.Collation
	    if $3 != nil {
	        collation = $3.(*ast.Collation)
	    }
	    var invisible *ast.InvisibleProperty
	    if $5 != nil {
	        invisible = $5.(*ast.InvisibleProperty)
	    }

		$$ = &ast.ColumnDefine{
    		ColumnName:         $1.(*element.Identifier),
    		Datatype:           $2.(element.Datatype),
    		Collation:          collation,
    		Sort:               ast.SortProperty($4),
    		InvisibleProperty:  invisible,
    	}
	}

ColumnName:
	Identifier
	{
		$$ = $1
	}

CollateClause:
    {
        $$ = nil
    }
|   _collate Identifier
    {
        $$ = &ast.Collation{Name: $2.(*element.Identifier)}
    }

SortProperty:
    {
        $$ = false
    }
|   _sort
    {
        $$ = true
    }

InvisibleProperty:
    {
        $$ = nil
    }
|   _invisible
    {
        $$ = &ast.InvisibleProperty{Type: ast.InvisiblePropertyInvisible}
    }
|   _visible
    {
        $$ = &ast.InvisibleProperty{Type: ast.InvisiblePropertyVisible}
    }

DefaultProperties:


/* +++++++++++++++++++++++++++++++++++++++++++++ datatype ++++++++++++++++++++++++++++++++++++++++++++ */

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

NumberOrAsterisk:
    _intNumber
    {
        $$ = &element.NumberOrAsterisk{Number: $1}
    }
|   '*'
    {
        $$ = &element.NumberOrAsterisk{IsAsterisk: true}
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
	    d := &element.Char{}
	    d.SetDataDefine(element.DataDefineChar)
	    $$ = d
	}
|	_char '(' _intNumber ')'
    {
        size := $3
        d := &element.Char{Size: &size}
        d.SetDataDefine(element.DataDefineChar)
        $$ = d
    }
|	_char '(' _intNumber _byte ')'
    {
        size := $3
        d := &element.Char{Size: &size, IsByteSize: true}
        d.SetDataDefine(element.DataDefineChar)
        $$ = d
    }
|	_char '(' _intNumber _char ')'
    {
        size := $3
        d := &element.Char{Size: &size, IsCharSize: true}
        d.SetDataDefine(element.DataDefineChar)
        d.SetDataDefine(element.DataDefineChar)
        $$ = d
    }
|	_varchar2 '(' _intNumber ')'
    {
        size := $3
        d := &element.Varchar2{}
        d.Size = &size
        d.SetDataDefine(element.DataDefineVarchar2)
        $$ = d
    }
|	_varchar2 '(' _intNumber _byte ')'
    {
        size := $3
        d := &element.Varchar2{}
        d.Size = &size
        d.IsByteSize = true
        d.SetDataDefine(element.DataDefineVarchar2)
        $$ = d
    }
|	_varchar2 '(' _intNumber _char ')'
    {
        size := $3
        d := &element.Varchar2{}
        d.Size = &size
        d.IsCharSize = true
        d.SetDataDefine(element.DataDefineVarchar2)
        $$ = d
    }
|	_nchar
    {
        d := &element.NChar{}
        d.SetDataDefine(element.DataDefineNChar)
        $$ = d
    }
|	_nchar '(' _intNumber ')'
    {
        size := $3
        d := &element.NChar{Size: &size}
        d.SetDataDefine(element.DataDefineNChar)
        $$ = d
    }
|	_nvarchar2 '(' _intNumber ')'
    {
        size := $3
        d := &element.NVarchar2{}
        d.Size = &size
        d.SetDataDefine(element.DataDefineNVarChar2)
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
	    d := &element.Number{}
	    d.SetDataDefine(element.DataDefineNumber)
	    $$ = d
	}
|	_number '(' NumberOrAsterisk ')'
	{
	    precision := $3.(*element.NumberOrAsterisk)
	    d := &element.Number{Precision: precision}
	    d.SetDataDefine(element.DataDefineNumber)
	    $$ = d
	}
|	_number '(' NumberOrAsterisk ',' _intNumber ')'
	{
	    precision := $3.(*element.NumberOrAsterisk)
	    scale := $5
	    d := &element.Number{Precision: precision, Scale: &scale}
	    d.SetDataDefine(element.DataDefineNumber)
	    $$ = d
	}
|	_float
	{
	    d := &element.Float{}
	    d.SetDataDefine(element.DataDefineFloat)
	    $$ = d
	}
|	_float '(' NumberOrAsterisk ')'
	{
	    precision := $3.(*element.NumberOrAsterisk)
	    d := &element.Float{Precision: precision}
	    d.SetDataDefine(element.DataDefineFloat)
	    $$ = d
	}
|	_binaryFloat
	{
	    d := &element.BinaryFloat{}
	    d.SetDataDefine(element.DataDefineBinaryFloat)
        $$ = d
	}
|	_binaryDouble
	{
	    d := &element.BinaryDouble{}
	    d.SetDataDefine(element.DataDefineBinaryDouble)
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
	    d := &element.Long{}
	    d.SetDataDefine(element.DataDefineLong)
    	$$ = d
    }
|	_long _raw
	{
	    d := &element.LongRaw{}
	    d.SetDataDefine(element.DataDefineLongRaw)
    	$$ = d
	}
|	_raw '(' _intNumber ')'
	{
	    size := $3
	    d := &element.Raw{Size: &size}
	    d.SetDataDefine(element.DataDefineRaw)
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
        d := &element.Date{}
        d.SetDataDefine(element.DataDefineDate)
        $$ = d
    }
|	_timestamp
	{
        d := &element.Timestamp{}
        d.SetDataDefine(element.DataDefineTimestamp)
        $$ = d
	}
|	_timestamp '(' _intNumber ')'
	{
	    precision := $3
        d := &element.Timestamp{FractionalSecondsPrecision: &precision}
        d.SetDataDefine(element.DataDefineTimestamp)
        $$ = d
	}
|	_timestamp '(' _intNumber ')' _with _time _zone
	{
	    precision := $3
        d := &element.Timestamp{FractionalSecondsPrecision: &precision, WithTimeZone: true}
        d.SetDataDefine(element.DataDefineTimestamp)
        $$ = d
	}
|	_timestamp '(' _intNumber ')' _with _local _time _zone
	{
	    precision := $3
        d := &element.Timestamp{FractionalSecondsPrecision: &precision, WithLocalTimeZone: true}
        d.SetDataDefine(element.DataDefineTimestamp)
        $$ = d
	}
|	_interval _year _to _mouth
	{
        d := &element.IntervalYear{}
        d.SetDataDefine(element.DataDefineIntervalYear)
        $$ = d
	}
|	_interval _year '(' _intNumber ')' _to _mouth
	{
	    precision := $4
        d := &element.IntervalYear{Precision: &precision}
        d.SetDataDefine(element.DataDefineIntervalYear)
        $$ = d
	}
|	_interval _day _to _second
	{
        d := &element.IntervalDay{}
        d.SetDataDefine(element.DataDefineIntervalDay)
        $$ = d
	}
|	_interval _day '(' _intNumber ')' _to _second
	{
	    precision := $4
        d := &element.IntervalDay{Precision: &precision}
        d.SetDataDefine(element.DataDefineIntervalDay)
        $$ = d
	}
|	_interval _day '(' _intNumber ')' _to _second '(' _intNumber ')'
	{
	    precision := $4
	    sPrecision := $9
        d := &element.IntervalDay{Precision: &precision, FractionalSecondsPrecision: &sPrecision}
        d.SetDataDefine(element.DataDefineIntervalDay)
        $$ = d
	}
|	_interval _day _to _second '(' _intNumber ')'
	{
	    sPrecision := $6
        d := &element.IntervalDay{FractionalSecondsPrecision: &sPrecision}
        d.SetDataDefine(element.DataDefineIntervalDay)
        $$ = d
	}

LargeObjectDataTypes:
	_blob
	{
        d := &element.Blob{}
        d.SetDataDefine(element.DataDefineBlob)
        $$ = d
    }
|	_clob
	{
        d := &element.Clob{}
        d.SetDataDefine(element.DataDefineClob)
        $$ = d
	}
|	_nclob
	{
        d := &element.NClob{}
        d.SetDataDefine(element.DataDefineNClob)
        $$ = d
	}
|	_bfile
	{
        d := &element.BFile{}
        d.SetDataDefine(element.DataDefineBFile)
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
        d := &element.RowId{}
        d.SetDataDefine(element.DataDefineRowId)
        $$ = d
    }
|	_urowid
	{
        d := &element.URowId{}
        d.SetDataDefine(element.DataDefineURowId)
        $$ = d
	}
|	_urowid '(' _intNumber ')'
	{
	    size := $3
        d := &element.URowId{Size: &size}
        d.SetDataDefine(element.DataDefineURowId)
        $$ = d
	}

AnsiSupportDataTypes:
	_character '(' _intNumber ')'
	{
	    d := &element.Char{}
	    d.SetDataDefine(element.DataDefineCharacter)
	    $$ = d
    }
|	_character _varying '(' _intNumber ')'
	{
	    size := $4
	    d := &element.Varchar2{}
	    d.Size = &size
	    d.SetDataDefine(element.DataDefineCharacterVarying)
	    $$ = d
	}
|	_char _varying '(' _intNumber ')'
	{
	    size := $4
	    d := &element.Varchar2{}
	    d.Size = &size
	    d.SetDataDefine(element.DataDefineCharVarying)
	    $$ = d
	}
|	_nchar _varying '(' _intNumber ')'
	{
        size := $4
        d := &element.NVarchar2{}
        d.Size = &size
        d.SetDataDefine(element.DataDefineNCharVarying)
        $$ = d
	}
|	_varchar '(' _intNumber ')'
	{
	    size := $3
	    d := &element.Varchar2{}
	    d.Size = &size
	    d.SetDataDefine(element.DataDefineVarchar)
	    $$ = d
	}
|	_national _character '(' _intNumber ')'
	{
	    size := $4
	    d := &element.NChar{Size: &size}
	    d.SetDataDefine(element.DataDefineNationalCharacter)
	    $$ = d
	}
|	_national _character _varying '(' _intNumber ')'
	{
	    size := $5
	    d := &element.NVarchar2{}
	    d.Size = &size
	    d.SetDataDefine(element.DataDefineNationalCharacterVarying)
	    $$ = d
	}
|	_national _char '(' _intNumber ')'
	{
	    size := $4
	    d := &element.NChar{Size: &size}
	    d.SetDataDefine(element.DataDefineNationalChar)
	    $$ = d
	}
|	_national _char _varying '(' _intNumber ')'
	{
	    size := $5
	    d := &element.NVarchar2{}
	    d.Size = &size
	    d.SetDataDefine(element.DataDefineNationalCharVarying)
	    $$ = d
	}
|	_numeric
	{
	    d := &element.Number{}
	    d.SetDataDefine(element.DataDefineNumeric)
	    $$ = d
	}
|	_numeric '(' NumberOrAsterisk ')'
	{
	    precision := $3.(*element.NumberOrAsterisk)
	    d := &element.Number{Precision: precision}
	    d.SetDataDefine(element.DataDefineNumeric)
	    $$ = d
	}
|	_numeric '(' NumberOrAsterisk '.' _intNumber ')'
	{
	    precision := $3.(*element.NumberOrAsterisk)
	    scale := $5
	    d := &element.Number{Precision: precision, Scale: &scale}
	    d.SetDataDefine(element.DataDefineNumeric)
	    $$ = d
	}
|	_decimal
	{
	    d := &element.Number{}
	    d.SetDataDefine(element.DataDefineDecimal)
	    $$ = d
	}
|	_decimal '(' NumberOrAsterisk ')'
	{
	    precision := $3.(*element.NumberOrAsterisk)
	    d := &element.Number{Precision: precision}
	    d.SetDataDefine(element.DataDefineDecimal)
	    $$ = d
	}
|	_decimal '(' NumberOrAsterisk '.' _intNumber ')'
	{
	    precision := $3.(*element.NumberOrAsterisk)
	    scale := $5
	    d := &element.Number{Precision: precision, Scale: &scale}
	    d.SetDataDefine(element.DataDefineDecimal)
	    $$ = d
	}
|	_dec
	{
	    d := &element.Number{}
	    d.SetDataDefine(element.DataDefineDec)
	    $$ = d
	}
|	_dec '(' NumberOrAsterisk ')'
	{
	    precision := $3.(*element.NumberOrAsterisk)
	    d := &element.Number{Precision: precision}
	    d.SetDataDefine(element.DataDefineDec)
	    $$ = d
	}
|	_dec '(' NumberOrAsterisk '.' _intNumber ')'
	{
	    precision := $3.(*element.NumberOrAsterisk)
	    scale := $5
	    d := &element.Number{Precision: precision, Scale: &scale}
	    d.SetDataDefine(element.DataDefineDec)
	    $$ = d
	}
|	_interger
	{
	    precision := &element.NumberOrAsterisk{Number: 38}
	    d := &element.Number{Precision: precision}
	    d.SetDataDefine(element.DataDefineInteger)
	    $$ = d
	}
|	_int
	{
	    precision := &element.NumberOrAsterisk{Number: 38}
	    d := &element.Number{Precision: precision}
	    d.SetDataDefine(element.DataDefineInt)
	    $$ = d
	}
|	_smallInt
	{
	    precision := &element.NumberOrAsterisk{Number: 38}
	    d := &element.Number{Precision: precision}
	    d.SetDataDefine(element.DataDefineSmallInt)
	    $$ = d
	}
|	_double _precision
	{
		precision := &element.NumberOrAsterisk{Number: 126}
	    d := &element.Float{Precision: precision}
	    d.SetDataDefine(element.DataDefineDoublePrecision)
	    $$ = d
	}
|	_real
	{
		precision := &element.NumberOrAsterisk{Number: 63}
	    d := &element.Float{Precision: precision}
	    d.SetDataDefine(element.DataDefineReal)
	    $$ = d
	}

%%