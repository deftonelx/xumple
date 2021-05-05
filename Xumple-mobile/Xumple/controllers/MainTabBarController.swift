//
//  MainTabBarController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/20/21.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    prepareTabBarControllers()
  }
  
}

extension MainTabBarController {
 
  private func prepareTabBarControllers() {
    let mainPage = UINavigationController(rootViewController: MainViewController())
    let settingsPage = UINavigationController(rootViewController: SettingsViewController())
    let imageIcons = ["house", "gearshape.fill"]
    let controllers = [mainPage, settingsPage]
    for idx in 0..<controllers.count {
      controllers[idx].tabBarItem.image = UIImage(systemName: imageIcons[idx])
    }
    viewControllers = controllers
  }
    
  private func prepareUI() {
    tabBar.shadowImage = UIImage()
    tabBar.backgroundImage = UIImage()
    tabBar.tintColor = .black
    tabBar.items?[0].title = "Main"
    tabBar.items?[1].title = "Settings"
  }
  
}
