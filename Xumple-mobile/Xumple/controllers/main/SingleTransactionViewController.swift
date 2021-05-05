//
//  SingleTransactionViewController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/26/21.
//

import UIKit

class SingleTransactionViewController: UIViewController {
  
  var networking: WalletNetworking!
  var transaction: Transaction!
  private let transactionIDLabel = UILabel()
  private let transactionDateLabel = UILabel()
  private let transactionAmountLabel = UILabel()
  private let transactionSenderLabel = UILabel()
  private let transactionRecipientLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    let uid = transaction.sender == App.getCurrentUser().UID ? transaction.recipient : transaction.sender
    networking.getUserInfo(uid) { (user, error) in
      guard let user = user else {
        print(error!.localizedDescription)
        return
      }
      self.updateData(transactionUser: user)
    }
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

extension SingleTransactionViewController {
  
  private func prepareUI() {
    view.backgroundColor = .white
    prepareIDLabel()
    prepareDateLabel()
    prepareAmountLabel()
    prepareSenderLabel()
    prepareRecipientLabel()
  }
  
  private func prepareIDLabel() {
    transactionIDLabel.text = "Transaction ID:"
    transactionIDLabel.textColor = .black
    transactionIDLabel.font = UIFont(name: "Poppins-Bold", size: 24)
    transactionIDLabel.numberOfLines = 0
    let label = UILabel()
    label.text = transaction.UID
    label.textColor = .gray
    label.font = UIFont(name: "Poppins-Bold", size: 16)
    label.lineBreakMode = .byTruncatingMiddle
    
    view.addSubview(transactionIDLabel)
    transactionIDLabel.snp.makeConstraints({
      $0.left.equalToSuperview().offset(18)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(16)
    })
    transactionIDLabel.addSubview(label)
    label.snp.makeConstraints({
      $0.left.equalToSuperview()
      $0.right.equalTo(view.snp.right).offset(-18)
      $0.top.equalTo(transactionIDLabel.snp.bottom)
    })
    
  }
  
  private func prepareDateLabel() {
    transactionDateLabel.text = "Date:"
    transactionDateLabel.textColor = .black
    transactionDateLabel.font = UIFont(name: "Poppins-Bold", size: 24)
    transactionDateLabel.numberOfLines = 0
    
    let label = UILabel()
    label.text = transaction.date
    label.textColor = .gray
    label.font = UIFont(name: "Poppins-Bold", size: 16)
    
    view.addSubview(transactionDateLabel)
    transactionDateLabel.snp.makeConstraints({
      $0.left.equalToSuperview().offset(18)
      $0.top.equalTo(transactionIDLabel.snp.bottom).offset(36)
    })
    transactionDateLabel.addSubview(label)
    label.snp.makeConstraints({
      $0.left.equalToSuperview()
      $0.right.equalTo(view.snp.right).offset(-18)
      $0.top.equalTo(transactionDateLabel.snp.bottom)
    })
    
  }
  
  private func prepareAmountLabel() {
    transactionAmountLabel.text = "Amount:"
    transactionAmountLabel.textColor = .black
    transactionAmountLabel.font = UIFont(name: "Poppins-Bold", size: 24)
    transactionAmountLabel.numberOfLines = 0
    
    let label = UILabel()
    label.text = "$" + transaction.amount
    label.textColor = .gray
    label.font = UIFont(name: "Poppins-Bold", size: 16)
    
    view.addSubview(transactionAmountLabel)
    transactionAmountLabel.snp.makeConstraints({
      $0.left.equalToSuperview().offset(18)
      $0.top.equalTo(transactionDateLabel.snp.bottom).offset(36)
    })
    transactionAmountLabel.addSubview(label)
    label.snp.makeConstraints({
      $0.left.equalToSuperview()
      $0.right.equalTo(view.snp.right).offset(-18)
      $0.top.equalTo(transactionAmountLabel.snp.bottom)
    })
  }
  
  private func prepareSenderLabel() {
    let label = UILabel()
    label.text = "Sender:"
    label.textColor = .black
    label.font = UIFont(name: "Poppins-Bold", size: 24)
    label.numberOfLines = 0
    
    transactionSenderLabel.textColor = .gray
    transactionSenderLabel.numberOfLines = 0
    transactionSenderLabel.font = UIFont(name: "Poppins-Bold", size: 16)
    
    view.addSubview(label)
    label.snp.makeConstraints({
      $0.left.equalToSuperview().offset(18)
      $0.top.equalTo(transactionAmountLabel.snp.bottom).offset(36)
    })
    label.addSubview(transactionSenderLabel)
    transactionSenderLabel.snp.makeConstraints({
      $0.left.equalToSuperview()
      $0.right.equalTo(view.snp.right).offset(-18)
      $0.top.equalTo(label.snp.bottom)
    })
  }
  
  private func prepareRecipientLabel() {
    let label = UILabel()
    label.text = "Recipient:"
    label.textColor = .black
    label.font = UIFont(name: "Poppins-Bold", size: 24)
    label.numberOfLines = 0
    
    transactionRecipientLabel.textColor = .gray
    transactionRecipientLabel.numberOfLines = 0
    transactionRecipientLabel.font = UIFont(name: "Poppins-Bold", size: 16)
    
    view.addSubview(label)
    label.snp.makeConstraints({
      $0.left.equalToSuperview().offset(18)
      $0.top.equalTo(transactionSenderLabel.snp.bottom).offset(8)
    })
    label.addSubview(transactionRecipientLabel)
    transactionRecipientLabel.snp.makeConstraints({
      $0.left.equalToSuperview()
      $0.right.equalTo(view.snp.right).offset(-18)
      $0.top.equalTo(label.snp.bottom)
    })
  }
  
  private func updateData(transactionUser: User) {
    let currUser = App.getCurrentUser()
    let currentUserText = currUser.username+"\n("+currUser.UID+")"
    let transactionUserText = transactionUser.username+"\n("+transactionUser.UID+")"
    transactionRecipientLabel.text = transaction.recipient == currUser.UID ?  currentUserText : transactionUserText
    transactionSenderLabel.text = transaction.sender == currUser.UID ? currentUserText : transactionUserText
  }
  
}
