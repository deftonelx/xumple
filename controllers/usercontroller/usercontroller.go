package usercontroller

import (
	"github.com/vitaliy-paliy/xumple/models"
	"github.com/vitaliy-paliy/xumple/database"
)

func GetUserInfo(user *models.User) *models.Error {
	if res := database.Database.Find(user, "ID = ?", user.ID); res.RowsAffected == 0 {
		return &models.Error{Code: 400, Message: "User with this ID does not exist"}
	}

	user.WalletAddress = ""
	user.WalletPrivateKey = ""
	return nil
}

func GetUserList(user *models.User) (*[]models.User, *models.Error) {
	var users []models.User

	result := database.Database.Not("ID = ?", user.ID).Find(&users)
	if result.Error != nil {
		return nil, &models.Error{Code: 500, Message: result.Error.Error()}
	}

	return &users, nil
}
