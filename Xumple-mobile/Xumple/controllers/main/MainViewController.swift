//
//  MainViewController.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/19/21.
//

import UIKit

class MainViewController: UIViewController {
  
  private let greetingLabel = UILabel()
  private let balanceView = BalanceView()
  private let transactionView = TransactionView()
  let networking = WalletNetworking()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    getData()
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

extension MainViewController {
  
  private func prepareUI() {
    view.backgroundColor = .white
    navigationController?.navigationBar.tintColor = .black
    navigationController?.navigationBar.barTintColor = .white
    navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    prepareGreetinglabel()
    prepareBalanceView()
    prepareTransactionView()
    prepareExitButton()
  }
    
  private func getData() {
    networking.getTransactions { (error) in
      self.transactionView.updateTransactionsList()
      if error != nil {
        print(error!.localizedDescription)
      }
    }
    networking.getWalletBalance { (balance, error) in
      self.balanceView.setNewBalance(newBalance: balance)
      if error != nil {
        print(error!.localizedDescription)
      }
    }
  }
  
  private func prepareGreetinglabel() {
    let username = App.getCurrentUser().username
    greetingLabel.text = "Hi, \n" + username + "!"
    greetingLabel.textColor = .black
    greetingLabel.font = UIFont(name: "Poppins-Bold", size: 24)
    greetingLabel.numberOfLines = 0
    
    view.addSubview(greetingLabel)
    greetingLabel.snp.makeConstraints({
      $0.left.equalToSuperview().offset(18)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(32)
    })
  }
  
  private func prepareBalanceView() {
    view.addSubview(balanceView)
    balanceView.delegate = self
    balanceView.snp.makeConstraints({
      $0.top.equalTo(greetingLabel.snp.bottom).offset(18)
      $0.height.equalTo(200)
      $0.right.equalToSuperview().offset(-18)
      $0.left.equalToSuperview().offset(18)
    })
  }
  
  private func prepareTransactionView() {
    let label = UILabel()
    label.text = "Recent transactions:"
    label.textColor = .black
    label.textColor = .black
    label.font = UIFont(name: "Poppins-Bold", size: 24)
    view.addSubview(label)
    label.snp.makeConstraints({
      $0.left.equalToSuperview().offset(18)
      $0.top.equalTo(balanceView.snp.bottom).offset(18)
    })
    
    view.addSubview(transactionView)
    transactionView.delegate = self
    transactionView.snp.makeConstraints({
      $0.top.equalTo(label.snp.bottom).offset(8)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-18)
      $0.right.equalToSuperview().offset(-18)
      $0.left.equalToSuperview().offset(18)
    })
    
  }

  private func prepareExitButton() {
    let exitButton = UIButton(type: .system)
    exitButton.setTitle("SIGN OUT", for: .normal)
    exitButton.backgroundColor = UIColor.AppColors.backgroundGray
    exitButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 12)
    exitButton.tintColor = .red
    exitButton.layer.cornerRadius = 4
    exitButton.addTarget(self, action: #selector(signOutButton), for: .touchUpInside)
    
    view.addSubview(exitButton)
    exitButton.snp.makeConstraints({
      $0.right.equalToSuperview().offset(-18)
      $0.width.equalTo(100)
      $0.height.equalTo(35)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(32)
    })
  }
  
  func transactionViewClicked() {
    let controller = TransactionsViewController()
    controller.networking = networking
    show(controller, sender: self)
  }
  
  @objc private func signOutButton() {
    let alertView = UIAlertController(title: "Signing Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
      UserDefaults.standard.signOutUser()
      UserDefaults.standard.setIsSignedIn(value: false)
      self.view.window?.rootViewController = UINavigationController(rootViewController: OTPViewController())
      self.view.window?.makeKeyAndVisible()
    }))
    alertView.addAction(UIAlertAction(title: "NO", style: .destructive, handler: nil))
    present(alertView, animated: true, completion: nil)
  }

}
