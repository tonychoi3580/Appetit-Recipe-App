//
//  LoginCell.swift
//  audible
//
//  Created by Brian Voong on 9/17/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    var User = UserController()

    let logoImageView: UIImageView = {
        let image = UIImage(named: "appetit")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter email"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter password"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(displayP3Red: 5/255.0, green: 50/255.0, blue: 103/255.0, alpha: 1)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(UIColor(displayP3Red: 252.0/255.0, green: 244.0/255.0, blue: 236.0/255.0, alpha: 1), for: .normal)
        button.layer.cornerRadius = 25.0;
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Error"
        label.textAlignment = .center
        label.textColor = .red
        label.font = label.font.withSize(15)
        label.alpha = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 3
        return label
    }()
    
    weak var delegate: SwipingControllerDelegate?
    
    @objc func handleLogin() {
        let error = validateFeilds()
        if error != nil{
            errorLabel.text = error!
            errorLabel.alpha = 1
        }
        else{
            UserDefaults.standard.setEmail(value: emailTextField.text ?? "No Email")
            UserDefaults.standard.setWord(value: passwordTextField.text ?? "No Password")
            errorLabel.alpha = 0
            emailTextField.text = ""
            passwordTextField.text = ""
            delegate?.finishLoggingIn()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func validateFeilds() -> String?{
        
        //Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" && passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" && passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            return "Please enter Email"
        }
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter Password"
        }
        
        //#####Insert code here to check if users is in the database######//
        if checkUserDatabase() == false{
            return "User does not exist. Please make sure your email address and password is correct"
        }
        //#####Insert code here to check if users is in the database######//
        
        return nil
    }
    
    func checkUserDatabase() -> Bool {
        do {
            return try self.User.isValidUser(email: self.emailTextField.text!, password: self.passwordTextField.text!)
        } catch {
            return false
        }
    }
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't Have Account. Sign Up", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(signUpPage), for: .touchUpInside)
        return button
    }()
    
    @objc func signUpPage() {
        self.endEditing(true)
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let mainNavigationController = rootViewController as? MainNavigationController else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigninViewController") as UIViewController
        
        
        let transition = CATransition()
        transition.duration = 0.75
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        mainNavigationController.view.layer.add(transition, forKey: kCATransition)
        
        //mainNavigationController.view.layer.add(transition, forKey: nil)
        mainNavigationController.pushViewController(vc, animated: false)
        
        //mainNavigationController.pushViewController(vc, animated: true)
        //mainNavigationController.setNavigationBarHidden(false, animated: true)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.backgroundColor = CGColor(srgbRed: 252.0/255.0, green: 244.0/255.0, blue: 236.0/255.0, alpha: 1)
            
        addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(signUpButton)
        addSubview(errorLabel)
        
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(230)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(160)
            make.width.equalTo(350)
            
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(8)
            make.left.equalTo(42)
            make.right.equalTo(-42)
            make.height.equalTo(35)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.left.equalTo(42)
            make.right.equalTo(-42)
            make.height.equalTo(35)
            
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.left.equalTo(42)
            make.right.equalTo(-42)
            make.height.equalTo(50)
            
        }
        
        signUpButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.left.equalTo(92)
            make.right.equalTo(-92)
            make.height.equalTo(50)
            
        }
        
        errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(signUpButton.snp.bottom).offset(16)
            make.centerX.equalTo(snp.centerX)
            make.right.equalTo(snp.right).offset(-20)
            make.left.equalTo(snp.left).offset(20)
            make.height.equalTo(50)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LeftPaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
}
