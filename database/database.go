package database

import (
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"github.com/vitaliy-paliy/xumple/models"
)

var Database *gorm.DB

func InitializeDatabase() error {
	var err error
	Database, err = gorm.Open(sqlite.Open("database/database.db"), &gorm.Config{})
	if err != nil {
		return err
	}
	autoMigrateModels()

	return nil
}

func CheckUserInDatabase(user *models.User) *models.Error {
	if res := Database.Find(user, "id = ?", user.ID); res.RowsAffected == 0 {
		return &models.Error{Code: 400, Message: "Bad request"}
	}

	return nil
}

func autoMigrateModels() {
	Database.AutoMigrate(&models.User{})
	Database.AutoMigrate(&models.Transaction{})
}


