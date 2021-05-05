//
//  UIViewController + Extension.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 5/3/21.
//

import UIKit

extension UIViewController {
  
  func prepareLoadingView() -> UIAlertController {
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = .large
    loadingIndicator.startAnimating()

    alert.view.addSubview(loadingIndicator)
    return alert
  }
  
  func prepareSuccessOperationView() -> UIAlertController {
    let alert = UIAlertController(title: nil, message: "Success", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
      _ = self.navigationController?.popViewController(animated: true)
    }))
    return alert
  }
  
}
