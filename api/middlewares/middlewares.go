package middlewares

import (
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func SetAuthMiddleware(g *echo.Group) {
	g.Use(middleware.JWTWithConfig(middleware.JWTConfig{
		SigningKey: []byte("PvXL1GPo3oAYOuMeqX0Jy9uqpWqx3AAwcHg4"),
	}))
}

func SetInAppMiddleware(gs *[]*echo.Group) {
	for _, g := range *gs {
		g.Use(middleware.JWTWithConfig(middleware.JWTConfig{
			SigningKey: []byte("obKho61jQd2ryk2yxLIfyVhKixVocNiTpohZ"),
		}))
	}
}
