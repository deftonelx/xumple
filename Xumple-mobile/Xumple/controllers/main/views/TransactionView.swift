//
//  TransactionView.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/20/21.
//

import UIKit

class TransactionView: UIView {
  
  private let tableView = UITableView()
  private var transactions: [Transaction] = []
  weak var delegate: MainViewController!
  
  init() {
    super.init(frame: .zero)
    prepareUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateTransactionsList() {
    transactions = delegate.networking.transactions
    tableView.isHidden = transactions.isEmpty
    tableView.reloadData()
  }
  
  private func prepareUI() {
    backgroundColor = UIColor.AppColors.backgroundGray
    layer.cornerRadius = 12
    prepareInfoUI()
    prepareTableView()
    tableView.isHidden = transactions.isEmpty
  }
  
  private func prepareInfoUI() {
    let label = UILabel()
    label.text = "NO TRANSACTIONS FOUND"
    label.textAlignment = .center
    label.textColor = .gray
    label.font = UIFont(name: "Poppins-Bold", size: 18)
    
    addSubview(label)
    label.snp.makeConstraints({
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(64)
    })
    
    let imageView = UIImageView(image: UIImage(systemName: "list.bullet.rectangle"))
    imageView.contentMode = .scaleAspectFill
    imageView.tintColor = .gray
    
    addSubview(imageView)
    imageView.snp.makeConstraints({
      $0.width.height.equalTo(64)
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    })
  }
  
  private func prepareTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 110
    tableView.isScrollEnabled = false
    tableView.layer.cornerRadius = 12
    tableView.backgroundColor = UIColor.AppColors.backgroundGray
    tableView.separatorStyle = .none
    tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
    
    addSubview(tableView)
    tableView.snp.makeConstraints({
      $0.top.bottom.left.right.equalToSuperview()
    })
  }
  
}

extension TransactionView: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return transactions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell
    let transaction = transactions[indexPath.row]
    cell?.selectionStyle = .none
    cell?.textLabel?.textColor = .black
    cell?.updateCellInfo(transaction)
    return cell ?? UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate.transactionViewClicked()
  }
  
}
