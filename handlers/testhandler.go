package handlers

import (
	"net/http"
	"github.com/labstack/echo"
	"github.com/vitaliy-paliy/xumple/controllers/testcontroller"
	"strconv"
)

func GenerateRandomUsersHandler(c echo.Context) error {
	numberOfUsers, err := strconv.Atoi(c.FormValue("count"))
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	testcontroller.GenerateUsers(numberOfUsers)

	return c.JSON(http.StatusOK, nil)
}
