//
//  TransactionsViewController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/24/21.
//

import UIKit

class TransactionsViewController: UIViewController {
  
  private let tableView = UITableView()
  var networking: WalletNetworking!
  private var transactions = [Transaction]()
  
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

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
  
  private func prepareUI() {
    view.backgroundColor = .white
    navigationItem.title = "Transactions"
    prepareTableView()
  }
  
  private func getData() {
    networking.getTransactions { (error) in
      if error != nil {
        print(error!.localizedDescription)
      }
      self.transactions = self.networking.transactions
      self.tableView.reloadData()
    }
  }
  
  private func prepareTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 110
    tableView.backgroundColor = UIColor.AppColors.backgroundGray
    tableView.separatorStyle = .none
    tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints({
      $0.top.bottom.left.right.equalToSuperview()
    })
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return transactions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell
    let transaction = transactions[indexPath.row]
    cell?.selectionStyle = .none
    cell?.updateCellInfo(transaction)
    return cell ?? UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = SingleTransactionViewController()
    controller.networking = networking
    controller.transaction = transactions[indexPath.row]
    show(controller, sender: self)
  }
  
}
