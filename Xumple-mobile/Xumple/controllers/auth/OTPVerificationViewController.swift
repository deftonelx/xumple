//
//  OTPVerificationViewController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/18/21.
//

import UIKit

class OTPVerificationViewController: UIViewController {
  
  var networking: AuthNetworking!
  private let otpView = OTPView()
  private let verificationButton = UIButton(type: .system)
  private let errorLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
  }
  
}

extension OTPVerificationViewController {
  
  private func prepareUI() {
    view.backgroundColor = .white
    navigationController?.navigationBar.tintColor  = .black
    navigationController?.navigationBar.barTintColor = .white
    navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    prepareInfoLabel()
    prepareOTPView()
    prepareVerifyButton()
    prepareErrorLabel()
  }
  
  private func prepareInfoLabel() {
    let infoLabel = UILabel()
    infoLabel.text = "We just sent an SMS \nwith a code to this phone number: " + networking.getPhoneNumber() + "\nPlease enter it below."
    infoLabel.numberOfLines = 0
    infoLabel.textAlignment = .center
    infoLabel.textColor = .gray
    infoLabel.font = UIFont(name: "Poppins-Bold", size: 12)
    
    view.addSubview(infoLabel)
    infoLabel.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.snp.centerY).offset(-100)
    })
  }
  
  private func prepareOTPView() {
    view.addSubview(otpView)
    
    otpView.snp.makeConstraints({
      $0.centerX.centerY.equalToSuperview()
      $0.height.equalTo(70)
      $0.width.equalTo(320)
    })
  }
  
  private func prepareVerifyButton() {
    verificationButton.setTitle("VERIFY", for: .normal)
    verificationButton.backgroundColor = .black
    verificationButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 12)
    verificationButton.tintColor = .white
    verificationButton.layer.cornerRadius = 16
    verificationButton.addTarget(self, action: #selector(verifyButtonPressed), for: .touchUpInside)
    
    view.addSubview(verificationButton)
    verificationButton.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.width.equalTo(150)
      $0.height.equalTo(35)
      $0.top.equalTo(otpView.snp.bottom).offset(16)
    })
    
  }
  
  private func prepareErrorLabel() {
    view.addSubview(errorLabel)
    errorLabel.textColor = .red
    errorLabel.font = UIFont(name: "Helvetica Neue", size: 12)
    errorLabel.textAlignment = .center
    errorLabel.numberOfLines = 0
    
    errorLabel.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.top.equalTo(verificationButton.snp.bottom).offset(8)
      $0.width.equalTo(180)
    })
  }
  
  @objc private func verifyButtonPressed() {
    errorLabel.text = ""
    if networking.verifyOTPCode(otpView.getCode()) {
      networking.signInUser { (error) in
        if error != nil {
          if error!.localizedDescription == "User with this phone number does not exist" {
            let controller = RegistrationViewController()
            controller.networking = self.networking
            self.show(controller, sender: self)
          } else {
            self.errorLabel.text = error!.errorDescription
          }
        } else {
          UserDefaults.standard.setIsSignedIn(value: true)
          UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: MainViewController())
          UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
      }
    } else {
      errorLabel.text = "Incorrect OTP"
    }
  }
  
}
