//
//  SettingsViewController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/20/21.
//

import UIKit

class SettingsViewController: UIViewController {
  
  private let signOutButton = UIButton(type: .system)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
}

extension SettingsViewController {
  
  private func prepareUI() {
    view.backgroundColor = .white
    prepareSignOutButton()
  }
  
  private func prepareSignOutButton() {
    signOutButton.backgroundColor = UIColor.AppColors.backgroundGray
    signOutButton.setTitle("SIGN OUT", for: .normal)
    signOutButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 12)
    signOutButton.tintColor = .red
    signOutButton.layer.cornerRadius = 4
    signOutButton.addTarget(self, action: #selector(signOutButtonPressed), for: .touchUpInside)
    
    view.addSubview(signOutButton)
    signOutButton.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.width.equalTo(200)
      $0.height.equalTo(50)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-16)
    })
  }
  
  @objc private func signOutButtonPressed() {
    
  }
  
}
