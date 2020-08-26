package main

import (
	"github.com/PuerkitoBio/goquery"
	"github.com/gocolly/colly"
	"fmt"
)

var UrlName = make(map[string]string)

func main() {
	c := colly.NewCollector()
	
	c.OnRequest(func (r *colly.Request) {
		fmt.Printf("OnRequest url[%s]\n", r.URL.String())
	})
	c.OnError(func(_ *colly.Response, err error) {
		fmt.Println("Something went wrong:", err)
	})
	c.OnHTML("div[id=play_0]", func (r *colly.HTMLElement) {
		//fmt.Println("value:", r.Text)
		dom := r.DOM
		dom.Find("a").Each(func(i int, selection *goquery.Selection) {
			url,IsExists := selection.Attr("href")
			if IsExists != true {
				return
			}
			name := selection.Find("p").Text()
			UrlName[name] = url
		})
		//fmt.Println(str)
	})
	c.Visit("http://www.gugu5.com/o/pengyouyouxi/")
	for name, url := range UrlName {
		fmt.Printf("%s[%s]\n", name, url)
	}
	fmt.Println("colly test over!")
}