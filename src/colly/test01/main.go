package main

import (
	"time"
	"fmt"

	"github.com/PuerkitoBio/goquery"
	"github.com/gocolly/colly"
)

var UrlName = make(map[string]string)
var IsFirst = true
var BaseUrl = "https://manhua.fzdm.com/153/"

func DownloadPage(c *colly.Collector, fileName string, url string) {
	c.OnRequest(func (r *colly.Request) {
		fmt.Printf("OnRequest url[%s]\n", r.URL.String())
	})
	c.OnError(func (_ *colly.Response, err error) {
		fmt.Println("Something went wrong:", err)
	})
	c.OnHTML("div[id=mhimg0]", func (r *colly.HTMLElement) {
		dom := r.DOM
		imgSrc, IsExists := dom.Find("a").Find("img").Attr("src")
		if IsExists != true {
			fmt.Println("OnHTML error: tag is not exists")
			return
		}
		fmt.Println("imgSrc:", imgSrc)
	})
	c.OnResponse(func (r *colly.Response) {
		time.Sleep(6 * time.Second)
		fmt.Println("Page OnRespnse...")
		err := r.Save(fileName)
		if (err != nil) {
			fmt.Println(fileName, " save error:", err)
		} 
	});
	c.Visit(url)
	c.Wait()
}
func main() {
	c := colly.NewCollector()
	
	c.OnRequest(func (r *colly.Request) {
		fmt.Printf("OnRequest url[%s]\n", r.URL.String())
	})
	c.OnError(func(_ *colly.Response, err error) {
		fmt.Println("Something went wrong:", err)
	})
	c.OnHTML("div[id=content]", func (r *colly.HTMLElement) {
		dom := r.DOM
		dom.Find("li").Each(func(i int, selection *goquery.Selection) {
			tag_a := selection.Find("a")
			url,IsExists := tag_a.Attr("href")
			if IsExists != true {
				return
			}
			name := tag_a.Text()
			UrlName[name] = url
			// 下载第一话
			if IsFirst {
				downloadSession := c.Clone()
				requestUrl := BaseUrl+url
				DownloadPage(downloadSession, name+".html", requestUrl)
				fmt.Println("Request Url:", requestUrl)
				IsFirst = false
			}
		})
	})
	c.OnResponse(func (r *colly.Response) {
		err := r.Save(r.FileName())
		if (err != nil) {
			fmt.Println(r.FileName(), " save error:", err)
		}
	});
	c.Visit(BaseUrl)
	//for name, url := range UrlName {
	//	fmt.Printf("%s[%s]\n", name, url)
	//}
	c.Wait()
	fmt.Println("colly test over!")
}