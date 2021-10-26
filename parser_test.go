package parser

import (
	"github.com/sjjian/oracle-sql-parser/ast"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestParseAlterTable(t *testing.T) {
	querys := []string{
		`
alter table db1.table1 add (id number)
`,
		`
alter table db1.table1 add (id number, name varchar(255))
`,
		`
alter table db1.table1 add (id number(*))
`,
		`
alter table db1.table1 add (id number(5));
`,
		`
alter table db1.table1 add (id number(5, 3));
`,
		`
alter table db1.table1 add (id float(*))
`,
		`
alter table db1.table1 add (id float(5))
`,
		`
alter table db1.table1 add (id varchar2(255))
`,
		`
alter table db1.table1 add (id varchar2(255) collate binary_ci) 
`,
		`
alter table db1.table1 add (id varchar2(255) sort) 
`,
		`
alter table db1.table1 add (id varchar2(255) collate binary_ci sort) 
`,
		`
alter table db1.table1 add (id varchar2(255) collate binary_ci invisible) 
`,
		`
alter table db1.table1 add (id varchar2(255) collate binary_ci  visible) 
`,
		`
alter table db1.table1 add (id varchar2(255) collate binary_ci sort invisible) 
`,
		`
alter table db1.table1 add (id varchar2(255) default "test") 
`,
		`
alter table db1.table1 add (id number default 123) 
`,
		`
alter table db1.table1 modify (id varchar2(255))
`,
		`
alter table db1.table1 modify (id varchar2(255) default "123")
`,
		`
alter table db1.table1 drop column id
`,
		`
alter table db1.table1 drop (id,name)
`,
		`
alter table db1.table1 set unused column id
`,
		`
alter table db1.table1 rename column id to new_id
`,
	}
	for _, query := range querys {
		stmt, err := Parser(query)
		assert.NoError(t, err, "query: %s", query)
		assert.IsType(t, &ast.AlterTableStmt{}, stmt[0])
	}
}

func TestParseCreateTableStmt(t *testing.T) {
	querys := []string{
		`
create table db1.table1 (id number(10));create table db1.table1 (id number(10), name varchar2(255));
`,
`
CREATE TABLE "TEST"."T1"
   (    "ID" NUMBER(*,0)
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"
`,
	}
	for _, query := range querys {
		stmt, err := Parser(query)
		assert.NoError(t, err, "query: %s", query)
		assert.IsType(t, &ast.CreateTableStmt{}, stmt[0])
	}
}

func TestSingleQuery(t *testing.T) {
	stmt, err := Parser(`create table db1.table1 (id number(10))`)
	assert.NoError(t, err)
	assert.Equal(t, 1, len(stmt))
	assert.IsType(t, &ast.CreateTableStmt{}, stmt[0])
	assert.Equal(t, `create table db1.table1 (id number(10))`, stmt[0])

	stmt, err = Parser(`create table db1.table1 (id number(10));`)
	assert.NoError(t, err)
	assert.Equal(t, 1, len(stmt))
	assert.IsType(t, &ast.CreateTableStmt{}, stmt[0])
	assert.Equal(t, `create table db1.table1 (id number(10));`, stmt[0])
}

func TestMultiQuery(t *testing.T) {
	stmt, err := Parser(`create table db1.table1 (id number(10));
alter table db1.table1 add (name varchar(255))`)
	assert.NoError(t, err)
	assert.Equal(t, 2, len(stmt))
	assert.IsType(t, &ast.CreateTableStmt{}, stmt[0])
	assert.Equal(t, "create table db1.table1 (id number(10));", stmt[0].Text())
	assert.IsType(t, &ast.AlterTableStmt{}, stmt[1])
	assert.Equal(t, "alter table db1.table1 add (name varchar(255))", stmt[1].Text())

	stmt, err = Parser(`create table db1.table1 (id number(10));
alter table db1.table1 add (name varchar(255));`)
	assert.NoError(t, err)
	assert.Equal(t, 2, len(stmt))
	assert.IsType(t, &ast.CreateTableStmt{}, stmt[0])
	assert.Equal(t, "create table db1.table1 (id number(10));", stmt[0].Text())
	assert.IsType(t, &ast.AlterTableStmt{}, stmt[1])
	assert.Equal(t, "alter table db1.table1 add (name varchar(255));", stmt[1].Text())
}