package parser

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGenKeywordIdent(t *testing.T) {
	testCases := map[string][]byte{
		"a":    []byte("[Aa]"),
		"B":    []byte("[Bb]"),
		"case": []byte("[Cc][Aa][Ss][Ee]"),
		"CASE": []byte("[Cc][Aa][Ss][Ee]"),
		"CaSe": []byte("[Cc][Aa][Ss][Ee]"),
		"a_b":  []byte("[Aa]_[Bb]"),
		"":     nil,
	}
	for input, expect := range testCases {
		actual := genKeywordIdent(input)
		assert.Equal(t, string(expect), string(actual))
	}
}

type genGroupKeywordCase struct {
	expect []byte
	input  []string
}

func TestGenGroupKeywordIdent(t *testing.T) {
	testCases := []genGroupKeywordCase{
		{
			input:  []string{},
			expect: nil,
		},
		{
			input:  []string{"a"},
			expect: []byte("[Aa]"),
		},
		{
			input:  []string{"B"},
			expect: []byte("[Bb]"),
		},
		{
			input:  []string{"a", "B"},
			expect: []byte("[Aa]( |\t|\n|\r)+[Bb]"),
		},
		{
			input:  []string{"a", "B", "CasE"},
			expect: []byte("[Aa]( |\t|\n|\r)+[Bb]( |\t|\n|\r)+[Cc][Aa][Ss][Ee]"),
		},
	}
	for _, c := range testCases {
		actual := genGroupKeywordIdent(c.input...)
		assert.Equal(t, string(c.expect), string(actual))
	}
}
