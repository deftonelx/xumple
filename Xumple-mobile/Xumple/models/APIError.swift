//
//  APIError.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/19/21.
//

import Foundation

struct APIError: LocalizedError {
  var errorDescription: String? { return msg }
  var httpCODE: Int?
  
  private var msg: String
  private var code: Int
  
  init(descriptipion: String, code: Int) {
    self.msg = descriptipion
    self.code = code
  }
}
