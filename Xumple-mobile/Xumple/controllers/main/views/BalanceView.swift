//
//  BalanceView.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/20/21.
//

import UIKit

class BalanceView: UIView {
  
  weak var delegate: MainViewController!
  private let balanceLabel = UILabel()
  private let infoLabel = UILabel()
  private let sendButton = UIButton(type: .system)
  private let cashOutButton = UIButton(type: .system)
  private let buttonStack = UIStackView()
  
  init() {
    super.init(frame: .zero)
    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func prepareUI() {
    backgroundColor = UIColor.AppColors.backgroundGray
    layer.cornerRadius = 12
    prepareBalanceLabel()
    prepareButtonStack()
  }
  
  func setNewBalance(newBalance: String) {
    let balance = Double(newBalance) ?? 0.00
    balanceLabel.text = "$" + String(format: "%.2f", floor(balance*100)/100)
  }
  
  private func prepareBalanceLabel() {
    balanceLabel.text = "-----"
    balanceLabel.textColor = .black
    balanceLabel.textAlignment = .center
    balanceLabel.font = UIFont(name: "Poppins-Bold", size: 36)
    addSubview(balanceLabel)
    balanceLabel.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(32)
    })
    
    infoLabel.text = "CURRENT BALANCE"
    infoLabel.textColor = .gray
    infoLabel.font = UIFont(name: "Poppins-Bold", size: 12)
    addSubview(infoLabel)
    infoLabel.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.top.equalTo(balanceLabel.snp.bottom)
    })
    
  }
  
  private func prepareButtonStack() {
    let buttons = [sendButton, cashOutButton]
    let text = ["SEND MONEY", "CASH OUT"]
    
    sendButton.addTarget(self, action: #selector(sendMoneyButtonPressed), for: .touchUpInside)
    cashOutButton.addTarget(self, action: #selector(cashOutButtonPressed), for: .touchUpInside)

    buttonStack.alignment = .fill
    buttonStack.distribution = .fillEqually
    buttonStack.spacing = 8.0
    
    for idx in 0...1 {
      buttons[idx].setTitle(text[idx], for: .normal)
      buttons[idx].tintColor = .black
      buttons[idx].titleLabel?.font = UIFont(name: "Poppins-Bold", size: 12)
      buttons[idx].backgroundColor = .white
      buttons[idx].layer.cornerRadius = 16
      buttons[idx].translatesAutoresizingMaskIntoConstraints = false
      buttons[idx].snp.makeConstraints({
        $0.width.equalTo(100)
        $0.height.equalTo(32)
      })
      buttonStack.addArrangedSubview(buttons[idx])
    }
    
    addSubview(buttonStack)
    buttonStack.snp.makeConstraints({
      $0.top.equalTo(infoLabel.snp.bottom).offset(48)
      $0.centerX.equalToSuperview()
    })
    
  }

  @objc private func sendMoneyButtonPressed() {
    let controller = SendMoneyViewController()
    controller.networking = delegate.networking
    delegate.show(controller, sender: delegate)
  }
  
  @objc private func cashOutButtonPressed() {
    let controller = CashOutViewController()
    controller.networking = delegate.networking
    delegate.show(controller, sender: delegate)
  }
  
}
