package api

import (
	"github.com/vitaliy-paliy/xumple/handlers"
	"github.com/labstack/echo"
)

func HandleAuthGroup(g *echo.Group) {
	g.GET("/send-otp", handlers.SendOTPHandler)
	g.POST("/register-account", handlers.RegisterAccountHandler)
	g.POST("/sign-in", handlers.SignInHandler)
}

func HandleWalletGroup(g *echo.Group) {
	g.POST("/send-money", handlers.SendMoneyHandler)
	g.POST("/cash-out", handlers.CashOutHandler)
	g.GET("/check-balance", handlers.CheckBalanceHandler)
	g.GET("/get-user-transactions", handlers.GetUserTransactionsHandler)
}

func HandleUserGroup(g *echo.Group) {
	g.GET("/get-user-info", handlers.GetUserInfoHandler)
	g.GET("/get-user-list", handlers.GetUserListHandler)
}

func HandleTestGroup(g *echo.Group) {
	g.GET("/generate-random-users", handlers.GenerateRandomUsersHandler)
}
