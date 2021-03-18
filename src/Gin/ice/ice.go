package ice

// Prefix : <返回值>
var Prefix = []string{"int", "void"}

type iceHelper interface {
	ParseIce(path string)
	ParseParams(path string)
	ParseJSON(params string) string
	ReplaceAddr()
}
