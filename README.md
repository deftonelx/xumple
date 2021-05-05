<p align="center">
  <img src="art/art1.png" height="600">
&nbsp; &nbsp; &nbsp; &nbsp;
  <img src="art/art2.png" height="600">
</p>

## HOW TO USE?

1. Install Go [LINK](https://golang.org/).
2. Register an account at [LINK](https://www.twilio.com/).
3. Obtain ```ACCOUNT SID, AUTH TOKEN, and Twillio Phone Number``` and insert it into ```./controllers/authcontroller/otp.go```
4. Run ```go run main.go``` in your terminal.
5. Launch Xumple-mobile project and test the app!

TESTING:
To generate random users use this command ```curl http://localhost:8080/test/generate-random-users?count=10```
