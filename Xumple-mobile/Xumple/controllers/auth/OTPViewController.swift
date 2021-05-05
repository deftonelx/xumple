//
//  OTPViewController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/18/21.
//

import UIKit
import SnapKit

class OTPViewController: UIViewController {
  
  private let networking = AuthNetworking()
  private let phoneNumberTextField = UITextField()
  private let continueButton = UIButton(type: .system)
  private let errorLabel = UILabel()
  
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

extension OTPViewController {
  
  private func prepareUI() {
    view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
    prepareInfoMenu()
    preparePhoneNumberTextField()
    prepareContinueButton()
    prepareErroLabel()
  }
  
  private func prepareInfoMenu() {
    let xumpleLabel = UILabel()
    xumpleLabel.textColor = .black
    xumpleLabel.text = "XUMPLE"
    xumpleLabel.font = UIFont(name: "Poppins-Bold", size: 48)
    
    view.addSubview(xumpleLabel)
    xumpleLabel.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-75)
    })
        
  }
  
  private func preparePhoneNumberTextField() {
    let infoLabel = UILabel()
    infoLabel.text = "Please enter your phone number"
    infoLabel.textColor = .gray
    infoLabel.textAlignment = .center
    infoLabel.font = UIFont(name: "Poppins-Bold", size: 12)
    
    view.addSubview(infoLabel)
    infoLabel.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.snp.centerY)
    })
    
    phoneNumberTextField.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.8)
    phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "+1-(234)-567-8899", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    phoneNumberTextField.textColor = .black
    phoneNumberTextField.textAlignment = .center
    phoneNumberTextField.borderStyle = .none
    phoneNumberTextField.keyboardType = .numberPad
    phoneNumberTextField.layer.cornerRadius = 16
    
    view.addSubview(phoneNumberTextField)
    phoneNumberTextField.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.width.equalTo(250)
      $0.height.equalTo(48)
      $0.top.equalTo(infoLabel.snp.bottom).offset(8)
    })
  }
  
  private func prepareErroLabel() {
    view.addSubview(errorLabel)
    errorLabel.textColor = .red
    errorLabel.font = UIFont(name: "Helvetica Neue", size: 12)
    errorLabel.textAlignment = .center
    errorLabel.numberOfLines = 0
    
    errorLabel.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.top.equalTo(continueButton.snp.bottom).offset(8)
      $0.width.equalTo(180)
    })
  }
  
  private func prepareContinueButton() {
    continueButton.backgroundColor = .black
    continueButton.setTitle("CONTINUE", for: .normal)
    continueButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 12)
    continueButton.tintColor = .white
    continueButton.layer.cornerRadius = 16
    continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
    
    view.addSubview(continueButton)
    continueButton.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.width.equalTo(150)
      $0.height.equalTo(35)
      $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(16)
    })
  }
  
  @objc private func continueButtonPressed() {
    errorLabel.text = ""
    guard let text = phoneNumberTextField.text else { return }
    if text.count != 11 {
      errorLabel.text = "Phone number should be 11 digits long"
      return
    }
    let loadingView = prepareLoadingView()
    present(loadingView, animated: true, completion: nil)
    networking.sendOTP(text) { (error) in
      self.dismiss(animated: false, completion: {
        if error == nil {
          let controller = OTPVerificationViewController()
          controller.networking = self.networking
          self.show(controller, sender: self)
        } else {
          self.errorLabel.text = error!.errorDescription
        }
      })
    }
  }

}
