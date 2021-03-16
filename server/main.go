package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

func hello() int {
	return 2
}

var x = hello()

func greet(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		panic(err)
	}
	fmt.Println(string(body))
	fmt.Println(r.URL.Query())
	fmt.Fprintf(w, "Hello World! %s", time.Now())
}

func main() {
	http.HandleFunc("/", greet)
	http.ListenAndServe(":8080", nil)
}
