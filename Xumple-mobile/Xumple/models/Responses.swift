//
//  Responses.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/19/21.
//

import Foundation

struct AuthResponse: Codable {
  var message: String?
  var otpCode: String?
  
  private enum CodingKeys: String, CodingKey {
    case otpCode = "otp_code"
    case message
  }
}

struct WalletResponse: Codable {
  var message: String
  var code: Int
}
