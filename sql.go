// Code generated by goyacc - DO NOT EDIT.

package oralce_sql_parser

import __yyfmt__ "fmt"

import (
	"github.com/sjjian/oralce_sql_parser/ast"
	"github.com/sjjian/oralce_sql_parser/ast/element"
)

type yySymType struct {
	yys      int
	nothing  struct{}
	i        int
	b        bool
	str      string
	node     ast.Node
	anything interface{}
}

type yyXError struct {
	state, xsym int
}

const (
	yyDefault            = 57401
	yyEofCode            = 57344
	_add                 = 57350
	_alter               = 57348
	_bfile               = 57377
	_binaryDouble        = 57359
	_binaryFloat         = 57358
	_blob                = 57374
	_byte                = 57352
	_char                = 57351
	_character           = 57380
	_clob                = 57375
	_collate             = 57393
	_date                = 57362
	_day                 = 57372
	_dec                 = 57386
	_decimal             = 57385
	_double              = 57390
	_doubleQuoteStr      = 57399
	_float               = 57357
	_from                = 57347
	_int                 = 57388
	_intNumber           = 57397
	_interger            = 57387
	_interval            = 57368
	_invisible           = 57395
	_local               = 57365
	_long                = 57360
	_mouth               = 57371
	_national            = 57383
	_nchar               = 57354
	_nclob               = 57376
	_nonquotedIdentifier = 57400
	_number              = 57356
	_numeric             = 57384
	_nvarchar2           = 57355
	_precision           = 57391
	_raw                 = 57361
	_real                = 57392
	_rowid               = 57378
	_second              = 57373
	_select              = 57346
	_singleQuoteStr      = 57398
	_smallInt            = 57389
	_sort                = 57394
	_table               = 57349
	_time                = 57366
	_timestamp           = 57363
	_to                  = 57370
	_urowid              = 57379
	_varchar             = 57382
	_varchar2            = 57353
	_varying             = 57381
	_visible             = 57396
	_with                = 57364
	_year                = 57369
	_zone                = 57367
	yyErrCode            = 57345

	yyMaxDepth = 200
	yyTabOfs   = -108
)

var (
	yyPrec = map[int]int{}

	yyXLAT = map[int]int{
		41:    0,  // ')' (119x)
		44:    1,  // ',' (87x)
		57395: 2,  // _invisible (76x)
		57396: 3,  // _visible (76x)
		57394: 4,  // _sort (74x)
		57393: 5,  // _collate (70x)
		57397: 6,  // _intNumber (29x)
		40:    7,  // '(' (26x)
		57344: 8,  // $end (22x)
		59:    9,  // ';' (19x)
		57350: 10, // _add (16x)
		46:    11, // '.' (8x)
		57351: 12, // _char (7x)
		42:    13, // '*' (5x)
		57380: 14, // _character (5x)
		57399: 15, // _doubleQuoteStr (5x)
		57400: 16, // _nonquotedIdentifier (5x)
		57361: 17, // _raw (5x)
		57381: 18, // _varying (5x)
		57418: 19, // Identifier (5x)
		57426: 20, // NumberOrAsterisk (5x)
		57377: 21, // _bfile (4x)
		57359: 22, // _binaryDouble (4x)
		57358: 23, // _binaryFloat (4x)
		57374: 24, // _blob (4x)
		57375: 25, // _clob (4x)
		57362: 26, // _date (4x)
		57386: 27, // _dec (4x)
		57385: 28, // _decimal (4x)
		57390: 29, // _double (4x)
		57357: 30, // _float (4x)
		57388: 31, // _int (4x)
		57387: 32, // _interger (4x)
		57368: 33, // _interval (4x)
		57360: 34, // _long (4x)
		57383: 35, // _national (4x)
		57354: 36, // _nchar (4x)
		57376: 37, // _nclob (4x)
		57356: 38, // _number (4x)
		57384: 39, // _numeric (4x)
		57355: 40, // _nvarchar2 (4x)
		57392: 41, // _real (4x)
		57378: 42, // _rowid (4x)
		57389: 43, // _smallInt (4x)
		57363: 44, // _timestamp (4x)
		57370: 45, // _to (4x)
		57379: 46, // _urowid (4x)
		57382: 47, // _varchar (4x)
		57353: 48, // _varchar2 (4x)
		57352: 49, // _byte (2x)
		57371: 50, // _mouth (2x)
		57373: 51, // _second (2x)
		57366: 52, // _time (2x)
		57367: 53, // _zone (2x)
		57402: 54, // AddColumnClause (2x)
		57405: 55, // ChangeColumnClause (2x)
		57410: 56, // ColumnDefinition (2x)
		57412: 57, // ColumnName (2x)
		57417: 58, // DropColumnClause (2x)
		57424: 59, // ModidyColumnClause (2x)
		57429: 60, // RealColumnDefinition (2x)
		57348: 61, // _alter (1x)
		57372: 62, // _day (1x)
		57365: 63, // _local (1x)
		57391: 64, // _precision (1x)
		57349: 65, // _table (1x)
		57364: 66, // _with (1x)
		57369: 67, // _year (1x)
		57403: 68, // AlterTableStmt (1x)
		57404: 69, // AnsiSupportDataTypes (1x)
		57406: 70, // ChangeColumnClauseList (1x)
		57407: 71, // CharacterDataTypes (1x)
		57408: 72, // CollateClause (1x)
		57409: 73, // ColumnClauses (1x)
		57411: 74, // ColumnDefinitionList (1x)
		57413: 75, // ColumnProperties (1x)
		57414: 76, // Datatype (1x)
		57415: 77, // DatetimeDataTypes (1x)
		57416: 78, // DefaultProperties (1x)
		57419: 79, // InvisibleProperty (1x)
		57420: 80, // LargeObjectDataTypes (1x)
		57421: 81, // LongAndRawDataTypes (1x)
		57422: 82, // MemoptimizeReadClause (1x)
		57423: 83, // MemoptimizeWriteClause (1x)
		57425: 84, // NumberDataTypes (1x)
		57427: 85, // OralceBuiltInDataTypes (1x)
		57428: 86, // OutOfLinePartStorageList (1x)
		57430: 87, // RenameColumnClause (1x)
		57431: 88, // RowIdDataTypes (1x)
		57432: 89, // SortProperty (1x)
		57433: 90, // Start (1x)
		57434: 91, // Statement (1x)
		57435: 92, // TableName (1x)
		57401: 93, // $default (0x)
		57347: 94, // _from (0x)
		57346: 95, // _select (0x)
		57398: 96, // _singleQuoteStr (0x)
		57345: 97, // error (0x)
	}

	yySymNames = []string{
		"')'",
		"','",
		"_invisible",
		"_visible",
		"_sort",
		"_collate",
		"_intNumber",
		"'('",
		"$end",
		"';'",
		"_add",
		"'.'",
		"_char",
		"'*'",
		"_character",
		"_doubleQuoteStr",
		"_nonquotedIdentifier",
		"_raw",
		"_varying",
		"Identifier",
		"NumberOrAsterisk",
		"_bfile",
		"_binaryDouble",
		"_binaryFloat",
		"_blob",
		"_clob",
		"_date",
		"_dec",
		"_decimal",
		"_double",
		"_float",
		"_int",
		"_interger",
		"_interval",
		"_long",
		"_national",
		"_nchar",
		"_nclob",
		"_number",
		"_numeric",
		"_nvarchar2",
		"_real",
		"_rowid",
		"_smallInt",
		"_timestamp",
		"_to",
		"_urowid",
		"_varchar",
		"_varchar2",
		"_byte",
		"_mouth",
		"_second",
		"_time",
		"_zone",
		"AddColumnClause",
		"ChangeColumnClause",
		"ColumnDefinition",
		"ColumnName",
		"DropColumnClause",
		"ModidyColumnClause",
		"RealColumnDefinition",
		"_alter",
		"_day",
		"_local",
		"_precision",
		"_table",
		"_with",
		"_year",
		"AlterTableStmt",
		"AnsiSupportDataTypes",
		"ChangeColumnClauseList",
		"CharacterDataTypes",
		"CollateClause",
		"ColumnClauses",
		"ColumnDefinitionList",
		"ColumnProperties",
		"Datatype",
		"DatetimeDataTypes",
		"DefaultProperties",
		"InvisibleProperty",
		"LargeObjectDataTypes",
		"LongAndRawDataTypes",
		"MemoptimizeReadClause",
		"MemoptimizeWriteClause",
		"NumberDataTypes",
		"OralceBuiltInDataTypes",
		"OutOfLinePartStorageList",
		"RenameColumnClause",
		"RowIdDataTypes",
		"SortProperty",
		"Start",
		"Statement",
		"TableName",
		"$default",
		"_from",
		"_select",
		"_singleQuoteStr",
		"error",
	}

	yyTokenLiteralStrings = map[int]string{
		57397: "int number",
		57399: "double quotes string",
		57400: "nonquoted identifier",
		57398: "single quotes string",
	}

	yyReductions = map[int]struct{ xsym, components int }{
		0:   {0, 1},
		1:   {90, 1},
		2:   {91, 1},
		3:   {91, 2},
		4:   {92, 1},
		5:   {92, 3},
		6:   {19, 1},
		7:   {19, 1},
		8:   {68, 6},
		9:   {82, 0},
		10:  {83, 0},
		11:  {73, 1},
		12:  {73, 1},
		13:  {87, 0},
		14:  {70, 1},
		15:  {70, 2},
		16:  {55, 1},
		17:  {55, 1},
		18:  {55, 1},
		19:  {54, 6},
		20:  {59, 0},
		21:  {58, 0},
		22:  {75, 0},
		23:  {86, 0},
		24:  {74, 1},
		25:  {74, 3},
		26:  {56, 1},
		27:  {60, 6},
		28:  {57, 1},
		29:  {72, 0},
		30:  {72, 2},
		31:  {89, 0},
		32:  {89, 1},
		33:  {79, 0},
		34:  {79, 1},
		35:  {79, 1},
		36:  {78, 0},
		37:  {76, 1},
		38:  {76, 1},
		39:  {20, 1},
		40:  {20, 1},
		41:  {85, 1},
		42:  {85, 1},
		43:  {85, 1},
		44:  {85, 1},
		45:  {85, 1},
		46:  {85, 1},
		47:  {71, 1},
		48:  {71, 4},
		49:  {71, 5},
		50:  {71, 5},
		51:  {71, 4},
		52:  {71, 5},
		53:  {71, 5},
		54:  {71, 1},
		55:  {71, 4},
		56:  {71, 4},
		57:  {84, 1},
		58:  {84, 4},
		59:  {84, 6},
		60:  {84, 1},
		61:  {84, 4},
		62:  {84, 1},
		63:  {84, 1},
		64:  {81, 1},
		65:  {81, 2},
		66:  {81, 4},
		67:  {77, 1},
		68:  {77, 1},
		69:  {77, 4},
		70:  {77, 7},
		71:  {77, 8},
		72:  {77, 4},
		73:  {77, 7},
		74:  {77, 4},
		75:  {77, 7},
		76:  {77, 10},
		77:  {77, 7},
		78:  {80, 1},
		79:  {80, 1},
		80:  {80, 1},
		81:  {80, 1},
		82:  {88, 1},
		83:  {88, 1},
		84:  {88, 4},
		85:  {69, 4},
		86:  {69, 5},
		87:  {69, 5},
		88:  {69, 5},
		89:  {69, 4},
		90:  {69, 5},
		91:  {69, 6},
		92:  {69, 5},
		93:  {69, 6},
		94:  {69, 1},
		95:  {69, 4},
		96:  {69, 6},
		97:  {69, 1},
		98:  {69, 4},
		99:  {69, 6},
		100: {69, 1},
		101: {69, 4},
		102: {69, 6},
		103: {69, 1},
		104: {69, 1},
		105: {69, 1},
		106: {69, 2},
		107: {69, 1},
	}

	yyXErrors = map[yyXError]string{}

	yyParseTab = [205][]uint16{
		// 0
		{61: 112, 68: 111, 90: 109, 110},
		{8: 108},
		{8: 107},
		{8: 106, 312},
		{65: 113},
		// 5
		{15: 116, 115, 19: 114, 92: 117},
		{8: 104, 104, 104, 310},
		{102, 102, 102, 102, 102, 8: 102, 102, 102, 102, 102, 14: 102, 17: 102, 21: 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 46: 102, 102, 102},
		{101, 101, 101, 101, 101, 8: 101, 101, 101, 101, 101, 14: 101, 17: 101, 21: 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 46: 101, 101, 101},
		{8: 99, 99, 99, 82: 118},
		// 10
		{8: 98, 98, 98, 83: 119},
		{8: 95, 95, 127, 54: 124, 123, 58: 126, 125, 70: 121, 73: 120, 87: 122},
		{8: 100, 100},
		{8: 97, 97, 127, 54: 124, 309, 58: 126, 125},
		{8: 96, 96},
		// 15
		{8: 94, 94, 94},
		{8: 92, 92, 92},
		{8: 91, 91, 91},
		{8: 90, 90, 90},
		{7: 128},
		// 20
		{15: 116, 115, 19: 133, 56: 130, 132, 60: 131, 74: 129},
		{304, 305},
		{84, 84},
		{82, 82},
		{12: 143, 14: 162, 17: 152, 21: 159, 150, 149, 156, 157, 153, 167, 166, 171, 148, 169, 168, 155, 151, 164, 145, 158, 147, 165, 146, 172, 160, 170, 154, 46: 161, 163, 144, 69: 136, 71: 137, 76: 134, 140, 80: 141, 139, 84: 138, 135, 88: 142},
		// 25
		{12: 80, 14: 80, 17: 80, 21: 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 46: 80, 80, 80},
		{79, 79, 79, 79, 79, 296, 72: 295},
		{71, 71, 71, 71, 71, 71},
		{70, 70, 70, 70, 70, 70},
		{67, 67, 67, 67, 67, 67},
		// 30
		{66, 66, 66, 66, 66, 66},
		{65, 65, 65, 65, 65, 65},
		{64, 64, 64, 64, 64, 64},
		{63, 63, 63, 63, 63, 63},
		{62, 62, 62, 62, 62, 62},
		// 35
		{61, 61, 61, 61, 61, 61, 7: 284, 18: 285},
		{7: 277},
		{54, 54, 54, 54, 54, 54, 7: 270, 18: 271},
		{7: 267},
		{51, 51, 51, 51, 51, 51, 7: 261},
		// 40
		{48, 48, 48, 48, 48, 48, 7: 258},
		{46, 46, 46, 46, 46, 46},
		{45, 45, 45, 45, 45, 45},
		{44, 44, 44, 44, 44, 44, 17: 257},
		{7: 254},
		// 45
		{41, 41, 41, 41, 41, 41},
		{40, 40, 40, 40, 40, 40, 7: 245},
		{62: 224, 67: 223},
		{30, 30, 30, 30, 30, 30},
		{29, 29, 29, 29, 29, 29},
		// 50
		{28, 28, 28, 28, 28, 28},
		{27, 27, 27, 27, 27, 27},
		{26, 26, 26, 26, 26, 26},
		{25, 25, 25, 25, 25, 25, 7: 220},
		{7: 213, 18: 214},
		// 55
		{7: 210},
		{12: 195, 14: 194},
		{14, 14, 14, 14, 14, 14, 7: 188},
		{11, 11, 11, 11, 11, 11, 7: 182},
		{8, 8, 8, 8, 8, 8, 7: 174},
		// 60
		{5, 5, 5, 5, 5, 5},
		{4, 4, 4, 4, 4, 4},
		{3, 3, 3, 3, 3, 3},
		{64: 173},
		{1, 1, 1, 1, 1, 1},
		// 65
		{2, 2, 2, 2, 2, 2},
		{6: 175, 13: 176, 20: 177},
		{69, 69, 11: 69},
		{68, 68, 11: 68},
		{178, 11: 179},
		// 70
		{7, 7, 7, 7, 7, 7},
		{6: 180},
		{181},
		{6, 6, 6, 6, 6, 6},
		{6: 175, 13: 176, 20: 183},
		// 75
		{184, 11: 185},
		{10, 10, 10, 10, 10, 10},
		{6: 186},
		{187},
		{9, 9, 9, 9, 9, 9},
		// 80
		{6: 175, 13: 176, 20: 189},
		{190, 11: 191},
		{13, 13, 13, 13, 13, 13},
		{6: 192},
		{193},
		// 85
		{12, 12, 12, 12, 12, 12},
		{7: 203, 18: 204},
		{7: 196, 18: 197},
		{6: 201},
		{7: 198},
		// 90
		{6: 199},
		{200},
		{15, 15, 15, 15, 15, 15},
		{202},
		{16, 16, 16, 16, 16, 16},
		// 95
		{6: 208},
		{7: 205},
		{6: 206},
		{207},
		{17, 17, 17, 17, 17, 17},
		// 100
		{209},
		{18, 18, 18, 18, 18, 18},
		{6: 211},
		{212},
		{19, 19, 19, 19, 19, 19},
		// 105
		{6: 218},
		{7: 215},
		{6: 216},
		{217},
		{22, 22, 22, 22, 22, 22},
		// 110
		{219},
		{23, 23, 23, 23, 23, 23},
		{6: 221},
		{222},
		{24, 24, 24, 24, 24, 24},
		// 115
		{7: 239, 45: 238},
		{7: 226, 45: 225},
		{51: 234},
		{6: 227},
		{228},
		// 120
		{45: 229},
		{51: 230},
		{33, 33, 33, 33, 33, 33, 7: 231},
		{6: 232},
		{233},
		// 125
		{32, 32, 32, 32, 32, 32},
		{34, 34, 34, 34, 34, 34, 7: 235},
		{6: 236},
		{237},
		{31, 31, 31, 31, 31, 31},
		// 130
		{50: 244},
		{6: 240},
		{241},
		{45: 242},
		{50: 243},
		// 135
		{35, 35, 35, 35, 35, 35},
		{36, 36, 36, 36, 36, 36},
		{6: 246},
		{247},
		{39, 39, 39, 39, 39, 39, 66: 248},
		// 140
		{52: 249, 63: 250},
		{53: 253},
		{52: 251},
		{53: 252},
		{37, 37, 37, 37, 37, 37},
		// 145
		{38, 38, 38, 38, 38, 38},
		{6: 255},
		{256},
		{42, 42, 42, 42, 42, 42},
		{43, 43, 43, 43, 43, 43},
		// 150
		{6: 175, 13: 176, 20: 259},
		{260},
		{47, 47, 47, 47, 47, 47},
		{6: 175, 13: 176, 20: 262},
		{263, 264},
		// 155
		{50, 50, 50, 50, 50, 50},
		{6: 265},
		{266},
		{49, 49, 49, 49, 49, 49},
		{6: 268},
		// 160
		{269},
		{52, 52, 52, 52, 52, 52},
		{6: 275},
		{7: 272},
		{6: 273},
		// 165
		{274},
		{20, 20, 20, 20, 20, 20},
		{276},
		{53, 53, 53, 53, 53, 53},
		{6: 278},
		// 170
		{279, 12: 281, 49: 280},
		{57, 57, 57, 57, 57, 57},
		{283},
		{282},
		{55, 55, 55, 55, 55, 55},
		// 175
		{56, 56, 56, 56, 56, 56},
		{6: 289},
		{7: 286},
		{6: 287},
		{288},
		// 180
		{21, 21, 21, 21, 21, 21},
		{290, 12: 292, 49: 291},
		{60, 60, 60, 60, 60, 60},
		{294},
		{293},
		// 185
		{58, 58, 58, 58, 58, 58},
		{59, 59, 59, 59, 59, 59},
		{77, 77, 77, 77, 299, 89: 298},
		{15: 116, 115, 19: 297},
		{78, 78, 78, 78, 78},
		// 190
		{75, 75, 301, 302, 79: 300},
		{76, 76, 76, 76},
		{72, 72, 78: 303},
		{74, 74},
		{73, 73},
		// 195
		{81, 81},
		{8: 86, 86, 86, 75: 307},
		{15: 116, 115, 19: 133, 56: 306, 132, 60: 131},
		{83, 83},
		{8: 85, 85, 85, 86: 308},
		// 200
		{8: 89, 89, 89},
		{8: 93, 93, 93},
		{15: 116, 115, 19: 311},
		{8: 103, 103, 103},
		{8: 105},
	}
)

var yyDebug = 0

type yyLexer interface {
	Lex(lval *yySymType) int
	Error(s string)
}

type yyLexerEx interface {
	yyLexer
	Reduced(rule, state int, lval *yySymType) bool
}

func yySymName(c int) (s string) {
	x, ok := yyXLAT[c]
	if ok {
		return yySymNames[x]
	}

	if c < 0x7f {
		return __yyfmt__.Sprintf("%q", c)
	}

	return __yyfmt__.Sprintf("%d", c)
}

func yylex1(yylex yyLexer, lval *yySymType) (n int) {
	n = yylex.Lex(lval)
	if n <= 0 {
		n = yyEofCode
	}
	if yyDebug >= 3 {
		__yyfmt__.Printf("\nlex %s(%#x %d), lval: %+v\n", yySymName(n), n, n, lval)
	}
	return n
}

func yyParse(yylex yyLexer) int {
	const yyError = 97

	yyEx, _ := yylex.(yyLexerEx)
	var yyn int
	var yylval yySymType
	var yyVAL yySymType
	yyS := make([]yySymType, 200)

	Nerrs := 0   /* number of errors */
	Errflag := 0 /* error recovery flag */
	yyerrok := func() {
		if yyDebug >= 2 {
			__yyfmt__.Printf("yyerrok()\n")
		}
		Errflag = 0
	}
	_ = yyerrok
	yystate := 0
	yychar := -1
	var yyxchar int
	var yyshift int
	yyp := -1
	goto yystack

ret0:
	return 0

ret1:
	return 1

yystack:
	/* put a state and value onto the stack */
	yyp++
	if yyp >= len(yyS) {
		nyys := make([]yySymType, len(yyS)*2)
		copy(nyys, yyS)
		yyS = nyys
	}
	yyS[yyp] = yyVAL
	yyS[yyp].yys = yystate

yynewstate:
	if yychar < 0 {
		yylval.yys = yystate
		yychar = yylex1(yylex, &yylval)
		var ok bool
		if yyxchar, ok = yyXLAT[yychar]; !ok {
			yyxchar = len(yySymNames) // > tab width
		}
	}
	if yyDebug >= 4 {
		var a []int
		for _, v := range yyS[:yyp+1] {
			a = append(a, v.yys)
		}
		__yyfmt__.Printf("state stack %v\n", a)
	}
	row := yyParseTab[yystate]
	yyn = 0
	if yyxchar < len(row) {
		if yyn = int(row[yyxchar]); yyn != 0 {
			yyn += yyTabOfs
		}
	}
	switch {
	case yyn > 0: // shift
		yychar = -1
		yyVAL = yylval
		yystate = yyn
		yyshift = yyn
		if yyDebug >= 2 {
			__yyfmt__.Printf("shift, and goto state %d\n", yystate)
		}
		if Errflag > 0 {
			Errflag--
		}
		goto yystack
	case yyn < 0: // reduce
	case yystate == 1: // accept
		if yyDebug >= 2 {
			__yyfmt__.Println("accept")
		}
		goto ret0
	}

	if yyn == 0 {
		/* error ... attempt to resume parsing */
		switch Errflag {
		case 0: /* brand new error */
			if yyDebug >= 1 {
				__yyfmt__.Printf("no action for %s in state %d\n", yySymName(yychar), yystate)
			}
			msg, ok := yyXErrors[yyXError{yystate, yyxchar}]
			if !ok {
				msg, ok = yyXErrors[yyXError{yystate, -1}]
			}
			if !ok && yyshift != 0 {
				msg, ok = yyXErrors[yyXError{yyshift, yyxchar}]
			}
			if !ok {
				msg, ok = yyXErrors[yyXError{yyshift, -1}]
			}
			if yychar > 0 {
				ls := yyTokenLiteralStrings[yychar]
				if ls == "" {
					ls = yySymName(yychar)
				}
				if ls != "" {
					switch {
					case msg == "":
						msg = __yyfmt__.Sprintf("unexpected %s", ls)
					default:
						msg = __yyfmt__.Sprintf("unexpected %s, %s", ls, msg)
					}
				}
			}
			if msg == "" {
				msg = "syntax error"
			}
			yylex.Error(msg)
			Nerrs++
			fallthrough

		case 1, 2: /* incompletely recovered error ... try again */
			Errflag = 3

			/* find a state where "error" is a legal shift action */
			for yyp >= 0 {
				row := yyParseTab[yyS[yyp].yys]
				if yyError < len(row) {
					yyn = int(row[yyError]) + yyTabOfs
					if yyn > 0 { // hit
						if yyDebug >= 2 {
							__yyfmt__.Printf("error recovery found error shift in state %d\n", yyS[yyp].yys)
						}
						yystate = yyn /* simulate a shift of "error" */
						goto yystack
					}
				}

				/* the current p has no shift on "error", pop stack */
				if yyDebug >= 2 {
					__yyfmt__.Printf("error recovery pops state %d\n", yyS[yyp].yys)
				}
				yyp--
			}
			/* there is no state on the stack with an error shift ... abort */
			if yyDebug >= 2 {
				__yyfmt__.Printf("error recovery failed\n")
			}
			goto ret1

		case 3: /* no shift yet; clobber input char */
			if yyDebug >= 2 {
				__yyfmt__.Printf("error recovery discards %s\n", yySymName(yychar))
			}
			if yychar == yyEofCode {
				goto ret1
			}

			yychar = -1
			goto yynewstate /* try again in the same state */
		}
	}

	r := -yyn
	x0 := yyReductions[r]
	x, n := x0.xsym, x0.components
	yypt := yyp
	_ = yypt // guard against "declared and not used"

	yyp -= n
	if yyp+1 >= len(yyS) {
		nyys := make([]yySymType, len(yyS)*2)
		copy(nyys, yyS)
		yyS = nyys
	}
	yyVAL = yyS[yyp+1]

	/* consult goto table to find next state */
	exState := yystate
	yystate = int(yyParseTab[yyS[yyp].yys][x]) + yyTabOfs
	/* reduction by production r */
	if yyDebug >= 2 {
		__yyfmt__.Printf("reduce using rule %v (%s), and goto state %d\n", r, yySymNames[x], yystate)
	}

	switch r {
	case 1:
		{
			yylex.(*yyLexImpl).result = yyS[yypt-0].node
		}
	case 2:
		{
			yyVAL.node = yyS[yypt-0].node
		}
	case 3:
		{
			yyVAL.node = yyS[yypt-1].node
		}
	case 4:
		{
			yyVAL.anything = &ast.TableName{
				Table: yyS[yypt-0].anything.(*element.Identifier),
			}
		}
	case 5:
		{
			yyVAL.anything = &ast.TableName{
				Schema: yyS[yypt-2].anything.(*element.Identifier),
				Table:  yyS[yypt-0].anything.(*element.Identifier),
			}
		}
	case 6:
		{
			yyVAL.anything = &element.Identifier{
				Typ:   element.IdentifierTypeNonQuoted,
				Value: yyS[yypt-0].str,
			}
		}
	case 7:
		{
			yyVAL.anything = &element.Identifier{
				Typ:   element.IdentifierTypeQuoted,
				Value: yyS[yypt-0].str,
			}
		}
	case 8:
		{
			yyVAL.node = &ast.AlterTableStmt{
				TableName:     yyS[yypt-3].anything.(*ast.TableName),
				ColumnClauses: yyS[yypt-0].anything.([]ast.ColumnClause),
			}
		}
	case 9:
		{
			// TODO
		}
	case 10:
		{
			// TODO
		}
	case 11:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 12:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 13:
		{
			// todo:
		}
	case 14:
		{
			yyVAL.anything = []ast.ColumnClause{yyS[yypt-0].anything.(ast.ColumnClause)}
		}
	case 15:
		{
			yyVAL.anything = append(yyS[yypt-1].anything.([]ast.ColumnClause), yyS[yypt-0].anything.(ast.ColumnClause))
		}
	case 16:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 17:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 18:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 19:
		{
			yyVAL.anything = &ast.AddColumnClause{
				Columns: yyS[yypt-3].anything.([]*ast.ColumnDefine),
			}
		}
	case 20:
		{
			// todo:
		}
	case 21:
		{
			// todo:
		}
	case 22:
		{
			// TODO
		}
	case 23:
		{
			// TODO
		}
	case 24:
		{
			yyVAL.anything = []*ast.ColumnDefine{yyS[yypt-0].anything.(*ast.ColumnDefine)}
		}
	case 25:
		{
			yyVAL.anything = append(yyS[yypt-2].anything.([]*ast.ColumnDefine), yyS[yypt-0].anything.(*ast.ColumnDefine))
		}
	case 26:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 27:
		{
			var collation *ast.Collation
			if yyS[yypt-3].anything != nil {
				collation = yyS[yypt-3].anything.(*ast.Collation)
			}
			var invisible *ast.InvisibleProperty
			if yyS[yypt-1].anything != nil {
				invisible = yyS[yypt-1].anything.(*ast.InvisibleProperty)
			}

			yyVAL.anything = &ast.ColumnDefine{
				ColumnName:        yyS[yypt-5].anything.(*element.Identifier),
				Datatype:          yyS[yypt-4].anything.(element.Datatype),
				Collation:         collation,
				Sort:              ast.SortProperty(yyS[yypt-2].b),
				InvisibleProperty: invisible,
			}
		}
	case 28:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 29:
		{
			yyVAL.anything = nil
		}
	case 30:
		{
			yyVAL.anything = &ast.Collation{Name: yyS[yypt-0].anything.(*element.Identifier)}
		}
	case 31:
		{
			yyVAL.b = false
		}
	case 32:
		{
			yyVAL.b = true
		}
	case 33:
		{
			yyVAL.anything = nil
		}
	case 34:
		{
			yyVAL.anything = &ast.InvisibleProperty{Type: ast.InvisiblePropertyInvisible}
		}
	case 35:
		{
			yyVAL.anything = &ast.InvisibleProperty{Type: ast.InvisiblePropertyVisible}
		}
	case 37:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 38:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 39:
		{
			yyVAL.anything = &element.NumberOrAsterisk{Number: yyS[yypt-0].i}
		}
	case 40:
		{
			yyVAL.anything = &element.NumberOrAsterisk{IsAsterisk: true}
		}
	case 41:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 42:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 43:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 44:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 45:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 46:
		{
			yyVAL.anything = yyS[yypt-0].anything
		}
	case 47:
		{
			d := &element.Char{}
			d.SetDataDefine(element.DataDefineChar)
			yyVAL.anything = d
		}
	case 48:
		{
			size := yyS[yypt-1].i
			d := &element.Char{Size: &size}
			d.SetDataDefine(element.DataDefineChar)
			yyVAL.anything = d
		}
	case 49:
		{
			size := yyS[yypt-2].i
			d := &element.Char{Size: &size, IsByteSize: true}
			d.SetDataDefine(element.DataDefineChar)
			yyVAL.anything = d
		}
	case 50:
		{
			size := yyS[yypt-2].i
			d := &element.Char{Size: &size, IsCharSize: true}
			d.SetDataDefine(element.DataDefineChar)
			d.SetDataDefine(element.DataDefineChar)
			yyVAL.anything = d
		}
	case 51:
		{
			size := yyS[yypt-1].i
			d := &element.Varchar2{}
			d.Size = &size
			d.SetDataDefine(element.DataDefineVarchar2)
			yyVAL.anything = d
		}
	case 52:
		{
			size := yyS[yypt-2].i
			d := &element.Varchar2{}
			d.Size = &size
			d.IsByteSize = true
			d.SetDataDefine(element.DataDefineVarchar2)
			yyVAL.anything = d
		}
	case 53:
		{
			size := yyS[yypt-2].i
			d := &element.Varchar2{}
			d.Size = &size
			d.IsCharSize = true
			d.SetDataDefine(element.DataDefineVarchar2)
			yyVAL.anything = d
		}
	case 54:
		{
			d := &element.NChar{}
			d.SetDataDefine(element.DataDefineNChar)
			yyVAL.anything = d
		}
	case 55:
		{
			size := yyS[yypt-1].i
			d := &element.NChar{Size: &size}
			d.SetDataDefine(element.DataDefineNChar)
			yyVAL.anything = d
		}
	case 56:
		{
			size := yyS[yypt-1].i
			d := &element.NVarchar2{}
			d.Size = &size
			d.SetDataDefine(element.DataDefineNVarChar2)
			yyVAL.anything = d
		}
	case 57:
		{
			d := &element.Number{}
			d.SetDataDefine(element.DataDefineNumber)
			yyVAL.anything = d
		}
	case 58:
		{
			precision := yyS[yypt-1].anything.(*element.NumberOrAsterisk)
			d := &element.Number{Precision: precision}
			d.SetDataDefine(element.DataDefineNumber)
			yyVAL.anything = d
		}
	case 59:
		{
			precision := yyS[yypt-3].anything.(*element.NumberOrAsterisk)
			scale := yyS[yypt-1].i
			d := &element.Number{Precision: precision, Scale: &scale}
			d.SetDataDefine(element.DataDefineNumber)
			yyVAL.anything = d
		}
	case 60:
		{
			d := &element.Float{}
			d.SetDataDefine(element.DataDefineFloat)
			yyVAL.anything = d
		}
	case 61:
		{
			precision := yyS[yypt-1].anything.(*element.NumberOrAsterisk)
			d := &element.Float{Precision: precision}
			d.SetDataDefine(element.DataDefineFloat)
			yyVAL.anything = d
		}
	case 62:
		{
			d := &element.BinaryFloat{}
			d.SetDataDefine(element.DataDefineBinaryFloat)
			yyVAL.anything = d
		}
	case 63:
		{
			d := &element.BinaryDouble{}
			d.SetDataDefine(element.DataDefineBinaryDouble)
			yyVAL.anything = d
		}
	case 64:
		{
			d := &element.Long{}
			d.SetDataDefine(element.DataDefineLong)
			yyVAL.anything = d
		}
	case 65:
		{
			d := &element.LongRaw{}
			d.SetDataDefine(element.DataDefineLongRaw)
			yyVAL.anything = d
		}
	case 66:
		{
			size := yyS[yypt-1].i
			d := &element.Raw{Size: &size}
			d.SetDataDefine(element.DataDefineRaw)
			yyVAL.anything = d
		}
	case 67:
		{
			d := &element.Date{}
			d.SetDataDefine(element.DataDefineDate)
			yyVAL.anything = d
		}
	case 68:
		{
			d := &element.Timestamp{}
			d.SetDataDefine(element.DataDefineTimestamp)
			yyVAL.anything = d
		}
	case 69:
		{
			precision := yyS[yypt-1].i
			d := &element.Timestamp{FractionalSecondsPrecision: &precision}
			d.SetDataDefine(element.DataDefineTimestamp)
			yyVAL.anything = d
		}
	case 70:
		{
			precision := yyS[yypt-4].i
			d := &element.Timestamp{FractionalSecondsPrecision: &precision, WithTimeZone: true}
			d.SetDataDefine(element.DataDefineTimestamp)
			yyVAL.anything = d
		}
	case 71:
		{
			precision := yyS[yypt-5].i
			d := &element.Timestamp{FractionalSecondsPrecision: &precision, WithLocalTimeZone: true}
			d.SetDataDefine(element.DataDefineTimestamp)
			yyVAL.anything = d
		}
	case 72:
		{
			d := &element.IntervalYear{}
			d.SetDataDefine(element.DataDefineIntervalYear)
			yyVAL.anything = d
		}
	case 73:
		{
			precision := yyS[yypt-3].i
			d := &element.IntervalYear{Precision: &precision}
			d.SetDataDefine(element.DataDefineIntervalYear)
			yyVAL.anything = d
		}
	case 74:
		{
			d := &element.IntervalDay{}
			d.SetDataDefine(element.DataDefineIntervalDay)
			yyVAL.anything = d
		}
	case 75:
		{
			precision := yyS[yypt-3].i
			d := &element.IntervalDay{Precision: &precision}
			d.SetDataDefine(element.DataDefineIntervalDay)
			yyVAL.anything = d
		}
	case 76:
		{
			precision := yyS[yypt-6].i
			sPrecision := yyS[yypt-1].i
			d := &element.IntervalDay{Precision: &precision, FractionalSecondsPrecision: &sPrecision}
			d.SetDataDefine(element.DataDefineIntervalDay)
			yyVAL.anything = d
		}
	case 77:
		{
			sPrecision := yyS[yypt-1].i
			d := &element.IntervalDay{FractionalSecondsPrecision: &sPrecision}
			d.SetDataDefine(element.DataDefineIntervalDay)
			yyVAL.anything = d
		}
	case 78:
		{
			d := &element.Blob{}
			d.SetDataDefine(element.DataDefineBlob)
			yyVAL.anything = d
		}
	case 79:
		{
			d := &element.Clob{}
			d.SetDataDefine(element.DataDefineClob)
			yyVAL.anything = d
		}
	case 80:
		{
			d := &element.NClob{}
			d.SetDataDefine(element.DataDefineNClob)
			yyVAL.anything = d
		}
	case 81:
		{
			d := &element.BFile{}
			d.SetDataDefine(element.DataDefineBFile)
			yyVAL.anything = d
		}
	case 82:
		{
			d := &element.RowId{}
			d.SetDataDefine(element.DataDefineRowId)
			yyVAL.anything = d
		}
	case 83:
		{
			d := &element.URowId{}
			d.SetDataDefine(element.DataDefineURowId)
			yyVAL.anything = d
		}
	case 84:
		{
			size := yyS[yypt-1].i
			d := &element.URowId{Size: &size}
			d.SetDataDefine(element.DataDefineURowId)
			yyVAL.anything = d
		}
	case 85:
		{
			d := &element.Char{}
			d.SetDataDefine(element.DataDefineCharacter)
			yyVAL.anything = d
		}
	case 86:
		{
			size := yyS[yypt-1].i
			d := &element.Varchar2{}
			d.Size = &size
			d.SetDataDefine(element.DataDefineCharacterVarying)
			yyVAL.anything = d
		}
	case 87:
		{
			size := yyS[yypt-1].i
			d := &element.Varchar2{}
			d.Size = &size
			d.SetDataDefine(element.DataDefineCharVarying)
			yyVAL.anything = d
		}
	case 88:
		{
			size := yyS[yypt-1].i
			d := &element.NVarchar2{}
			d.Size = &size
			d.SetDataDefine(element.DataDefineNCharVarying)
			yyVAL.anything = d
		}
	case 89:
		{
			size := yyS[yypt-1].i
			d := &element.Varchar2{}
			d.Size = &size
			d.SetDataDefine(element.DataDefineVarchar)
			yyVAL.anything = d
		}
	case 90:
		{
			size := yyS[yypt-1].i
			d := &element.NChar{Size: &size}
			d.SetDataDefine(element.DataDefineNationalCharacter)
			yyVAL.anything = d
		}
	case 91:
		{
			size := yyS[yypt-1].i
			d := &element.NVarchar2{}
			d.Size = &size
			d.SetDataDefine(element.DataDefineNationalCharacterVarying)
			yyVAL.anything = d
		}
	case 92:
		{
			size := yyS[yypt-1].i
			d := &element.NChar{Size: &size}
			d.SetDataDefine(element.DataDefineNationalChar)
			yyVAL.anything = d
		}
	case 93:
		{
			size := yyS[yypt-1].i
			d := &element.NVarchar2{}
			d.Size = &size
			d.SetDataDefine(element.DataDefineNationalCharVarying)
			yyVAL.anything = d
		}
	case 94:
		{
			d := &element.Number{}
			d.SetDataDefine(element.DataDefineNumeric)
			yyVAL.anything = d
		}
	case 95:
		{
			precision := yyS[yypt-1].anything.(*element.NumberOrAsterisk)
			d := &element.Number{Precision: precision}
			d.SetDataDefine(element.DataDefineNumeric)
			yyVAL.anything = d
		}
	case 96:
		{
			precision := yyS[yypt-3].anything.(*element.NumberOrAsterisk)
			scale := yyS[yypt-1].i
			d := &element.Number{Precision: precision, Scale: &scale}
			d.SetDataDefine(element.DataDefineNumeric)
			yyVAL.anything = d
		}
	case 97:
		{
			d := &element.Number{}
			d.SetDataDefine(element.DataDefineDecimal)
			yyVAL.anything = d
		}
	case 98:
		{
			precision := yyS[yypt-1].anything.(*element.NumberOrAsterisk)
			d := &element.Number{Precision: precision}
			d.SetDataDefine(element.DataDefineDecimal)
			yyVAL.anything = d
		}
	case 99:
		{
			precision := yyS[yypt-3].anything.(*element.NumberOrAsterisk)
			scale := yyS[yypt-1].i
			d := &element.Number{Precision: precision, Scale: &scale}
			d.SetDataDefine(element.DataDefineDecimal)
			yyVAL.anything = d
		}
	case 100:
		{
			d := &element.Number{}
			d.SetDataDefine(element.DataDefineDec)
			yyVAL.anything = d
		}
	case 101:
		{
			precision := yyS[yypt-1].anything.(*element.NumberOrAsterisk)
			d := &element.Number{Precision: precision}
			d.SetDataDefine(element.DataDefineDec)
			yyVAL.anything = d
		}
	case 102:
		{
			precision := yyS[yypt-3].anything.(*element.NumberOrAsterisk)
			scale := yyS[yypt-1].i
			d := &element.Number{Precision: precision, Scale: &scale}
			d.SetDataDefine(element.DataDefineDec)
			yyVAL.anything = d
		}
	case 103:
		{
			precision := &element.NumberOrAsterisk{Number: 38}
			d := &element.Number{Precision: precision}
			d.SetDataDefine(element.DataDefineInteger)
			yyVAL.anything = d
		}
	case 104:
		{
			precision := &element.NumberOrAsterisk{Number: 38}
			d := &element.Number{Precision: precision}
			d.SetDataDefine(element.DataDefineInt)
			yyVAL.anything = d
		}
	case 105:
		{
			precision := &element.NumberOrAsterisk{Number: 38}
			d := &element.Number{Precision: precision}
			d.SetDataDefine(element.DataDefineSmallInt)
			yyVAL.anything = d
		}
	case 106:
		{
			precision := &element.NumberOrAsterisk{Number: 126}
			d := &element.Float{Precision: precision}
			d.SetDataDefine(element.DataDefineDoublePrecision)
			yyVAL.anything = d
		}
	case 107:
		{
			precision := &element.NumberOrAsterisk{Number: 63}
			d := &element.Float{Precision: precision}
			d.SetDataDefine(element.DataDefineReal)
			yyVAL.anything = d
		}

	}

	if yyEx != nil && yyEx.Reduced(r, exState, &yyVAL) {
		return -1
	}
	goto yystack /* stack new state and value */
}
