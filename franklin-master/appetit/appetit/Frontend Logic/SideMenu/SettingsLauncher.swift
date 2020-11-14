//
//  SettingsLauncher.swift
//  appetit
//
//  Created by codeplus on 4/19/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: SettingNmae
    let imageName: String
    
    init(name: SettingNmae, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingNmae: String {
    case Account = "Profile"
    case SignOut = "Sign Out"
    case Cancel = "Cancel"

}

let cellId = "cellId"
let cellHeight: CGFloat = 50

let settings: [Setting] = {
    let accountSetting = Setting(name: .Account, imageName: "account")
    let signoutSetting = Setting(name: .SignOut, imageName: "signout")
    let cancelSetting = Setting(name: .Cancel, imageName: "cancel")
    
    return [accountSetting,signoutSetting,
            cancelSetting]
}()

class SettingLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var IVController: IngredientsViewController?
    var VFController: VirtualFridgeViewController?
    var SVController: SavedCollectionViewController?
    var RPController: RecipesViewController?

    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    func showsSettings() {
           //Sign out for now
       if let window = UIApplication.shared.keyWindow {
                
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                
            window.addSubview(blackView)
                
            window.addSubview(collectionView)
                
        let height: CGFloat = CGFloat(settings.count) * (cellHeight*1.3)
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
                
            blackView.frame = window.frame
            blackView.alpha = 0
                
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                self.blackView.alpha = 1
                    
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                    
            }, completion: nil)
        }
               
               
       //        UserDefaults.standard.setIsLoggedIn(value: false)
       //        self.view.endEditing(true)
       //        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
       //        guard let mainNavigationController = rootViewController as? MainNavigationController else { return }
       //        mainNavigationController.popToRootViewController(animated: true)

    }
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }, completion: { (_) in
            let setting = settings[indexPath.item]
            
            if setting.name == .SignOut{
     
                UserDefaults.standard.setIsLoggedIn(value: false)
                let rootViewController = UIApplication.shared.keyWindow?.rootViewController
                guard let mainNavigationController = rootViewController as? MainNavigationController else { return }
                mainNavigationController.popToRootViewController(animated: true)
            }
            else if setting.name != .Cancel {
                if((self.IVController) != nil){
                    self.IVController?.showControllerForSetting(setting: setting)
                }
                else if ((self.VFController) != nil){
                    self.VFController?.showControllerForSetting(setting: setting)

                }
                else if ((self.SVController) != nil){
                    self.SVController?.showControllerForSetting(setting: setting)

                }
                else if ((self.RPController) != nil){
                    self.RPController?.showControllerForSetting(setting: setting)

                }
            }
        })
    }
    

}
