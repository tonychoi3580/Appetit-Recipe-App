//
//  IngredientsViewController.swift
//  appetit
//
//  Created by Frank Hu on 4/6/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FridgeCustomCell"

class IngredientsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonView: UIView!
    var ingredients = [IngredientEntity]()
    var fridge = [Food]()
    var selected = [String]()
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Connect to backend change the setup function
        
        navigationController?.navigationBar.clipsToBounds = false
        navigationController?.navigationBar.tintColor = .black        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView!.register(UINib.init(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.allowsMultipleSelection = true
        
        
        //code to add button to right
        let menu = UIButton()
        menu.imageView?.contentMode = .scaleAspectFit
        menu.addTarget(self, action: #selector(menuButtonClicked), for: .touchUpInside)
        menu.setImage(UIImage(imageLiteralResourceName: "menu"), for: .normal)
        menu.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        menu.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        let rightItem = UIBarButtonItem(customView: menu)
        
        setupLeftTitle(title: "Generate Recipes")
        setupButtonUI()
        
        self.navigationItem.rightBarButtonItem  = rightItem
        buttonView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        email =  UserDefaults.standard.string(forKey: "email") ?? "no email"
        setup()
        //print(fridge)

        // uncomment if need to preserve selection
        // self.clearsSelectionOnViewWillAppear = false
          
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setup()
//        self.collectionView.reloadData()
//                // THIS might cause errors sorrys
//        self.viewDidLoad()
        //print(fridge)
        self.selected = [String]()
        
        self.refreshCollection()
    }
     //MARK: - Navigation
    private func refreshCollection() {
        DispatchQueue.main.async { [weak self] in
        self?.collectionView.collectionViewLayout.invalidateLayout()
        self?.collectionView.reloadData()
        }
    }
        // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        if segue.destination is RecipesViewController {
            let vc = segue.destination as? RecipesViewController
            vc?.selectedIngredients = selected
        }
    }
    
    
    // MARK: View Layout Setup
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private let itemsPerRow: CGFloat = 2
    
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fridge.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FridgeCustomCell
        cell.configureData(with: fridge[indexPath.row])
        cell.contentView.layer.backgroundColor =  UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1).cgColor
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("User tapped on item \(indexPath.row)")
        if let cell = collectionView.cellForItem(at: indexPath) as? FridgeCustomCell {
            cell.contentView.layer.backgroundColor =  UIColor(red: 0.788, green: 1, blue: 0.808, alpha: 1).cgColor
            selected.append(cell.itemName.text!)
        
            //print(selected)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FridgeCustomCell {
            cell.contentView.layer.backgroundColor =  UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1).cgColor
            if let index = selected.firstIndex(of: cell.itemName.text!) {
                selected.remove(at: index)
            }
            //print(selected)

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
            //print(ingredients)
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
        self.refreshCollection()
        
    }
    func picture(food: String) -> UIImage{
        if let myImage = UIImage(named: food.lowercased()) {
            return myImage
          // use your image (myImage), it exists!
        }
        return UIImage(imageLiteralResourceName: "filler")
    }
    
    func setupLeftTitle(title : String){
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Recipes"
        longTitleLabel.font = UIFont(name: "Didot-Bold", size: 25)
        longTitleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    func setupButtonUI(){
        generateButton.setTitle("Click To Generate Recipes", for: .normal)
        generateButton.setTitleColor(.black, for: .normal)
        generateButton.layer.cornerRadius = 20
        generateButton.layer.backgroundColor = UIColor(red: 0.788, green: 1, blue: 0.808, alpha: 1).cgColor
        generateButton.layer.borderWidth = 1.0
        generateButton.layer.borderColor = UIColor.clear.cgColor
        generateButton.layer.masksToBounds = true
        generateButton.layer.shadowColor = UIColor.lightGray.cgColor
        generateButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        generateButton.layer.shadowRadius = 2.0
        generateButton.layer.shadowOpacity = 0.7
        generateButton.layer.masksToBounds = false
    }
    
    
    //Handles Side menu
    //########################################################
    lazy var settingsLauncher: SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.IVController = self
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

    func createAlert(title:String, message:String) -> Bool{
        var result: Bool?
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            result = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            result = true
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        if !(self.navigationController?.visibleViewController?.isKind(of: UIAlertController.self))! {
               self.present(alert, animated: true, completion: nil)
        }
        return result ?? false
    }
    
//    func showConfirmationAlert(title: String!, message: String!,success: (() -> Void)? , cancel: (() -> Void)?) {
//        DispatchQueue.main.async {
//            let alertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
//            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel",
//                                                      style: .cancel) {
//                                                        action -> Void in cancel?()
//            }
//            let successAction: UIAlertAction = UIAlertAction(title: "OK",
//                                                       style: .default) {
//                                                        action -> Void in success?()
//            }
//            alertController.addAction(cancelAction)
//            alertController.addAction(successAction)
//
//            self.present(alertController, animated: true, completion: nil)
//        };
//}
    
        
//    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
//            if selected.count == 0 {
//                var val: Bool?
//                let _: () = showConfirmationAlert(title: "Searching All", message: "No items selected. Will search recipes with all the items in your fridge.", success: {
//                    val = true
//                    print(val!)
//                }) {
//                    val = false
//                    print(val!)
//                }
//
//                print("__________")
//                print(val ?? nil)
//                print("__________")
//                return false
//                }
//            return true
//    }
            
    
    @IBAction func generateRecipe(_ sender: Any) {
        //shouldPerformSegue(withIdentifier: "Listgenerated", sender: nil)

    }
}

