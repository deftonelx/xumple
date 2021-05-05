//
//  FollowUserViewController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/29/21.
//

import UIKit

class FollowUserViewController: UIViewController {
  
  var networking: WalletNetworking!
  private var users = [User]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    getData()
  }
 
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
}

extension FollowUserViewController {
  
  private func prepareUI() {
    view.backgroundColor = .white
  }
  
  private func getData() {
    networking.getUserList { (_, error) in
      if error != nil {
        print(error!.localizedDescription)
      }
    }
  }
  
}
