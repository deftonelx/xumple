//
//  SendMoneyViewController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/30/21.
//

import UIKit

class SendMoneyViewController: UIViewController {
  
  var networking: WalletNetworking!
  private var users = [User]()
  private var searchedUsers = [User]()
  private let tableView = UITableView()
  private let textField = UITextField()
  
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

extension SendMoneyViewController {
  
  private func prepareUI() {
    view.backgroundColor = .white
    prepareTextField()
    prepareTableView()
  }
  
  private func getData() {
    networking.getUserList { (users, error) in
      if error != nil {
        print(error!.localizedDescription)
        return
      }
      self.users = users.sorted(by: { (usr1, usr2) -> Bool in
        return usr1.username < usr2.username
      })
      self.tableView.reloadData()
    }
  }
  
  private func prepareTextField() {
    let tfView = UIView()
    tfView.backgroundColor = UIColor.AppColors.backgroundGray
    textField.delegate = self
    textField.borderStyle = .none
    textField.autocapitalizationType = .none
    textField.backgroundColor = .white
    textField.attributedPlaceholder = NSAttributedString(string: "Enter recipient's username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    textField.textColor = .black
    textField.textAlignment = .center
    textField.borderStyle = .none
    textField.layer.cornerRadius = 8
    
    view.addSubview(tfView)
    tfView.snp.makeConstraints({
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
      $0.right.left.equalToSuperview()
      $0.height.equalTo(50)
    })
    
    tfView.addSubview(textField)
    textField.snp.makeConstraints({
      $0.top.left.equalTo(8)
      $0.bottom.right.equalTo(-8)
    })
    
  }
  
  private func prepareTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)
    tableView.snp.makeConstraints({
      $0.top.equalTo(textField.snp.bottom).offset(8)
      $0.right.left.bottom.equalToSuperview()
    })
  }

}

extension SendMoneyViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let text = textField.text else { return users.count }
    if !searchedUsers.isEmpty || !text.isEmpty {
      return searchedUsers.count
    }
    return users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    var user: User
    user = !searchedUsers.isEmpty ? searchedUsers[indexPath.row] : users[indexPath.row]
    cell.textLabel?.text = user.username
    cell.selectionStyle = .none
    cell.textLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = SendMoneyConfirmationViewController()
    var user: User
    user = !searchedUsers.isEmpty ? searchedUsers[indexPath.row] : users[indexPath.row]
    controller.networking = networking
    controller.recipientUser = user
    show(controller, sender: self)
  }
  
}

extension SendMoneyViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      if string.isEmpty {
        filterUsers(String(text.dropLast()))
      } else {
        filterUsers(text+string)
      }
    }
    return true
  }
  
  private func filterUsers(_ query: String) {
    searchedUsers.removeAll()
    for user in users {
      if user.username.lowercased().starts(with: query.lowercased()) {
        searchedUsers.append(user)
      }
    }
    tableView.reloadData()
  }
  
}
