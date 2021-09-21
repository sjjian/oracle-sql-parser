package oralce_sql_parser

import (
	"github.com/sjjian/oralce_sql_parser/ast"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestParser(t *testing.T) {
	stmt, err := Parser("alter table db1.table1 add (id varchar2(255))")
	assert.NoError(t, err)
	assert.IsType(t, &ast.AlterTableStmt{}, stmt)
}
