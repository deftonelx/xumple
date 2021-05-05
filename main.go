package main

import (
	"github.com/vitaliy-paliy/xumple/database"
	"github.com/vitaliy-paliy/xumple/router"
)

func main() {
	err := database.InitializeDatabase()
	if err != nil {
		panic(err)
	}
	r := router.New()
	r.Logger.Fatal(r.Start(":8080"))
}
