//
//  User.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/19/21.
//

import Foundation
import SwiftJWT

struct User: Codable, Claims {
  let UID: String
  var username: String
  var phoneNumber: String

  private enum CodingKeys: String, CodingKey {
    case username
    case UID = "ID"
    case phoneNumber = "phone_number"
  }

}
