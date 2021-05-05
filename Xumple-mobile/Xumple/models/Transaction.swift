//
//  Transaction.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/23/21.
//

import Foundation

struct Transaction: Codable {
  
  let UID: String
  let sender: String
  let recipient: String
  let amount: String
  let date: String
  
  private enum CodingKeys: String, CodingKey {
    case sender, recipient, amount
    case UID = "ID"
    case date = "CreatedAt"
  }
  
}
