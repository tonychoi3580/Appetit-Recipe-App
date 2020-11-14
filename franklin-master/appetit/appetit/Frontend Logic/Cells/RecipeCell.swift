//
//  RecipeCell.swift
//  appetit
//
//  Created by codeplus on 4/18/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    let customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var recipeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(displayP3Red: 5/255.0, green: 50/255.0, blue: 103/255.0, alpha: 1)
        label.font =  UIFont(name: "Didot-Italic", size: 35)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 3
        return label
    }()
    
    lazy var recipeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .black
        image.layer.cornerRadius = 15.0
        image.layer.masksToBounds = true
        return image
    }()
    
    var ingredientsList: String?
    var healthList: String?
    var recipe: RecipeInfo?
    var email: String?
    
    lazy var saveLikes: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(imageLiteralResourceName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(moveToSaves), for: .touchUpInside)
        return button
    }()
    
    //var alert:UIAlertController!
    func checkUnique(recipe: RecipeInfo) -> Bool{
        let rc = RecipeController()
        do {
            let recipes = try rc.getUserRecipe(email: email!)
            for rec in recipes{
                if rec.label.lowercased() == recipe.label.lowercased(){
                    return false
            }
        }
        }
        catch {
            print("check unique failed")
        }
        
        return true
        }
    
    @objc func moveToSaves() {
        //        print("Move to save")
        //        print(recipeLabel.text ?? "N/A")
        //        print(ingredientsList ?? "N/A")
        //        print(healthList ?? "N/A")
        let recipeController = RecipeController()
        
        if checkUnique(recipe: recipe!){
            do {
                try recipeController.saveUserRecipe(email: email!, recipeInfo: recipe!)
                print("saved", email)
                print( try recipeController.getUserRecipe(email: email!))
                
                //            self.alert = UIAlertController(title: "Success", message: "Recipe Saved Successfully", preferredStyle: UIAlertController.Style.alert)
                //            self.customView.present(self.alert, animated: true, completion: nil)
                //            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
            }
            catch{
                print("couldn't save")
            }
            
        }
        
        
    }
    
//    @objc func dismissAlert(){
//        // Dismiss the alert from here
//        self.alert.dismiss(animated: true, completion: nil)
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.customView)
        self.addSubview(recipeLabel)
        self.addSubview(recipeImage)
        self.addSubview(saveLikes)

        self.customView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.customView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.customView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        self.customView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.3).isActive = true
        
        
        self.recipeLabel.centerXAnchor.constraint(equalTo: self.customView.centerXAnchor).isActive = true
        self.recipeLabel.topAnchor.constraint(equalTo: self.customView.topAnchor, constant: 20).isActive = true
        self.recipeLabel.widthAnchor.constraint(equalTo: customView.widthAnchor, constant: -20).isActive = true
        
        
        self.recipeImage.centerXAnchor.constraint(equalTo: self.customView.centerXAnchor).isActive = true
        self.recipeImage.centerYAnchor.constraint(equalTo: self.customView.centerYAnchor, constant: 20).isActive = true
        self.recipeImage.widthAnchor.constraint(equalTo: customView.widthAnchor, constant: -80).isActive = true
        self.recipeImage.heightAnchor.constraint(equalTo: customView.heightAnchor, constant: -300).isActive = true
        
        
        self.saveLikes.centerXAnchor.constraint(equalTo: self.customView.centerXAnchor).isActive = true
        
        self.saveLikes.bottomAnchor.constraint(equalTo: self.customView.bottomAnchor).isActive = true

        self.saveLikes.widthAnchor.constraint(equalToConstant: 140).isActive = true
        self.saveLikes.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        
//        self.recipeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        self.recipeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


} // End of CardCell

class RelativeLayoutUtilityClass {

    var heightFrame: CGFloat?
    var widthFrame: CGFloat?

    init(referenceFrameSize: CGSize){
        heightFrame = referenceFrameSize.height
        widthFrame = referenceFrameSize.width
    }

    func relativeHeight(multiplier: CGFloat) -> CGFloat{

        return multiplier * self.heightFrame!
    }

    func relativeWidth(multiplier: CGFloat) -> CGFloat{
        return multiplier * self.widthFrame!

    }



}
