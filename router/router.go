package router

import (
	"github.com/vitaliy-paliy/xumple/api"
	"github.com/vitaliy-paliy/xumple/api/middlewares"
	"github.com/labstack/echo"
)

func New() *echo.Echo {
	r := echo.New()
	authGroup := r.Group("/auth")
	walletGroup := r.Group("/wallet")
	userGroup := r.Group("/user")
	testGroup := r.Group("/test")

	middlewares.SetAuthMiddleware(authGroup)
	middlewares.SetInAppMiddleware(&[]*echo.Group{walletGroup, userGroup})

	api.HandleAuthGroup(authGroup)
	api.HandleWalletGroup(walletGroup)
	api.HandleUserGroup(userGroup)
	api.HandleTestGroup(testGroup)
	return r
}


