package main

import (
	"fmt"
	"net/http"
	"log"
	"sync"
)

var mu sync.Mutex
var count int = 0

func handler(w http.ResponseWriter, r *http.Request) {
	mu.Lock()
	count++
	mu.Unlock()
	fmt.Fprintf(w, "URL.Path=%q\n", r.URL.Path)
}

func handler_count(w http.ResponseWriter, r *http.Request) {
	mu.Lock()
	fmt.Fprintf(w, "Count=%d\n", count)
	mu.Unlock()
}

func main() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/count", handler_count)
	log.Fatal(http.ListenAndServe("localhost:8000", nil))
}