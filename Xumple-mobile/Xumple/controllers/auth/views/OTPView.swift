//
//  OTPView.swift
//  Xumple
//
//  Created by Vitaliy Paliy on 4/18/21.
//

import UIKit

class OTPView: UITextField {
  
  private var labelsArray = [UILabel]()
  private var code = ""
  
  private lazy var tapRecognizer: UITapGestureRecognizer = {
    let recognizer = UITapGestureRecognizer()
    recognizer.addTarget(self, action: #selector(becomeFirstResponder))
    return recognizer
  }()
  
  init() {
    super.init(frame: .zero)
    configureTF()
    configureStackView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getCode() -> String {
    return code
  }
  
  private func configureTF() {
    becomeFirstResponder()
    backgroundColor = .clear
    tintColor = .clear
    textColor = .clear
    keyboardType = .numberPad
    textContentType = .oneTimeCode
    borderStyle = .none
    
    addTarget(self, action: #selector(textDidChange), for: .editingChanged)
  }
  
  private func configureStackView() {
    let stackView = createLabelStackView()
    addSubview(stackView)
    stackView.snp.makeConstraints({
      $0.top.left.equalToSuperview().offset(5)
      $0.bottom.right.equalToSuperview().offset(-5)
    })
    
    addGestureRecognizer(tapRecognizer)
    delegate = self
  }
  
  private func createLabelStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 8
    
    for _ in 1...6 {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textAlignment = .center
      label.font = UIFont(name: "Helvetica Neue Medium", size: 35)
      label.backgroundColor = .lightGray
      label.layer.opacity = 0.75
      label.textColor = .black
      label.isUserInteractionEnabled = true
      label.layer.cornerRadius = 16
      label.clipsToBounds = true
      
      stackView.addArrangedSubview(label)
      labelsArray.append(label)
    }
    
    return stackView
  }
  
  @objc private func textDidChange() {
    guard let text = self.text, text.count <= labelsArray.count else { return }
    code = ""
    for idx in 0..<labelsArray.count {
      let currentLabel = labelsArray[idx]
      if idx < text.count {
        let index = text.index(text.startIndex, offsetBy: idx)
        currentLabel.text = String(text[index])
        code += String(text[index])
      } else {
        currentLabel.text?.removeAll()
      }
    }
  }
  
}

extension OTPView: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let characterCount = textField.text?.count else { return false }
    return characterCount < labelsArray.count || string.isEmpty
  }
}
