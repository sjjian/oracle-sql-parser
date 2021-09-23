package element

type Datatype interface {
	DataDefine() DataDefine
}

type DataDefine int

const (
	DataDefineChar DataDefine = iota
	DataDefineVarchar2
	DataDefineNChar
	DataDefineNVarChar2
	DataDefineNumber
	DataDefineFloat
	DataDefineBinaryFloat
	DataDefineBinaryDouble
	DataDefineLong
	DataDefineLongRaw
	DataDefineRaw
	DataDefineDate
	DataDefineTimestamp
	DataDefineIntervalYear
	DataDefineIntervalDay
	DataDefineBlob
	DataDefineClob
	DataDefineNClob
	DataDefineBFile
	DataDefineRowId
	DataDefineURowId
	DataDefineCharacter
	DataDefineCharacterVarying
	DataDefineCharVarying
	DataDefineNCharVarying
	DataDefineVarchar
	DataDefineNationalCharacter
	DataDefineNationalCharacterVarying
	DataDefineNationalChar
	DataDefineNationalCharVarying
	DataDefineNumeric
	DataDefineDecimal
	DataDefineDec
	DataDefineInteger
	DataDefineInt
	DataDefineSmallInt
	DataDefineDoublePrecision
	DataDefineReal
)

type datatype struct {
	typ DataDefine
}

func (d *datatype) DataDefine () DataDefine {
	return d.typ
}

func (d *datatype) SetDataDefine(typ DataDefine) {
	d.typ = typ
}

// Char is "Char" and "Character"
type Char struct {
	datatype
	Size       *int
	IsByteSize bool
	IsCharSize bool
}

// Varchar2 include: "Varchar2", "Char Varying", "Character Varying", "Varchar"
type Varchar2 struct {
	Char
}

// NChar include: "Nchar", "National Character", "National Char".
type NChar struct {
	datatype
	Size      *int
}

// NVarchar2 include: "NVarchar2", "National Character Varying", "National Char Varying", "NChar Varying"
type NVarchar2 struct {
	NChar
}

type Raw struct {
	datatype
	Size *int
}

type RowId struct {
	datatype
}

type URowId struct {
	datatype
	Size *int
}

type Date struct {
	datatype
}

type Timestamp struct {
	datatype
	FractionalSecondsPrecision *int
	WithTimeZone               bool
	WithLocalTimeZone          bool
}

type IntervalYear struct {
	datatype
	Precision *int
}

type IntervalDay struct {
	datatype
	Precision          			*int
	FractionalSecondsPrecision 	*int
}

// Number include: "Number", "Numeric", "Decimal", "Dec", "Integer", "Int", "Smallint";
// Integer is a alias of Number(38);
// Int is  a alias of Number(38);
// Smallint is  a alias of Number(38)
type Number struct {
	datatype
	Precision *NumberOrAsterisk
	Scale     *int
}

// Float is a subtype of Number, include: "Float", "", "DoublePrecision", "Real";
// DoublePrecision is a alias of FLOAT(126);
// Real is a alias of FLOAT(63).
type Float struct {
	datatype
	Precision *NumberOrAsterisk
}

type BinaryFloat struct {
	datatype
}

type BinaryDouble struct {
	datatype
}

type Long struct {
	datatype
}

type LongRaw struct {
	datatype
}

type Blob struct {
	datatype
}

type Clob struct {
	datatype
}

type NClob struct {
	datatype
}

type BFile struct {
	datatype
}