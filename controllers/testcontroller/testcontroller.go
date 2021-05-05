package testcontroller

import (
	"fmt"
	"strings"
	"sync"
	"syreclabs.com/go/faker"
	"github.com/vitaliy-paliy/xumple/models"
	"github.com/vitaliy-paliy/xumple/controllers/authcontroller"
)

func GenerateUsers(count int) {
	fmt.Printf("Starting to generate %d random users\n-----\n", count)
	createdUsers := 0

	var wg sync.WaitGroup
	wg.Add(count)
	for i := 1; i <= count; i++ {
		var user models.User
		user.Username = strings.ToLower(faker.Name().LastName())
		user.PhoneNumber = "+1" + faker.Number().Number(10)
		go func () {
			defer wg.Done()
			err := authcontroller.RegisterUser(&user)
			if err != nil {
				fmt.Printf("Error: %s\n", err.Message)
			} else {
				createdUsers++
			}
			fmt.Printf("Username: %s\nPhone number: %s\n", user.Username, user.PhoneNumber)
			fmt.Println("------")
		}()
	}

	wg.Wait()
	fmt.Printf("Finished. %d/%d random users were created.\n", createdUsers, count)
}
