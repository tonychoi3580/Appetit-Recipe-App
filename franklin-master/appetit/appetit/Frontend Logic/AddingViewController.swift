//
//  AddingViewController.swift
//  appetit
//
//  Created by Frank Hu on 4/6/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

//Todos: add checks for each

//Future change measurement to be scroll wheel and make submit button pop up alert about successfully adding

import UIKit

class AddingViewController: UIViewController, UITextFieldDelegate, DataSentDelegate {
    var dataReceived = [String]()

    @IBOutlet weak var formView: UIView!
    
    @IBOutlet weak var scannerButton: UIButton!
    
    @IBOutlet weak var nameLabel: UITextField!
    
    @IBOutlet weak var quantityLabel: UITextField!
        
    @IBOutlet weak var submitButton: LoadingButton!
    
    var placeHolder = ""
    
    var email = String()
    
    var alert:UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        

        // Do any additional setup after loading the view.
        scannerButton.setImage(UIImage(imageLiteralResourceName: "barcode"), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        email =  UserDefaults.standard.string(forKey: "email") ?? "no email"
        print(email)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let scanner = BarcodeScannerViewController()
        scanner.delegate = self
        self.sendDataToParent(myData: dataReceived)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        submitButton.showLoading()
        do {
            sleep(1)
        }
        let valid = validateFields()
        
        if valid == nil{
            let vfc = VirtualFridgeController()
            do {
                try vfc.addIngredient(email: email, ingredient: nameLabel.text!, servings: Int(quantityLabel.text!)!)
            }
            catch{
                print(error)
            }
            do{
                print(try vfc.getUserIngredients(email: email))
            }
            catch{
                print(error)
            }
            showSuccessAlert()
            nameLabel.text = ""
            quantityLabel.text = ""
        }
        else{
            showErrorAlert(error: valid!)
        }
        submitButton.hideLoading()
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "barcodeScannerVC")//need to add to storyboard this identifier
        let scanner = BarcodeScannerViewController()
        scanner.delegate = self
        self.definesPresentationContext = true
        scanner.modalPresentationStyle = .fullScreen
        self.present(scanner, animated: true, completion: nil)
    }
    
    func sendDataToParent(myData: [String]) {
        if (!(myData.isEmpty)){
            self.nameLabel.text = myData[0]
            print(myData)
            self.quantityLabel.text = myData[1]
        }
    }
    
    func setupUI(){
        //Code for the button
        scannerButton.layer.backgroundColor =  UIColor(red: 252/255, green: 244/255, blue: 236/255, alpha: 1).cgColor
        scannerButton.layer.cornerRadius = 10.0
        scannerButton.layer.borderWidth = 1.0
        scannerButton.layer.borderColor = UIColor.clear.cgColor
        scannerButton.layer.masksToBounds = true
        scannerButton.layer.shadowColor = UIColor.lightGray.cgColor
        scannerButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        scannerButton.layer.shadowRadius = 2.0
        scannerButton.layer.shadowOpacity = 0.7
        scannerButton.layer.masksToBounds = false
        
        //Code for second panel
        formView.layer.backgroundColor =  UIColor(red: 252/255, green: 244/255, blue: 236/255, alpha: 1).cgColor
        formView.layer.cornerRadius = 10.0
        formView.layer.borderWidth = 1.0
        formView.layer.borderColor = UIColor.clear.cgColor
        formView.layer.masksToBounds = true
        formView.layer.shadowColor = UIColor.lightGray.cgColor
        formView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        formView.layer.shadowRadius = 2.0
        formView.layer.shadowOpacity = 0.7
        formView.layer.masksToBounds = false
        
        //Code for Button submit
        submitButton.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        submitButton.layer.cornerRadius = 20.0
        
    }
    
    
    // Code below for when keyboard pops up
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/1.3
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    func validateFields()-> String?{
        if Int(quantityLabel.text!) == nil{
            return "Please enter a valid serving amount(Whole Numbers)"
        }
        let str = quantityLabel.text ?? "0.1"
        if str.contains("."){
            return "Please Round Whole Number Serving"
        }
        if nameLabel.text! == ""{
            return "Please enter an ingredient."
        }
        if checkUnique(name: nameLabel.text ?? ""){
            return "Item already in fridge"
        }
        return nil
        
    }
    
    func checkUnique(name: String) -> Bool{
        let vfc = VirtualFridgeController()
        do {
            let ingredients = try vfc.getUserIngredients(email: email)
            for ingr in ingredients{
                if name.lowercased() == ingr.ingredient.lowercased(){
                    return true
                }
            }
            return false
        }
        catch{
            print("couldn't get ingredients uniqueness")
        }
        return false
    }
    
    func showSuccessAlert() {
        self.alert = UIAlertController(title: "Success", message: "Ingredient Added Successfully", preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }
    
    func showErrorAlert(error: String) {
        self.alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}
