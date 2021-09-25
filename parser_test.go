package oralce_sql_parser

import (
	"github.com/sjjian/oralce_sql_parser/ast"
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
	}
	for _, query := range querys {
		stmt, err := Parser(query)
		assert.NoError(t, err, "query: %s", query)
		assert.IsType(t, &ast.AlterTableStmt{}, stmt)
	}
}
