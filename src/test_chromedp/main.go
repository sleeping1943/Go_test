package main

import (
	"context"
	"fmt"
	"log"

	"github.com/chromedp/cdproto/cdp"
	_ "github.com/chromedp/cdproto/runtime"
	"github.com/chromedp/chromedp"
)

var imgValue string
var nodes []*cdp.Node

func main() {
	// 设置项，具体参照参考1
	options := []chromedp.ExecAllocatorOption{
		chromedp.Flag("headless", false),                      // debug使用
		chromedp.Flag("blink-settings", "imagesEnabled=true"), // 启用图片加载
		chromedp.UserAgent(`Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36`),
	}
	options = append(chromedp.DefaultExecAllocatorOptions[:], options...)
	// Chrome初始化代码如下：
	c, _ := chromedp.NewExecAllocator(context.Background(), options...)
	// create context
	ctx, cancel := chromedp.NewContext(c)
	defer cancel()
	startUrl := "https://manhua.fzdm.com/153/205w/"
	// run task list
	var res string
	err := chromedp.Run(ctx, submit(startUrl, &res))
	if err != nil {
		log.Fatal(err)
	}
	ch := make(chan string)
	fmt.Println("imgValue:", imgValue)
	fmt.Println("Visit url:", startUrl)
	for index, node := range nodes {
		src := node.AttributeValue("src")
		href := node.AttributeValue("href")
		fmt.Printf("index[%d]:src[%s] href[%s]\n", index, src, href)
		fmt.Println("Attributes:", node.Attributes)
	}
	// 阻塞等待
	<-ch
}

func submit(urlstr string, res *string) chromedp.Tasks {
	return chromedp.Tasks{
		chromedp.Navigate(urlstr), // 访问指定url
		chromedp.ActionFunc(func(ctx context.Context) error {
			//fmt.Println("before ActionFunc sleep 10s")
			//time.Sleep(10 * time.Second)
			//fmt.Println("after ActionFunc sleep 10s")
			fmt.Println("ready to reload current page")
			return nil
		}),
		chromedp.Reload(),
		chromedp.WaitVisible("#mhpic", chromedp.ByID), // 等待html中某个元素出现
		chromedp.Nodes(`#mhpic`, &nodes),
	}
}
