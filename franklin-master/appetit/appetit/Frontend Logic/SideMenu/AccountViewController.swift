//
//  AccountViewController.swift
//  SandBox
//
//  Created by Tommy Hessel on 4/19/20.
//  Copyright © 2020 Tommy Hessel. All rights reserved.
//

import UIKit

extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

class AccountViewController: UIViewController {
    
    var updateUser = UserController()
    var currentemail = String()
    var currentpassword = String()
    var currentfirstname = String()
    var currentlastname = String()
    var currentcal = String()
    
    var backPanel: UIView = {
        let bp = UIView()
        bp.translatesAutoresizingMaskIntoConstraints = false
        bp.backgroundColor =  UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        return bp //red: 246/255, green: 246/255, blue: 246/255, alpha: 1
    }()
    var logo: UIImageView = {
        let l = UIImageView(image: UIImage(named: "appetit"))
        l.translatesAutoresizingMaskIntoConstraints = false
        l.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        l.contentMode = .scaleAspectFit
        return l
    }()
    var profPic: UIImageView = {
        let image = UIImageView(image: UIImage(named: "profile"))
        image.makeRounded()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var nameLabel: UILabel = {
        let name = UILabel()
        name.text = "N/A"
        name.font = .boldSystemFont(ofSize: 30)
        name.textAlignment = .center
        name.translatesAutoresizingMaskIntoConstraints = false
        return name //red: 246/255, green: 246/255, blue: 246/255, alpha: 1
    }()
    
    var calLabel: UILabel = {
        let cal = UILabel()
        cal.text = "Max Calories: 0"
        cal.font = .systemFont(ofSize: 18)
        cal.textAlignment = .center
        cal.translatesAutoresizingMaskIntoConstraints = false
        return cal //red: 246/255, green: 246/255, blue: 246/255, alpha: 1
    }()
    
    var changeName: UIButton = {
        let cn = UIButton()
        let Bcolor = UIColor.white
        cn.setTitle("Change Profile", for: .normal)
        cn.titleLabel?.font =  UIFont(name: "boldSystemFont", size:25)
        cn.setTitleColor (Bcolor, for: .normal)
        cn.translatesAutoresizingMaskIntoConstraints = false
        cn.backgroundColor = UIColor(displayP3Red: 5/255.0, green: 50/255.0, blue: 103/255.0, alpha: 1)
        cn.layer.cornerRadius = 25.0;
        cn.addTarget(self, action: #selector(handlechangeProfile), for: .touchUpInside)
        return cn
    }()

//##########################################################
//##########################################################

    @objc func handlechangeProfile() {
        let alertController = UIAlertController(title: "Update", message: "Select which item you would like to change", preferredStyle: .alert)
        let changeFristName = UIAlertAction(title: "First Name", style: .default) { (_) in
            self.SelectedAlert(labelName: "Enter New First Name")
        }
        let changeLastName = UIAlertAction(title: "Last Name", style: .default) { (_) in
            self.SelectedAlert(labelName: "Enter New Last Name")
        }
        let changeMax = UIAlertAction(title: "Max Calories", style: .default) { (_) in
            self.SelectedAlert(labelName: "Enter New Max Calories")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(changeFristName)
        alertController.addAction(changeLastName)
        alertController.addAction(changeMax)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func SelectedAlert(labelName: String){
        let alertController = UIAlertController(title: labelName, message: "" + labelName, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            var input = String()
            if let inputTextField = alertController.textFields?.first,
                let temp = inputTextField.text{
                input = temp
            }
            if labelName == "Enter New Max Calories"{
                let maxCal = input.trimmingCharacters(in: .whitespacesAndNewlines)
                let maxCal_2 = maxCal.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                let number = Int(maxCal_2)
                
                if number != nil {
                    self.tryUpdating(email_1: self.currentemail, password_1: self.currentpassword, firstName_1: self.currentfirstname, lastName_1: self.currentlastname, maxCal_1: number!, labelAlert: labelName)
                    self.viewWillAppear(true)
                }
                else {
                    self.updateAlert(titleUpdate: "Failed Updated", message: "Not A Valid Integer", labelAlert: labelName)
                }
            } else if labelName == "Enter New First Name"{
                self.tryUpdating(email_1: self.currentemail, password_1: self.currentpassword, firstName_1: input, lastName_1: self.currentlastname, maxCal_1: Int(self.currentcal)!, labelAlert: labelName)
                self.viewWillAppear(true)

            }
            else if labelName == "Enter New Last Name"{
                self.tryUpdating(email_1: self.currentemail, password_1: self.currentpassword, firstName_1: self.currentfirstname, lastName_1: input, maxCal_1: Int(self.currentcal)!, labelAlert: labelName)
                self.viewWillAppear(true)

            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func tryUpdating(email_1: String, password_1: String, firstName_1: String, lastName_1: String, maxCal_1: Int, labelAlert: String){
        do {
            try self.updateUser.updateUser(email: email_1, password: password_1, firstName: firstName_1, lastName: lastName_1, maxCaloriesPerMeal: maxCal_1)
            self.updateAlert(titleUpdate: "Update Successful", message: "", labelAlert: "labelAlert")
        } catch {
            self.updateAlert(titleUpdate: "Failed Updated", message: "", labelAlert: "labelAlert")
        }
    }
    
    private func updateAlert(titleUpdate: String, message: String, labelAlert: String){
        let alertController = UIAlertController(title: titleUpdate, message: message, preferredStyle: .alert)
        
        var okAction = UIAlertAction()
        if titleUpdate == "Update Successful"{
            okAction = UIAlertAction(title: "Ok", style: .default)
        }
        else{
            okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.SelectedAlert(labelName: labelAlert)
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    var changePass: UIButton = {
        let cp = UIButton()
        let Bcolor = UIColor.white
        cp.setTitle("Change Password", for: .normal)
        cp.titleLabel?.font =  UIFont(name: "boldSystemFont", size:15)
        cp.setTitleColor (Bcolor, for: .normal)
        cp.translatesAutoresizingMaskIntoConstraints = false
        cp.backgroundColor = UIColor(displayP3Red: 5/255.0, green: 50/255.0, blue: 103/255.0, alpha: 1)
        cp.layer.cornerRadius = 25.0;
        cp.addTarget(self, action: #selector(handlechangePassword), for: .touchUpInside)
        return cp
    }()
    
    @objc func handlechangePassword() {
        InputPasswordAlert()
    }
    
    
    private func InputPasswordAlert(){
        let alertController = UIAlertController(title: "Update", message: "Please Enter Your New Password", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in textField.isSecureTextEntry = true}
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            var input = String()
            if let nameTextField = alertController.textFields?.first,
                let name = nameTextField.text{
                input = name
            }
            
            //Check if input is valid
            let  result = self.validatePasswordFeilds(newpassord: input)
            
            if (result != nil){
                self.changedAlert(titleUpdate: "Failed Updated", message: result ?? "")
            }else{
                do {
                    try self.updateUser.updateUser(email: self.currentemail, password: input, firstName: self.currentfirstname, lastName: self.currentlastname, maxCaloriesPerMeal: Int(self.currentcal)!)
                    self.changedAlert(titleUpdate: "Update Successful", message: "")
                } catch {
                    self.updateAlert(titleUpdate: "Failed Updated", message: "", labelAlert: "labelAlert")
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func changedAlert(titleUpdate: String, message: String){
        let alertController = UIAlertController(title: titleUpdate, message: message, preferredStyle: .alert)
        
        var okAction = UIAlertAction()
        
        if titleUpdate == "Update Successful"{
            okAction = UIAlertAction(title: "Ok", style: .default)
        }
        else{
            okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.InputPasswordAlert()
            }
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func validatePasswordFeilds(newpassord: String) -> String?{
                
        let cleanedPassword = newpassord.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false{
            //Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains special character and a number."
        }
        return nil
    }
    
    func isPasswordValid(_ password:String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

//##########################################################
//##########################################################
    
    //Animation when back button is pressed
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            let transition = CATransition()
            transition.duration = 0.75
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            self.navigationController?.view.layer.add(transition, forKey: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        currentemail = UserDefaults.standard.string(forKey: "email") ?? "no email"
        currentpassword =  UserDefaults.standard.string(forKey: "wordp") ?? "no password"
        do {
            let currentUser = try updateUser.getUser(email: currentemail,
                                                     password: currentpassword)
            nameLabel.text = currentUser.firstName + " " + currentUser.lastName
            calLabel.text = "Max Calories: " + String(currentUser.getMaxCaloriesPerMeal())
                    
            currentfirstname = currentUser.firstName
            currentlastname = currentUser.lastName
            currentcal = String(currentUser.maxCaloriesPerMeal)
                    
        } catch {
                currentfirstname = "no first name"
                currentlastname = "no last name"
                currentcal = "0"
        }
                
        view.addSubview(backPanel)
        bpLayout()
        view.addSubview(logo)
        logoLayout()
        view.addSubview(profPic)
        profLayout()
        view.addSubview(nameLabel)
        nameLayout()
        view.addSubview(calLabel)
        calLayout()
        view.addSubview(changeName)
        cNameLayout()
        view.addSubview(changePass)
        cPassLayout()
            
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        currentemail = UserDefaults.standard.string(forKey: "email") ?? "no email"
        currentpassword =  UserDefaults.standard.string(forKey: "wordp") ?? "no password"
        do {
            let currentUser = try updateUser.getUser(email: currentemail,
                                                         password: currentpassword)
            nameLabel.text = currentUser.firstName + " " + currentUser.lastName
            calLabel.text = "Max Calories: " + String(currentUser.getMaxCaloriesPerMeal())
                        
            currentfirstname = currentUser.firstName
            currentlastname = currentUser.lastName
            currentcal = String(currentUser.maxCaloriesPerMeal)
                        
        } catch {
                currentfirstname = "no first name"
                currentlastname = "no last name"
                currentcal = "0"
        }
                    
        view.addSubview(backPanel)
        bpLayout()
        view.addSubview(logo)
        logoLayout()
        view.addSubview(profPic)
        profLayout()
        view.addSubview(nameLabel)
        nameLayout()
        view.addSubview(calLabel)
        calLayout()
        view.addSubview(changeName)
        cNameLayout()
        view.addSubview(changePass)
        cPassLayout()
                
    }
    
    private func bpLayout(){
        backPanel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backPanel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        backPanel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backPanel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    }
    private func logoLayout(){
        logo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        logo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    }
    private func profLayout(){
        profPic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profPic.centerYAnchor.constraint(equalTo: backPanel.bottomAnchor, constant: 0).isActive = true
    }
    private func nameLayout(){
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profPic.bottomAnchor, constant: 15).isActive = true
    }
    private func calLayout(){
        calLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        calLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        calLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    private func cNameLayout(){
        changeName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        changeName.heightAnchor.constraint(equalToConstant: 50).isActive = true
        changeName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeName.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
    }
    private func cPassLayout(){
        changePass.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        changePass.heightAnchor.constraint(equalToConstant: 50).isActive = true
        changePass.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changePass.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -135).isActive = true
    }

}
