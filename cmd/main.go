package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		fmt.Println("hello debugger")
		time.Sleep(time.Second)
		return c.String(http.StatusOK, "Hello, World!")
	})
	e.Logger.Fatal(e.Start(":1323"))
}
