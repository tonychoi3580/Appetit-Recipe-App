//
//  SigninViewController.swift
//  appetit
//
//  Created by Frank Hu on 3/28/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController, UITextFieldDelegate {
    
    var newUser = UserController()

    @IBAction func backSignIn(_ sender: Any) {
        UserDefaults.standard.setIsLoggedIn(value: false)
        let transition = CATransition()
        transition.duration = 0.75
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBOutlet weak var FirstTextField: UITextField!
    @IBOutlet weak var LastTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
    @IBOutlet weak var maxCalories: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func createButton(_ sender: Any) {
        let error = validateCreateFeilds()
        if error != nil{
            errorLabel.text = error!
            errorLabel.alpha = 1
        }
        else{
            errorLabel.alpha = 0
            self.view.endEditing(true)
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            guard let mainNavigationController = rootViewController as? MainNavigationController else { return }
            

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! UITabBarController
            mainNavigationController.view.layer.add(transition, forKey: nil)
            mainNavigationController.viewControllers = [SwipingController(), tabBarController]
            
            //mainNavigationController.pushViewController(HomeController(), animated: true)
            UserDefaults.standard.setIsLoggedIn(value: true)
            UserDefaults.standard.setEmail(value: emailTextField.text ?? "No Email")
            UserDefaults.standard.setWord(value: passwordTextField.text ?? "No Password")
            UserDefaults.standard.setFirstName(value: FirstTextField.text ?? "No First Name")
            UserDefaults.standard.setLastName(value: LastTextField.text ?? "No Last Name")
            UserDefaults.standard.setMaxCal(value: maxCalories.text ?? "No Max Cal")

            dismiss(animated: true, completion: nil)
        }
    }
    
    func validateCreateFeilds() -> String?{
            
        //Check that all fields are filled in
        if FirstTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || LastTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmpasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
            
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
        if isValidEmail(cleanedEmail) == false{
                //Password isn't secure enough
            return "Invaid email address."
        }
            
        if isPasswordValid(cleanedPassword) == false{
                    //Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains special character and a number."
        }
        
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != confirmpasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                     return "Passwords do not match"
        }
            
        //#####Insert code here to check if inputs are already used in the database######//
        if DoesUserExist() != ""{
            return "User Already Exists"
        }
        //#####Insert code here to check if inputs are already used in the database######//
        return nil
        }
    
    func DoesUserExist() -> String {
        do {
            let maxCal = maxCalories.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let maxCal_2 = maxCal.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            let inputCalories = Int(maxCal_2) ?? 0

            try self.newUser.saveUser(email: self.emailTextField.text!, password: self.passwordTextField.text!, firstName: self.FirstTextField.text!, lastName: self.LastTextField.text!, maxCaloriesPerMeal: inputCalories)
            return ""
        } catch {
            return "User Exists"
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isPasswordValid(_ password:String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 252.0/255.0, green: 244.0/255.0, blue: 236.0/255.0, alpha: 1)
        
        FirstTextField.delegate = self
        LastTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmpasswordTextField.delegate = self
        
        observeKeyboardNotifications()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == FirstTextField {
            LastTextField.becomeFirstResponder()
        }
        else if textField == LastTextField{
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            confirmpasswordTextField.becomeFirstResponder()
        }
        else if textField == confirmpasswordTextField{
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100 : -130
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
}
