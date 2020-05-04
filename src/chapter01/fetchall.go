package main

import (
	"fmt"
	"os"
	"net/http"
	"io"
	"io/ioutil"
	"time"
)

func main() {
	start := time.Now()
	ch := make(chan string)
	for _,url := range os.Args[1:] {
		go fetch(url, ch)
	}
	for range os.Args[1:] {
		fmt.Println(<-ch)
	}
	fmt.Printf("%.2fs used", time.Since(start).Seconds())
}

func fetch(url string, ch chan<- string) {
	start := time.Now()
	rep,err := http.Get(url)
	if err != nil {
		ch <- fmt.Sprint(err)
		return
	}
	nbytes,err := io.Copy(ioutil.Discard, rep.Body)
	rep.Body.Close()
	if err != nil {
		ch <- fmt.Sprintf("while read %s : %v", url, err)
		return
	}
	secs := time.Since(start).Seconds()
	ch <- fmt.Sprintf("%.2fs %7d %s", secs, nbytes, url)
}