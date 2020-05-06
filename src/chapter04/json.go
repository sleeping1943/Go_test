package main

import (
	"encoding/json"
	"fmt"
)

type Movie struct {
	Title string
	Year int	`json:"released"`
	Color bool	`json:"color,omitempty"`
	Actor []string
}
/*
		{Title:"倩女幽魂", Year:1994, Color:true, Actor:[]string{"张国荣","王祖贤"}},
		{Title:"请回答1988", Year:2005, Color:true, Actor:[]string{"狗焕","成德善"}}
*/
/*
	Go数据结构编码为Json字符串
*/
func PrintLine(movies *[]Movie) {
	data, err := json.Marshal(movies)
	if err != nil {
		fmt.Printf("err:%v\n", err)
		return
	}
	fmt.Printf("%s\n",data)
}

func PrintIndent(movies *[]Movie) {
	data, err := json.MarshalIndent(movies, "", "	")
	if err != nil {
		fmt.Printf("err:%v\n", err)
		return
	}
	fmt.Printf("%s\n",data)
}

/*
	Json字符串解码为Go数据结构
*/
func UnMarshal(json_str *string) {
	var titles []struct{Title string}
	if err := json.Unmarshal([]byte(*json_str), &titles); err != nil {
		fmt.Printf("err:%v\n", err)
		return
	}
	fmt.Printf("%s\n",titles)
}
func main() {
	/*
	var movies = []Movie{
		{Title:"倩女幽魂", Year:1994, Color:true, Actor:[]string{"张国荣","王祖贤"}},
		{Title:"请回答1988", Year:2005, Color:true, Actor:[]string{"狗焕","成德善"}},
	}
	PrintLine(&movies)
	PrintIndent(&movies)
	*/
	var json_str = `[{"Title":"倩女幽魂","released":1994,"color":true,"Actor":["张国荣","王祖贤"]},{"Title":"请回答1988","released":2005,"color":true,"Actor":["狗焕","成德善"]}]`
	UnMarshal(&json_str)
}