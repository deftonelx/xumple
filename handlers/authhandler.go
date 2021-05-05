package handlers

import (
	"github.com/labstack/echo"
	"github.com/vitaliy-paliy/xumple/controllers/authcontroller"
	"github.com/vitaliy-paliy/xumple/models"
	"net/http"
)

func RegisterAccountHandler(c echo.Context) error {
	var userInput models.User
	if err := c.Bind(&userInput); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := authcontroller.RegisterUser(&userInput)
	if err != nil {
		return c.JSON(err.Code, err)
	}

	return c.JSON(http.StatusOK, userInput)
}

func SignInHandler(c echo.Context) error {
	var userInput models.User
	if err := c.Bind(&userInput); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := authcontroller.SignInUser(&userInput)
	if err != nil {
		return c.JSON(err.Code, err)
	}

	return c.JSON(http.StatusOK, userInput)
}

func SendOTPHandler(c echo.Context) error {
	code, err := authcontroller.SendOTP("+"+c.FormValue("phoneNumber"))
	if err != nil {
		return echo.NewHTTPError(err.Code, err)
	}

	return c.JSON(http.StatusOK, map[string]string{"otp_code": code})
}
