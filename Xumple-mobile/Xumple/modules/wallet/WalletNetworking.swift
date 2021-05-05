//
//  WalletNetworking.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/23/21.
//

import Foundation
import Alamofire
import SwiftJWT

class WalletNetworking {
  
  var transactions = [Transaction]()
  
  private func generateJWT() -> String? {
    var myJWT = JWT(claims: App.getCurrentUser())
    var token: String
    let signer = JWTSigner.hs256(key: Data("obKho61jQd2ryk2yxLIfyVhKixVocNiTpohZ".utf8))
    
    do {
      token = try myJWT.sign(using: signer)
    } catch {
      return nil
    }
    return token
  }
  
  func getWalletBalance(completion: @escaping (String, APIError?) -> Void) {
    guard let token = generateJWT() else {
      completion("-----", APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
      return
    }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
    AF.request(App.website+"wallet/check-balance?ID="+App.getCurrentUser().UID, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
      guard let responseData = response.data, let res = response.response else {
        completion("-----", APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
        return
      }
      let statusCode = res.statusCode
      do {
        if statusCode == 200 {
          let data = try JSONDecoder().decode([String: String].self, from: responseData)
          completion(data["balance"] ?? "-----", nil)
        } else {
          let data = try JSONDecoder().decode(WalletResponse.self, from: responseData)
          completion("-----", APIError(descriptipion: data.message, code: statusCode))
        }
      } catch {
        completion("-----", APIError(descriptipion: error.localizedDescription, code: statusCode))
      }
    }
  }
  
  func getTransactions(completion: @escaping (APIError?) -> Void) {
    guard let token = generateJWT() else {
      completion(APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
      return
    }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
    AF.request(App.website+"wallet/get-user-transactions?ID="+App.getCurrentUser().UID, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
      guard let responseData = response.data, let res = response.response else {
        completion(APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
        return
      }
      
      let statusCode = res.statusCode
      do {
        if statusCode == 200 {
          self.transactions = try JSONDecoder().decode([Transaction].self, from: responseData)
          self.transactions.reverse()
          completion(nil)
        } else {
          let data = try JSONDecoder().decode(WalletResponse.self, from: responseData)
          completion(APIError(descriptipion: data.message, code: statusCode))
        }
      } catch {
        completion(APIError(descriptipion: error.localizedDescription, code: statusCode))
      }
    }
  }
  
  func getUserInfo(_ userID: String, completion: @escaping (User?, APIError?) -> Void) {
    guard let token = generateJWT() else {
      completion(nil, APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
      return
    }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
    AF.request(App.website+"user/get-user-info?ID="+userID, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
      guard let responseData = response.data, let res = response.response else {
        completion(nil, APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
        return
      }
      
      let statusCode = res.statusCode
      do {
        if statusCode == 200 {
          let user = try JSONDecoder().decode(User.self, from: responseData)
          completion(user, nil)
        } else {
          let data = try JSONDecoder().decode(WalletResponse.self, from: responseData)
          completion(nil, APIError(descriptipion: data.message, code: statusCode))
        }
      } catch {
        completion(nil, APIError(descriptipion: error.localizedDescription, code: statusCode))
      }
    }
  }
  
  func getUserList(completion: @escaping([User], APIError?) -> Void) {
    guard let token = generateJWT() else {
      completion([], APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
      return
    }
    
    var users = [User]()
    let headers: HTTPHeaders = ["Authorization": "Bearer " + token]

    AF.request(App.website+"user/get-user-list?ID="+App.getCurrentUser().UID, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
      guard let responseData = response.data, let res = response.response else {
        completion(users, APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
        return
      }
      
      let statusCode = res.statusCode
      do {
        if statusCode == 200 {
          users = try JSONDecoder().decode([User].self, from: responseData)
          completion(users, nil)
        } else {
          let data = try JSONDecoder().decode(WalletResponse.self, from: responseData)
          completion(users, APIError(descriptipion: data.message, code: statusCode))
        }
      } catch {
        completion(users, APIError(descriptipion: error.localizedDescription, code: statusCode))
      }
    }
  }
  
  func sendMoney(_ amount: String, _ recipient: User, completion: @escaping (APIError?) -> Void) {
    guard let token = generateJWT() else {
      completion(APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
      return
    }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
    let params: Parameters = ["amount": amount, "sender": App.getCurrentUser().UID, "recipient": recipient.UID]
    AF.request(App.website+"wallet/send-money", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
      self.handleTransaction(response) { (error) in
        completion(error)
      }
    }
  }
  
  func cashOut(_ amount: String, completion: @escaping (APIError?) -> Void) {
    guard let token = generateJWT() else {
      completion(APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
      return
    }
    
    let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
    let params: Parameters = ["amount": amount, "sender": App.getCurrentUser().UID]
    AF.request(App.website+"wallet/cash-out", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
      self.handleTransaction(response) { (error) in
        completion(error)
      }
    }
  }
  
  private func handleTransaction(_ response: AFDataResponse<Any>, completion: @escaping (APIError?) -> Void) {
    guard let responseData = response.data, let res = response.response else {
      completion(APIError(descriptipion: "Internal server erorr. Please try again later", code: 500))
      return
    }
    
    let statusCode = res.statusCode
    do {
      if statusCode == 200 {
        completion(nil)
      } else {
        let data = try JSONDecoder().decode(WalletResponse.self, from: responseData)
        completion(APIError(descriptipion: data.message, code: statusCode))
      }
    } catch {
      completion(APIError(descriptipion: error.localizedDescription, code: statusCode))
    }
  }
  
}
