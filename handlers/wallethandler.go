package handlers

import (
	"github.com/vitaliy-paliy/xumple/models"
	"github.com/vitaliy-paliy/xumple/controllers/walletcontroller"
	"github.com/labstack/echo"
	"net/http"
)

func SendMoneyHandler(c echo.Context) error {
	var userInput models.Transaction

	if err := c.Bind(&userInput); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err)
	}

	resp, err := walletcontroller.SendMoney(&userInput)
	if err != nil {
		return c.JSON(err.Code, err)
	}

	return c.JSON(http.StatusOK, resp)
}

func CheckBalanceHandler(c echo.Context) error {
	var user models.User
	user.ID = c.FormValue("ID")

	balance, err := walletcontroller.GetBalance(&user)
	if err != nil {
		return echo.NewHTTPError(err.Code, err)
	}

	return c.JSON(http.StatusOK, balance)
}

func GetUserTransactionsHandler(c echo.Context) error {
	var user models.User
	user.ID = c.FormValue("ID")

	transactions, err := walletcontroller.GetUserTransactions(&user)
	if err != nil {
		return echo.NewHTTPError(err.Code, err)
	}

	return c.JSON(http.StatusOK, transactions)
}

func CashOutHandler(c echo.Context) error {
	var userInput models.Transaction

	if err := c.Bind(&userInput); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err)
	}

	err := walletcontroller.CashOut(&userInput);
	if err != nil {
		return echo.NewHTTPError(err.Code, err)
	}

	return c.JSON(http.StatusOK, nil)
}
