package handlers

import (
	"github.com/vitaliy-paliy/xumple/models"
	"github.com/vitaliy-paliy/xumple/controllers/usercontroller"
	"github.com/labstack/echo"
	"net/http"
)

func GetUserInfoHandler(c echo.Context) error {
	var user models.User
	user.ID = c.FormValue("ID")

	err := usercontroller.GetUserInfo(&user)
	if err != nil {
		return c.JSON(err.Code, err)
	}

	return c.JSON(http.StatusOK, user)
}

func GetUserListHandler(c echo.Context) error {
	var user models.User
	user.ID = c.FormValue("ID")

	users, err := usercontroller.GetUserList(&user)

	if err != nil {
		return c.JSON(err.Code, err)
	}

	return c.JSON(http.StatusOK, users)
}
