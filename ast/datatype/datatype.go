package datatype

type Datatype interface {
	LiteralType() Literal
}

const (
	LiteralTypeInt = iota
	LiteralTypeFloat
	LiteralTypeString
)

type Literal struct {
	Type int
	Size int
}

type Char struct {
	Size       *int
	IsByteSize bool
	IsCharSize bool
	IsVarying  bool
}

func (c *Char) LiteralType() Literal {
	return Literal{Type: LiteralTypeString}
}

type Varchar struct {
	Size int
}

type Varchar2 struct {
	Size       *int
	IsByteSize bool
	IsCharSize bool
}

type NChar struct {
	Size      *int
	IsVarying bool
}

type NVarchar2 struct {
	Size *int
}

type Number struct {
	Precision *int
	Scale     *int
}

type BinaryFloat struct {
}

type BinaryDouble struct {
}

type Long struct {
}

type LongRaw struct {
}

type Raw struct {
	Size *int
}

type Data struct {
}

type Timestamp struct {
	FractionalSecondsPrecision *int
	WithTimeZone               bool
	WithLocalTimeZone          bool
}

type IntervalYear struct {
	Precision *int
}

type IntervalDay struct {
	DayPrecision               *int
	FractionalSecondsPrecision *int
}

type Blob struct {
}

type Clob struct {
}

type NClob struct {
}

type BFile struct {
}

type RowId struct {
}

type URowId struct {
	Size *int
}

type Character struct {
	Size      *int
	IsVarying bool
}

type National struct {
	Size        int
	IsCharacter bool
	IsChar      bool
	IsVarying   bool
}

type Numeric struct {
	Precision *int
	Scale     *int
}

type Decimal struct {
	Precision *int
	Scale     *int
}

type Dec struct {
	Precision *int
	Scale     *int
}

type Integer struct {
}

type Int struct {
}

type Smallint struct {
}

type Float struct {
}

type Double struct {
}

type Real struct {
}
