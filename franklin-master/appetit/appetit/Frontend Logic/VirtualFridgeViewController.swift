//
//  VirtualFridgeViewController.swift
//  appetit
//
//  Created by Frank Hu on 4/8/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FridgeCustomCell"

class VirtualFridgeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // This is the list to hold our food objects. Backend - might need to add a field for an image to coredata.
    var ingredients = [IngredientEntity]()
    var fridge = [Food]()
    
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Connect to backend change the setup function
        navigationController?.navigationBar.tintColor = .black

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView!.register(UINib.init(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.register(UINib.init(nibName: "AddCell", bundle: nil), forCellWithReuseIdentifier: "AddCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunction), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        
        //code to add button to right
        let menu = UIButton()
        menu.imageView?.contentMode = .scaleAspectFit
        menu.addTarget(self, action: #selector(menuButtonClicked), for: .touchUpInside)
        menu.setImage(UIImage(imageLiteralResourceName: "menu"), for: .normal)
        menu.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        menu.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        let rightItem = UIBarButtonItem(customView: menu)
        
        setupLeftTitle(title: "Virtual Fridge")
        
        self.navigationItem.rightBarButtonItem  = rightItem
        email =  UserDefaults.standard.string(forKey: "email") ?? "no email"
        //print(email)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setup()
        //self.collectionView.reloadData()
//                // THIS might cause errors sorrys
//        self.viewDidLoad()
        //print(fridge)
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
        self.refreshCollection()
    }
    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }

    private func refreshCollection() {
        DispatchQueue.main.async { [weak self] in
        self?.collectionView.collectionViewLayout.invalidateLayout()
        self?.collectionView.reloadData()
        }
    }
    //Listener that once alert is closed will reload data has a bug of breaking constraint on reloads
    @objc func listnerFunction() {
        print("yes")
        //self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
        self.viewWillAppear(true)
        
    }
    
    // MARK: View Layout Setup
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private let itemsPerRow: CGFloat = 2

    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fridge.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if fridge[indexPath.row].name != "AddButton"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FridgeCustomCell
            cell.configureData(with: fridge[indexPath.row])
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as! AddCell
            cell.delegate = self
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FridgeCustomCell {
            print("User tapped on item \(indexPath.row)")
            let pop = Popup()
            pop.configureData(with: Food(name: cell.itemName.text!, measurement: cell.servingName.text!, image: cell.itemImage.image!))
            self.view.addSubview(pop)
        }
    }
    
    //change function to however u like but make sure to keep last two lines- responsible for how we get add button
    func setup(){
        if self.fridge.count != 0{
            self.fridge = [Food]()
        }
        
        let fridgeController = VirtualFridgeController()
        
        do {
            ingredients = try fridgeController.getUserIngredients(email: email)
        }
        catch {
            print("couldn't get ingredients with email")
        }
        for i in ingredients{
            let image = picture(food: i.ingredient)
            let foodItem = Food(name: i.ingredient, measurement: String(i.servings)+" Servings", image: image)
            fridge.append(foodItem)
        }
        
        fridge.sort {
            $0.name < $1.name
        }
        
        let add = Food(name: "AddButton", measurement: "2", image: UIImage(imageLiteralResourceName: "filler"))
        self.fridge.append(add)
        self.refreshCollection()
        
        
    }
    
    func setupLeftTitle(title : String){
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Virtual Fridge"
        longTitleLabel.font = UIFont(name: "Didot-Bold", size: 25)
        longTitleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
               if self.view.frame.origin.y == 0 {
                   self.view.frame.origin.y -= keyboardSize.height/2
               }
           }
       }

    @objc func keyboardWillHide(notification: NSNotification) {
           if self.view.frame.origin.y != 0 {
               self.view.frame.origin.y = 0
           }
       }
    
    //Handles Side menu
    //########################################################
    lazy var settingsLauncher: SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.VFController = self
        return launcher
    }()
    
    @objc func menuButtonClicked(_ sender: UIButton) {
        settingsLauncher.showsSettings()
    }
    
    func showControllerForSetting(setting: Setting) {
        let SettingViewController = AccountViewController()
        SettingViewController.view.backgroundColor = .white
        SettingViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Didot-Bold", size: 25)!]
        navigationController?.navigationBar.tintColor = .black
        
        let transition = CATransition()
        transition.duration = 0.75
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(SettingViewController, animated: true)
    }
    
    //########################################################
    
    
    
    func deleteDataIndex(index: Int) {
        self.collectionView.reloadData()
    }
    
    func picture(food: String) -> UIImage{
        if let myImage = UIImage(named: food.lowercased()) {
            return myImage
          // use your image (myImage), it exists!
        }
        return UIImage(imageLiteralResourceName: "filler")
    }
}

extension VirtualFridgeViewController: AddCellDelegate {
    func didAddPressButton() {
        print("add button was pressed")
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scanningVC") as? AddingViewController {
            //viewController.newsObj = newsObj
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
     
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "scanningVC")
//        self.definesPresentationContext = true
//        controller.modalPresentationStyle = .overCurrentContext
//        self.present(controller, animated: true, completion: nil)
    }

}
