package tools

import (
	"fmt"
	"github.com/saintfish/chardet"
	"github.com/axgle/mahonia"
)

func TransUTF8(content string) string {
	if len(content) <= 0 {
		return ""
	}
	 detector := chardet.NewTextDetector()
	charset, err := detector.DetectBest([]byte(content))
	if err != nil {
		panic(err)
	}
	oldCharset := charset.Charset 
	if oldCharset == "UTF-8" {
		fmt.Println("charset is UTF-8")
		return content
	}

	srcDecoder := mahonia.NewDecoder(charset.Charset)
	desDecoder := mahonia.NewDecoder("utf-8")
	resStr:= srcDecoder.ConvertString(content)
	_, resBytes, _ := desDecoder.Translate([]byte(resStr), true)
	content = string(resBytes)
	//fmt.Println(strContent)
	charset, err = detector.DetectBest(resBytes)
	if err != nil {
		panic(err)
	}
	fmt.Printf("charset:%s --> %s\n", oldCharset, charset.Charset)
	return content
}