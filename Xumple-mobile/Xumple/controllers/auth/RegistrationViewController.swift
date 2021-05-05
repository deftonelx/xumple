//
//  RegistrationViewController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/19/21.
//

import UIKit

class RegistrationViewController: UIViewController {
  
  var networking: AuthNetworking!
  private let usernameTextField = UITextField()
  private let errorLabel = UILabel()
  private let continueButton = UIButton(type: .system)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
  }
  
}

extension RegistrationViewController: UITextFieldDelegate {
  
  private func prepareUI() {
    view.backgroundColor = .white
    navigationController?.navigationBar.tintColor  = .black
    navigationController?.navigationBar.barTintColor = .white
    navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    prepareUsernameTextField()
    prepareContinueButton()
    prepareErrorLabel()
  }
  
  private func prepareUsernameTextField() {
    usernameTextField.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.8)
    usernameTextField.attributedPlaceholder = NSAttributedString(string: "Enter your username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    usernameTextField.textColor = .black
    usernameTextField.textAlignment = .center
    usernameTextField.borderStyle = .none
    usernameTextField.layer.cornerRadius = 16
    usernameTextField.autocorrectionType = .no
    usernameTextField.autocapitalizationType = .none
    usernameTextField.delegate = self
    
    view.addSubview(usernameTextField)
    usernameTextField.snp.makeConstraints({
      $0.centerX.centerY.equalToSuperview()
      $0.width.equalTo(250)
      $0.height.equalTo(48)
    })

  }
    
  private func prepareContinueButton() {
    continueButton.setTitle("CONTINUE", for: .normal)
    continueButton.backgroundColor = .black
    continueButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 12)
    continueButton.tintColor = .white
    continueButton.layer.cornerRadius = 16
    continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
    
    view.addSubview(continueButton)
    continueButton.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.width.equalTo(150)
      $0.height.equalTo(35)
      $0.top.equalTo(usernameTextField.snp.bottom).offset(16)
    })
  }
  
  private func prepareErrorLabel() {
    errorLabel.textColor = .red
    errorLabel.font = UIFont(name: "Helvetica Neue", size: 12)
    errorLabel.textAlignment = .center
    errorLabel.numberOfLines = 0
    
    view.addSubview(errorLabel)
    errorLabel.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.top.equalTo(continueButton.snp.bottom).offset(8)
      $0.width.equalTo(180)
    })
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      if string.rangeOfCharacter(from: NSCharacterSet.uppercaseLetters) != nil {
          return false
      }

      return true
  }
  
  @objc private func continueButtonPressed() {
    errorLabel.text = ""
    guard let username = usernameTextField.text else {
      errorLabel.text = "Invalid username"
      return
    }
    let loadingView = prepareLoadingView()
    present(loadingView, animated: true, completion: nil)
    networking.registerUser(username) { (error) in
      self.dismiss(animated: false, completion: {
        if error != nil {
          self.errorLabel.text = error!.errorDescription
        } else {
          UserDefaults.standard.setIsSignedIn(value: true)
          UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: MainViewController())
          UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
      })
    }
  }
  
}
