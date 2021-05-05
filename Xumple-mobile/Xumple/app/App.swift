//
//  App.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/20/21.
//

import UIKit

class App {

  // "http://localhost:8080/"
  static let website = "http://localhost:8080/"
  
  static private var currentUser: User?
  
  static func setCurrentUser(_ currUser: User) {
    currentUser = currUser
  }
  
  static func getCurrentUser() -> User {
    if currentUser == nil {
      UserDefaults.standard.setIsSignedIn(value: false)
      UserDefaults.standard.removeUser()
      UIApplication.shared.windows.first?.rootViewController = MainViewController()
      UIApplication.shared.windows.first?.makeKeyAndVisible()
      return User(UID: "", username: "", phoneNumber: "")
    }
      return currentUser!
  }
  
}
