//
//  ViewController.swift
//  TMSHomework-Lesson18
//
//  Created by Наталья Мазур on 22.01.24.
//

import UIKit

class ViewController: UIViewController {

    let textField = UITextField()
    let label = UILabel()
    let button = UIButton()
    
    var centerYTextFieldConstraint = NSLayoutConstraint()
    let characterLimit = 20
    let tapViewGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardHiding()
        setupTextField()
        setupButton()
        setupLabel()
    }
    
    func setupKeyboardHiding() {
        tapViewGesture.addTarget(self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapViewGesture)
    }
    
    func setupTextField() {
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите текст"
        textField.keyboardType = .default
        textField.textAlignment = .left
        
        view.addSubview(textField)
        setupTextFieldConstraints()
    }
    
    func setupButton() {
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.setTitle("Передать текст", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        view.addSubview(button)
        setupButtonConstraints()
        
        button.addTarget(self, action: #selector(sendTextToLabel), for: .touchUpInside)
    }
    
    func setupLabel() {
        
        view.addSubview(label)
        setupLabelConstraints()
    }
    
    func setupTextFieldConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        centerYTextFieldConstraint = textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40)
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYTextFieldConstraint,
            textField.widthAnchor.constraint(equalToConstant: 200),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupButtonConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 170),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupLabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -20),
            label.widthAnchor.constraint(equalToConstant: 200),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @objc func keyboardAppeared(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            centerYTextFieldConstraint.isActive = false
            centerYTextFieldConstraint = textField.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-textField.frame.height/2-20-button.frame.height-20)
            centerYTextFieldConstraint.isActive = true
        }
    }
    
    @objc func keyboardDisappeared() {
        centerYTextFieldConstraint.isActive = false
        centerYTextFieldConstraint = textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40)
        centerYTextFieldConstraint.isActive = true
    }
    
    @objc func sendTextToLabel() {
        label.text = textField.text
        textField.text = nil
    }


}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        return newLength <= characterLimit
    }
}

// ДЗ:
//Написать приложение с одним экраном, на котором чуть ниже центра будет располагаться UITextField, ниже UITextField кнопка, а сверху UITextField - UILabel.
//
//При нажатии на кнопку, текст из UITextField будет отображаться в UILabel, UITextField при этом очищается.
//
//Обработать поднятие текстового поля при появлении клавиатуры, чтобы клавиатура не перекрывала текстовое поле.
//
//По нажатию на любое место на экране, скрывать клавиатуру.
