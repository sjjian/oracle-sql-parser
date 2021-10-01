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
    _encrypt
    _using
    _identified
    _by
    _no
    _salt
    _constraint
    _key
    _not
    _null
    _primary
    _unique
    _references
    _cascade
    _delete
    _on
    _set
    _deferrable
    _deferred
    _immediate
    _initially
    _norely
    _rely
    _is
    _scope
    _default
    _always
    _as
    _generated
    _identity
    _cache
    _cycle
    _increment
    _limit
    _maxvalue
    _minvalue
    _nocache
    _nocycle
    _nomaxvalue
    _nominvalue
    _noorder
    _order
    _start
    _value
    _modify
    _drop
    _decrypt
    _all
    _at
    _column
    _levels
    _substitutable
    _force
    _columns
    _continue
    _unused
    _constraints
    _invalidate
    _online
    _checkpoint
    _rename
    _create
    _blockchain
    _duplicated
    _global
    _immutable
    _private
    _sharded
    _temporary
    _data
    _extended
    _metadata
    _none
    _sharding
    _parent
    _commit
    _definition
    _preserve
    _rows
    _for
    _memoptimize
    _read
    _write

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
    StatementList
    Statement 		"all statement"
    AlterTableStmt	"*ast.AlterTableStmt"
    CreateTableStmt

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
    ModifyColumnClause
    RealColumnDefinition
    ColumnDefinitionList
    ColumnDefinition
    DropColumnClause
    NumberOrAsterisk
    CollateClauseOrEmpty
    CollateClause
    InvisibleProperty
    InvisiblePropertyOrEmpty
    DefaultCollateClauseOrEmpty

%start Start

%%

Start:
	StatementList
	{
		yylex.(*yyLexImpl).result = $1
	}

StatementList:
    Statement
    {
    	$$ = $1
    }
|   Statement ';'
    {
    	$$ = $1
    }

Statement:
    AlterTableStmt
    {
    	$$ = $1
    }
|   CreateTableStmt
    {
    	$$ = &ast.CreateTableStmt{}
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

ColumnNameList:
    ColumnName
|   ColumnNameList ',' ColumnName

ColumnName:
	Identifier
	{
		$$ = $1
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
	_alter _table TableName MemoptimizeForAlterTable ColumnClauses
	{
		$$ = &ast.AlterTableStmt{
			TableName:      $3.(*ast.TableName),
			ColumnClauses:  $5.([]ast.ColumnClause),
		}
	}

ColumnClauses:
	ChangeColumnClauseList
	{
	    $$ = $1
	}
|	RenameColumnClause
    {
        $$ = []ast.ColumnClause{&ast.RenameColumnClause{}}
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
|	ModifyColumnClause
	{
	    $$ = &ast.ModifyColumnClause{}
	}
|	DropColumnClause
	{
	    $$ = &ast.DropColumnClause{}
	}

/* +++++++++++++++++++++++++++++++++++++++++++++ add column ++++++++++++++++++++++++++++++++++++++++++++ */

AddColumnClause:
	_add '(' ColumnDefinitionList ')' ColumnProperties  OutOfLinePartStorageList
	{
		$$ = &ast.AddColumnClause{
			Columns:    $3.([]*ast.ColumnDefine),
		}
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
	ColumnName Datatype CollateClause SortProperty InvisiblePropertyOrEmpty DefaultOrIdentityClause EncryptClause ColumnDefinitionConstraint
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

CollateClauseOrEmpty:
    {
        $$ = nil
    }
|   CollateClause
    {
        $$ = $1
    }

CollateClause:
    _collate Identifier
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

InvisiblePropertyOrEmpty:
    {
        $$ = nil
    }
|   InvisibleProperty
    {
        $$ = $1
    }

InvisibleProperty:
    _invisible
    {
        $$ = &ast.InvisibleProperty{Type: ast.InvisiblePropertyInvisible}
    }
|   _visible
    {
        $$ = &ast.InvisibleProperty{Type: ast.InvisiblePropertyVisible}
    }

DefaultOrIdentityClause:
    {
        // empty
    }
|   DefaultClause
|   IdentityClause

DefaultClause:
    _default Expr
|   _default _no _null Expr

IdentityClause:
    _generated  _as _identity IdentityOptionsOrEmpty
|   _generated _always _as _identity IdentityOptionsOrEmpty
|   _generated _always _as _identity IdentityOptionsOrEmpty
|   _generated _by _default _as _identity IdentityOptionsOrEmpty
|   _generated _by _default _on _null _as _identity IdentityOptionsOrEmpty

IdentityOptionsOrEmpty:
    {
        // empty
    }
|   '(' IdentityOptions ')'

IdentityOptions:
    {
        // empty
    }
|   IdentityOption
|   IdentityOptions IdentityOption

IdentityOption:
    _start _with _intNumber
|   _start _with _limit _value
|   _increment _by _intNumber
|   _maxvalue _intNumber
|   _nomaxvalue
|   _minvalue _intNumber
|   _nominvalue
|   _cycle
|   _nocycle
|   _cache _intNumber
|   _nocache
|   _order
|   _noorder

EncryptClause:
    {
        // empty
    }
|   _encrypt EncryptionSpec

EncryptionSpec:
    EncryptAlgorithm IdentifiedByClause IntergrityAlgorithm SaltProperty

EncryptAlgorithm:
    {
        // empty
    }
|   _using _singleQuoteStr

IdentifiedByClause:
    {
        // empty
    }
|   _identified _by Identifier

IntergrityAlgorithm:
    {
        // empty
    }
|   _singleQuoteStr

SaltProperty:
    {
        // empty
    }
|   _salt
|   _no _salt

ColumnDefinitionConstraint:
    {
        // empty
    }
|   InlineRefConstraint
|   InlineConstraintList

InlineConstraintList:
    InlineConstraint
|   InlineConstraintList InlineConstraint

/* +++++++++++++++++++++++++++++++++++++++++++++ modify column ++++++++++++++++++++++++++++++++++++++++++++ */

ModifyColumnClause:
    _modify '(' ModifyColumnProperties ')'
    {
        $$ = nil
    }
|   _modify '(' ModifyColumnVisibilityList ')'
    {
        $$ = nil
    }
|   ModifyColumnSubstitutable
    {
        $$ = nil
    }

ModifyColumnProperties:
    ModifyColumnProperty
|   ModifyColumnProperties ',' ModifyColumnProperty

ModifyColumnProperty:
    ModifyRealColumnProperty
// |   ModifyVirtualColumnProperty // TODO

ModifyRealColumnProperty:
    ColumnName Datatype CollateClause DefaultOrIdentityClauseForModify EncryptClauseForModify ColumnConstraintForModify

DefaultOrIdentityClauseForModify:
    _drop _identity
|   DefaultOrIdentityClause

EncryptClauseForModify:
    _decrypt
|   EncryptClause

ColumnConstraintForModify:
    {
        // empty
    }
|   InlineConstraintList

ModifyColumnVisibilityList:
    ModifyColumnVisibility
|   ModifyColumnVisibilityList ',' ModifyColumnVisibility

ModifyColumnVisibility:
    ColumnName InvisibleProperty

ModifyColumnSubstitutable:
    _column ColumnName _substitutable _at _all _levels IsForce
|   _column ColumnName _not _substitutable _at _all _levels IsForce

IsForce:
    {
        // empty
    }
|   _force

/* +++++++++++++++++++++++++++++++++++++++++++++ drop column ++++++++++++++++++++++++++++++++++++++++++++ */

DropColumnClause:
    _set _unused ColumnNameListForDropColumn DropColumnPropertiesOrEmpty DropColumnOnline
    {
    	$$ = nil
    }
|   _drop ColumnNameListForDropColumn DropColumnPropertiesOrEmpty DropColumnCheckpoint
    {
    	$$ = nil
    }
|   _drop _unused _columns DropColumnCheckpoint
    {
    	$$ = nil
    }
|   _drop _columns _continue DropColumnCheckpoint
    {
    	$$ = nil
    }

ColumnNameListForDropColumn:
    _column ColumnName
|   '(' ColumnNameList ')'

DropColumnPropertiesOrEmpty:
    {
        // empty
    }
|   DropColumnProperties

DropColumnProperties:
    DropColumnProperty
|   DropColumnProperties DropColumnProperty

DropColumnProperty:
    _cascade _constraints
|   _invalidate

DropColumnOnline:
    {
        // empty
    }
|   _online

DropColumnCheckpoint:
    {
        // empty
    }
|   _checkpoint _intNumber

/* +++++++++++++++++++++++++++++++++++++++++++ rename column +++++++++++++++++++++++++++++++++++++++++ */

RenameColumnClause:
    _rename _column ColumnName _to ColumnName
    {
    	$$ = nil
    }

/* +++++++++++++++++++++++++++++++++++++++++++ create table ++++++++++++++++++++++++++++++++++++++++++ */

CreateTableStmt:
    _create _table TableType TableName ShardingType TableDef Memoptimize ParentTable
    {
    	$$ = nil
    }

TableType:
    {
        // empty
    }
|   _global _temporary
|   _private _temporary
|   _sharded
|   _duplicated
|   _immutable
|   _blockchain
|   _immutable _blockchain

ShardingType:
    {
        // empty
    }
|   _sharding '=' _metadata
|   _sharding '=' _data
|   _sharding '=' _extended _data
|   _sharding '=' _none

ParentTable:
    {
        // empty
    }
|   _parent TableName

TableDef: // todo: support object table and XML type table
    RelTableDef

RelTableDef:
    RelTablePropertiesOrEmpty ImmutableTableClauses BlockchainTableClauses DefaultCollateClauseOrEmpty OnCommitClause PhysicalProperties TableProperties

ImmutableTableClauses:

BlockchainTableClauses:

DefaultCollateClauseOrEmpty:
    {
        $$ = nil
    }
|   _default CollateClause
    {
        $$ = $2
    }

OnCommitClause:
    OnCommitDef OnCommitRows

OnCommitDef:
    {
        // empty
    }
|   _on _commit _drop _definition
|   _on _commit _preserve _definition

OnCommitRows:
    {
        // empty
    }
|   _on _commit _delete _rows
|   _on _commit _preserve _rows

PhysicalProperties: // todo

TableProperties: // todo

RelTablePropertiesOrEmpty:
    {
        // empty
    }
|   '(' RelTableProperties ')'

RelTableProperties:
    RelTableProperty
|   RelTableProperties ',' RelTableProperty

RelTableProperty:
    ColumnDefinition

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

/* +++++++++++++++++++++++++++++++++++++++++++++ constraint ++++++++++++++++++++++++++++++++++++++++++++ */

// see https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/constraint.html#GUID-1055EA97-BA6F-4764-A15F-1024FD5B6DFE
//Constraint:
//    InlineConstraint
//|   OutOfLineConstraint
//|   InlineRefConstraint
//|   OutOfLineRefConstraint

ConstraintNameOrEmpty:
    {
        // empty
    }
|   _constraint Identifier

InlineConstraint:
    ConstraintNameOrEmpty InlineConstraintProperty ConstraintStateOrEmpty

InlineConstraintProperty:
    _null
|   _not _null
|   _unique
|   _primary _key
|   ReferencesClause
//|   ConstraintCheckCondition // todo

ReferencesClause:
    _references TableName ColumnNameListOrEmpty ReferencesOnDelete

ColumnNameListOrEmpty:
    {
        // empty
    }
|   '(' ColumnNameList ')'

ReferencesOnDelete:
    {
        // empty
    }
|   _on _delete _cascade
|   _on _delete _set _null

ConstraintStateOrEmpty:
    {
        // empty
    }
|   ConstraintState

ConstraintState:
    ConstraintStateDeferrable ConstraintStateRely
|   ConstraintStateDeferrable ConstraintStateDeferredOrImmediate ConstraintStateRely
|   ConstraintStateDeferredOrImmediate ConstraintStateRely
|   ConstraintStateDeferredOrImmediate ConstraintStateDeferrable ConstraintStateRely

ConstraintStateDeferrable:
    _deferrable
|   _not _deferrable

ConstraintStateDeferredOrImmediate:
    _initially _deferred
|   _initially _immediate

ConstraintStateRely:
    {
        // empty
    }
|   _rely
|   _norely

InlineRefConstraint:
    _scope _is TableName
|   _with _rowid
|   ConstraintNameOrEmpty ReferencesClause ConstraintStateOrEmpty

/* +++++++++++++++++++++++++++++++++++++++++ memoptimize +++++++++++++++++++++++++++++++++++++++++ */

MemoptimizeForAlterTable:
    MemoptimizeReadForAlterTable MemoptimizeWriteForAlterTable

MemoptimizeReadForAlterTable:
    MemoptimizeRead
|   _no _memoptimize _for _read

MemoptimizeWriteForAlterTable:
    MemoptimizeWrite
|   _no _memoptimize _for _write

Memoptimize:
    MemoptimizeRead MemoptimizeWrite

MemoptimizeRead:
    {
        // empty
    }
|   _memoptimize _for _read

MemoptimizeWrite:
    {
        // empty
    }
|   _memoptimize _for _write

/* +++++++++++++++++++++++++++++++++++++++++++++ expr ++++++++++++++++++++++++++++++++++++++++++++ */

// see https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/Expressions.html#GUID-E7A5363C-AEE9-4809-99C1-1A9C6E3AE017

// TODO: support expression
Expr:
    _intNumber
|   _doubleQuoteStr

%%