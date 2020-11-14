//
//  FridgeCutomCell.swift
//  appetit
//
//  Created by Frank Hu on 4/8/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

class FridgeCustomCell: UICollectionViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var servingName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        configureCell()
        // Initialization code
    }
    
    public func configureData(with model: Food){
        itemName.text = model.name
        itemName.font = UIFont.boldSystemFont(ofSize: 16.0)
        servingName.text = model.measurement
        servingName.font = UIFont.systemFont(ofSize: 14.0)
        itemImage.image = model.image
    }
    
    public func configureData(with model: IngredientEntity){
        itemName.text = model.ingredient
        servingName.text = String(model.servings)
    }
    
    private func configureCell() {
        self.contentView.layer.backgroundColor =  UIColor(red: 252/255, green: 244/255, blue: 236/255, alpha: 1).cgColor
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        
//        self.contentView.layer.backgroundColor =  UIColor(red: 252/255, green: 244/255, blue: 236/255, alpha: 1).cgColor
//        self.contentView.layer.cornerRadius = 10
//        self.contentView.layer.masksToBounds = true
//
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 0.7
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

}
