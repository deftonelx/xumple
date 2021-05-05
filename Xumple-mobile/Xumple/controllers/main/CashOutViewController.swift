//
//  CashOutViewController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 5/2/21.
//

import UIKit

class CashOutViewController: UIViewController {
  
  var networking: WalletNetworking!
  private let errorLabel = UILabel()
  private let cashOutButton = UIButton(type: .system)
  private let moneyTextField = UITextField()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
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

extension CashOutViewController {
  
  private func prepareUI() {
    view.backgroundColor = .white
    prepareMoneyTextField()
    prepareCashOutButton()
    prepareInfoLabel()
    prepareErrorLabel()
  }
  
  private func prepareInfoLabel() {
    let label = UILabel()
    label.textColor = .gray
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont(name: "Poppins-Bold", size: 14)
    label.text = "For the sake of demonstration purposes, the amount cashed out will be sent to a testnet address."
    view.addSubview(label)
    label.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(moneyTextField.snp.top).offset(-16)
      $0.width.equalTo(250)
    })
  }
  
  private func prepareMoneyTextField() {
    moneyTextField.attributedPlaceholder = NSAttributedString(string: "$0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    moneyTextField.textColor = .black
    moneyTextField.textAlignment = .center
    moneyTextField.keyboardType = .decimalPad
    moneyTextField.borderStyle = .none
    moneyTextField.delegate = self
    moneyTextField.font = UIFont(name: "Poppins-Bold", size: 64)
    moneyTextField.becomeFirstResponder()
    
    view.addSubview(moneyTextField)
    moneyTextField.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.left.equalTo(32)
      $0.right.equalTo(-32)
      $0.centerY.equalToSuperview().offset(-32)
    })
  }
  
  private func prepareCashOutButton() {
    cashOutButton.setTitle("CASH OUT", for: .normal)
    cashOutButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 12)
    cashOutButton.layer.cornerRadius = 12
    cashOutButton.tintColor = .white
    cashOutButton.backgroundColor = .black
    cashOutButton.addTarget(self, action: #selector(cashOutButtonPressed), for: .touchUpInside)
    
    view.addSubview(cashOutButton)
    cashOutButton.snp.makeConstraints({
      $0.top.equalTo(moneyTextField.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(35)
      $0.width.equalTo(150)
    })
  }
  
  private func prepareErrorLabel() {
    errorLabel.text = ""
    errorLabel.textColor = .red
    errorLabel.numberOfLines = 0
    errorLabel.textAlignment = .center
    errorLabel.font = UIFont(name: "Poppins-Bold", size: 12)
    
    view.addSubview(errorLabel)
    errorLabel.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.top.equalTo(cashOutButton.snp.bottom).offset(8)
      $0.width.equalTo(150)
    })
  }
  
  @objc private func cashOutButtonPressed() {
    errorLabel.text = ""
    guard let text = moneyTextField.text, !text.isEmpty else {
      errorLabel.text = "Invalid Amount"
      return
    }
    let sIndex = text.index(text.startIndex, offsetBy: 1)
    if let amount = Float(String(text[sIndex..<text.endIndex])) {
      let alertView = UIAlertController(title: nil, message: "Are you sure you want to cash out $\(amount) + $1.1 fee?", preferredStyle: .alert)
      alertView.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
        self.handleCashOut(amount)
      }))
      alertView.addAction(UIAlertAction(title: "NO", style: .destructive, handler: nil))
      present(alertView, animated: true, completion: nil)
    } else {
      errorLabel.text = "Invalid Amount"
    }
  }
  
  private func handleCashOut(_ amount: Float) {
    let loadingView = prepareLoadingView()
    let successOperationView = prepareSuccessOperationView()
    present(loadingView, animated: true, completion: nil)
    networking.cashOut(String(amount)) { (error) in
        self.dismiss(animated: false, completion: nil)
        if error != nil {
          self.errorLabel.text = error!.localizedDescription
        } else {
          self.present(successOperationView, animated: true, completion: nil)
        }
      }
  }
  
}

extension CashOutViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    if text.isEmpty {
      textField.text = "$"
    }
    return true
  }
  
}
