//
//  TransactionCell.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/20/21.
//

import UIKit

class TransactionCell: UITableViewCell {
  
  private let view = UIView()
  private let senderLabel = UILabel()
  private let recipientLabel = UILabel()
  private let amountLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func prepareUI() {
    backgroundColor = .clear
    view.backgroundColor = .white
    view.layer.cornerRadius = 18
    addSubview(view)
    
    view.snp.makeConstraints({
      $0.top.equalTo(12)
      $0.left.equalTo(8)
      $0.right.equalTo(-8)
      $0.bottom.equalTo(-4)
    })
    
    prepareSenderLabel()
    prepareRecipientLabel()
    prepareAmountLabel()
  }
  
  private func prepareSenderLabel() {
    senderLabel.numberOfLines = 2
    senderLabel.font = UIFont(name: "Poppins-Medium", size: 14)
    senderLabel.textColor = .black
    senderLabel.lineBreakMode = .byTruncatingMiddle
    
    view.addSubview(senderLabel)
    senderLabel.snp.makeConstraints({
      $0.right.equalTo(snp.centerX).offset(-8)
      $0.left.equalTo(8)
      $0.centerY.equalToSuperview()
    })
  }
  
  private func prepareRecipientLabel() {
    recipientLabel.numberOfLines = 2
    recipientLabel.font = UIFont(name: "Poppins-Medium", size: 14)
    recipientLabel.textColor = .black
    recipientLabel.textAlignment = .right
    recipientLabel.lineBreakMode = .byTruncatingMiddle
    
    view.addSubview(recipientLabel)
    recipientLabel.snp.makeConstraints({
      $0.left.equalTo(snp.centerX).offset(8)
      $0.bottom.right.equalTo(-8)
    })
  }
  
  private func prepareAmountLabel() {
    amountLabel.numberOfLines = 2
    amountLabel.font = UIFont(name: "Poppins-Bold", size: 16)
    amountLabel.textColor = .red
    amountLabel.textAlignment = .right
    
    view.addSubview(amountLabel)
    amountLabel.snp.makeConstraints({
      $0.right.equalTo(-8)
      $0.top.equalTo(8)
    })
  }
  
  func updateCellInfo(_ transaction: Transaction) {
    let isSender = transaction.sender == App.getCurrentUser().UID
    amountLabel.text =  isSender ? "-$"+transaction.amount : "+$"+transaction.amount
    amountLabel.textColor =  isSender ? UIColor.red : UIColor.green
    recipientLabel.text = isSender ? "Recipient:\n"+transaction.recipient : "Recipient:\nYOU"
    senderLabel.text = isSender ? "Sender:\nYOU" : "Sender:\n"+transaction.sender
  }
  
}
