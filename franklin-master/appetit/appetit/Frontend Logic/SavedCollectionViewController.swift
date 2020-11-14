//
//  SavedCollectionViewController.swift
//  appetit
//
//  Created by Frank Hu on 4/6/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit
import SafariServices


private let reuseIdentifier = "SavedCollectionViewCell"

class SavedCollectionViewController: UICollectionViewController, SFSafariViewControllerDelegate {
    var data = [RecipeInfo]()
    var email = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView!.register(UINib.init(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        email =  UserDefaults.standard.string(forKey: "email") ?? "no email"
        print(email)
        setupData(email: email)
        setupLeftTitle(title: "Generate Recipes")
        
        //code to add button to right
        let menu = UIButton()
        menu.imageView?.contentMode = .scaleAspectFit
        menu.addTarget(self, action: #selector(menuButtonClicked), for: .touchUpInside)
        menu.setImage(UIImage(imageLiteralResourceName: "menu"), for: .normal)
        menu.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        menu.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        let rightItem = UIBarButtonItem(customView: menu)
        self.navigationItem.rightBarButtonItem  = rightItem

        DispatchQueue.main.async {
            self.collectionView!.reloadData()
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            setupData(email: email)
            //self.collectionView.reloadData()
    //                // THIS might cause errors sorrys
    //        self.viewDidLoad()
            //print(fridge)
    //        DispatchQueue.main.async {
    //            self.collectionView.reloadData()
    //        }
            self.refreshCollection()
    }
    
    private func refreshCollection() {
        DispatchQueue.main.async { [weak self] in
        self?.collectionView.collectionViewLayout.invalidateLayout()
        self?.collectionView.reloadData()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        return data.count
        print(data.count)
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SavedCollectionViewCell
        let url = URL(string: data[indexPath.row].image)!
        let name = data[indexPath.row].label
        do{
            let imageData = try Data(contentsOf: url)
            let image = UIImage(data: imageData)
            cell.configureData(name: name, image: image ?? UIImage(imageLiteralResourceName: "Avocado"))
        }catch{
            let alert = UIAlertController(title: "No Internet Connection", message: "There is a problem connecting to appetit. Please try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (s) in}))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "focusView")
//        let vc = FocusRecipeViewController()
//        vc.modalPresentationStyle = .custom
//        self.definesPresentationContext = true
//        self.present(vc, animated: true, completion: nil)
        let urlString = data[indexPath.row].url

        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self

            present(vc, animated: true)
        }

    }
     
    //Process backend
    func setupData(email: String){
        let recipeController = RecipeController()
        do {
            try data = recipeController.getUserRecipe(email: email)}
        catch {
            print("failed to get recipes saved with email")
        }
        
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    //Handles Side menu
     //########################################################
     lazy var settingsLauncher: SettingLauncher = {
         let launcher = SettingLauncher()
         launcher.SVController = self
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
    
    func setupLeftTitle(title : String){
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Saved Recipes"
        longTitleLabel.font = UIFont(name: "Didot-Bold", size: 25)
        longTitleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }
}
