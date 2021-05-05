package authcontroller

import (
	"github.com/vitaliy-paliy/xumple/models"
	"github.com/vitaliy-paliy/xumple/database"
	"github.com/vitaliy-paliy/xumple/controllers/walletcontroller"
	"regexp"
	"github.com/stellar/go/keypair"
	"github.com/segmentio/ksuid"
)

func RegisterUser(user *models.User) *models.Error {
	if res := isUserRegistered(user); res != nil {
		return res
	}

	if !isUsernameValid(user.Username) {
		return &models.Error{Code: 400, Message: "Invalid username format"}
	}

	user.ID = ksuid.New().String()

	pair, err := keypair.Random()
	if err != nil {
		return &models.Error{Code: 500, Message: "Internal server error. Try again later"}
	}

	user.WalletAddress = pair.Address()
	user.WalletPrivateKey = pair.Seed()

	walletErr := walletcontroller.FundWallet(user)
	if err != nil {
		return walletErr
	}

	database.Database.Create(user)
	user.WalletAddress = ""
	user.WalletPrivateKey = ""

	return nil
}


func isUserRegistered(user *models.User) *models.Error {
	if res := database.Database.Find(user, "phone_number = ?", user.PhoneNumber); res.RowsAffected != 0 {
		return &models.Error{Code: 400, Message: "User with this phone number already exists"}
	}

	if res := database.Database.Find(&models.User{}, "username = ?", user.Username); res.RowsAffected != 0 {
		return &models.Error{Code: 400, Message: "User with this username already exists"}
    }

	return nil
}

func isUsernameValid(username string) bool {
	rxp, _ := regexp.Compile("^[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*$")
	return (len(username) > 3 && len(username) < 16 && rxp.MatchString(username))
}

func SignInUser(user *models.User) *models.Error {
	if res := database.Database.Find(user, "phone_number = ?", user.PhoneNumber); res.RowsAffected == 0 {
		return &models.Error{Code: 400, Message: "User with this phone number does not exist"}
	}

	user.WalletAddress = ""
	user.WalletPrivateKey = ""
	return nil
}
