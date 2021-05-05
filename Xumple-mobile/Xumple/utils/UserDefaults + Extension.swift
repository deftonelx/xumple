//
//  UserDefaults + Extension.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/20/21.
//

import Foundation

extension UserDefaults {
  
  private enum UserDefaultsKeys: String {
    case userDetails
    case isSignedIn
  }
  
  func setIsSignedIn(value: Bool) {
    UserDefaults.standard.set(value, forKey: UserDefaultsKeys.isSignedIn.rawValue)
    UserDefaults.standard.synchronize()
  }
  
  func signOutUser() {
    UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.userDetails.rawValue)
  }
  
  func isSignedIn() -> Bool {
    return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isSignedIn.rawValue)
  }
  
  func encodeUser(_ user: User) -> Bool {
    if let encodedUser = try? JSONEncoder().encode(user) {
      UserDefaults.standard.set(encodedUser, forKey: UserDefaultsKeys.userDetails.rawValue)
      return true
    }
    return false
  }
  
  func getUser() -> User? {
    if let data = UserDefaults.standard.object(forKey: UserDefaultsKeys.userDetails.rawValue) as? Data {
      if let user = try? JSONDecoder().decode(User.self, from: data) {
        return user
      }
    }
    return nil
  }
  
  func removeUser() {
    UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.userDetails.rawValue)
  }
  
}
