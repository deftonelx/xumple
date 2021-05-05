package models

import "gorm.io/gorm"

type Transaction struct {
	gorm.Model
	ID 			string 	`json:"ID"`
	Sender		string 	`json:"sender"`
	Recipient	string 	`json:"recipient"`
	Amount		string	`json:"amount"`
}
