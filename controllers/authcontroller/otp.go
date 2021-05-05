package authcontroller

import (
	"crypto/rand"
	"unicode"
	"github.com/sfreiberg/gotwilio"
	"github.com/vitaliy-paliy/xumple/models"
)

const (
	OTPChars   = "0123456789"
	AUTH_TOKEN = "<YOUR_AUTH_TOKEN>"
	ACCOUNT_SID = "<YOUR_ACCOUNT_SID>"
	TWILLIO_PHONE_NUMBER = "<YOUR_TWILLIO_PHONE_NUMBER>"
)

func SendOTP(ph string) (string, *models.Error) {
	twillio := gotwilio.NewTwilioClient(ACCOUNT_SID, AUTH_TOKEN)
	secretCode, err := generateOTP()
	if err != nil {
		return "", &models.Error{Code: 500, Message: "Internal server erorr. Try again later"}
	}
	if !validPhoneNumber(ph) {
		return "", &models.Error{Code: 400, Message: "Invalid phone number format"}
	}
	twillio.SendSMS(TWILLIO_PHONE_NUMBER, ph, "Your OTP code: " + secretCode, "", "")

	return secretCode, nil
}

func validPhoneNumber(ph string) bool {
	if len(ph) != 12 {
		return false
	}

	for _, digit := range ph {
		if !unicode.IsDigit(digit) && string(digit) != "+" {
			return false
		}
	}

	return true
}

func generateOTP() (string, error) {
	buff := make([]byte, 6)
	_, err := rand.Read(buff)
	if err != nil {
		return "", err
	}

	for i := 0; i < 6; i++ {
		buff[i] = OTPChars[int(buff[i])%10]
	}

	return string(buff), nil
}
