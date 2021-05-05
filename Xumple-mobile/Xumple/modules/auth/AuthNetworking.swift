//
//  AuthNetworking.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/18/21.
//

import Foundation
import Alamofire
import SwiftJWT

class AuthNetworking {
  
  private var phoneNumber = ""
  private var OTPCode = ""
  
  func verifyOTPCode(_ code: String) -> Bool {
    return code == OTPCode
  }
  
  func getPhoneNumber() -> String {
    return phoneNumber
  }
  
  private func generateJWT() -> String? {
    struct MyClaims: Claims { var phoneNumber: String }
    
    var myJWT = JWT(claims: MyClaims(phoneNumber: phoneNumber))
    var token: String
    let signer = JWTSigner.hs256(key: Data("PvXL1GPo3oAYOuMeqX0Jy9uqpWqx3AAwcHg4".utf8))
    
    do {
      token = try myJWT.sign(using: signer)
    } catch {
      return nil
    }
    return token
  }
  
  func sendOTP(_ phoneNumber: String, completion: @escaping (APIError?) -> Void) {
    self.phoneNumber = "+"+phoneNumber
    guard let token = generateJWT() else {
      completion(APIError(descriptipion: "Internal server error. Please try again later", code: 500))
      return
    }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
    AF.request(App.website+"auth/send-otp?phoneNumber="+phoneNumber, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
      guard let responseData = response.data, let response = response.response else {
        completion(APIError(descriptipion: "Internal server error. Please try again later", code: 500))
        return
      }
      let statusCode = response.statusCode
      do {
        let data = try JSONDecoder().decode(AuthResponse.self, from: responseData)
        if data.message == nil && data.otpCode != nil {
          self.OTPCode = data.otpCode!
          completion(nil)
        } else {
          completion(APIError(descriptipion: data.message!, code: statusCode))
        }
      } catch {
        completion(APIError(descriptipion: error.localizedDescription, code: 500))
      }
    }
    
  }
  
  func signInUser(completion: @escaping (APIError?) -> Void) {
    guard let token = generateJWT() else {
      completion(APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
      return
    }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
    let params: Parameters = ["phone_number": phoneNumber]
    AF.request(App.website+"auth/sign-in", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
      completion(self.authHandler(response))
    }
    
  }
  
  func registerUser(_ username: String, completion: @escaping (APIError?) -> Void) {
    guard let token = generateJWT() else {
      completion(APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
      return
    }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
    let params: Parameters = ["phone_number": phoneNumber, "username": username]
    AF.request(App.website+"auth/register-account", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
      completion(self.authHandler(response))
    }
  }
  
  private func authHandler(_ response: AFDataResponse<Any>) -> APIError? {
    guard let responseData = response.data, let res = response.response else {
      return APIError(descriptipion: "Internal server erorr. Please try again later", code: 500)
    }
    let statusCode = res.statusCode
    do {
      if statusCode == 200 {
        let data = try JSONDecoder().decode(User.self, from: responseData)
        if UserDefaults.standard.encodeUser(data), let user = UserDefaults.standard.getUser() {
          App.setCurrentUser(user)
          return nil
        }
        return APIError(descriptipion: "Internal server erorr. Please try again later", code: 500)
      } else {
        let data = try JSONDecoder().decode(AuthResponse.self, from: responseData)
        return APIError(descriptipion: data.message ?? "An error occured", code: statusCode)
      }
    } catch {
      return APIError(descriptipion: error.localizedDescription, code: 500)
    }
  }
  
}
