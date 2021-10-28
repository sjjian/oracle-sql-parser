package parser

import (
	"fmt"
	"io/ioutil"
	"path/filepath"
	"strings"
	"testing"

	"github.com/sjjian/oracle-sql-parser/ast"
	"github.com/stretchr/testify/assert"
)

func TestParserSQLCoverage(t *testing.T) {
	path := "./test"
	files, err := ioutil.ReadDir(path)
	if err != nil {
		t.Error(err)
		return
	}
	for _, f := range files {
		fmt.Printf("test sql file %s\n", f.Name())
		if !strings.HasSuffix(f.Name(), ".sql") {
			continue
		}
		data, err := ioutil.ReadFile(filepath.Join(path, f.Name()))
		if err != nil {
			t.Error(err)
			return
		}
		query := string(data)
		stmts, err := Parser(query)
		if err != nil {
			t.Error(err)
			return
		}
		for _, stmt := range stmts {
			assert.NotNil(t, stmt)
			assert.Equal(t, len(stmt.Text()) > 0, true)
		}
	}
}

func TestSingleQuery(t *testing.T) {
	stmt, err := Parser(`create table db1.table1 (id number(10))`)
	assert.NoError(t, err)
	assert.Equal(t, 1, len(stmt))
	assert.IsType(t, &ast.CreateTableStmt{}, stmt[0])
	assert.Equal(t, `create table db1.table1 (id number(10))`, stmt[0].Text())

	stmt, err = Parser(`create table db1.table1 (id number(10));`)
	assert.NoError(t, err)
	assert.Equal(t, 1, len(stmt))
	assert.IsType(t, &ast.CreateTableStmt{}, stmt[0])
	assert.Equal(t, `create table db1.table1 (id number(10));`, stmt[0].Text())
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
