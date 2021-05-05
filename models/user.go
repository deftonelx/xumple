package models

import "gorm.io/gorm"

type User struct {
	gorm.Model
	ID	 				string	`json:"ID"`
	PhoneNumber	 		string	`json:"phone_number"`
	Username	 		string	`json:"username"`
	WalletAddress	 	string	`json:"wallet_address"`
	WalletPrivateKey 	string 	`json:"wallet_private"`
}
