//
//  SavedCollectionViewCell.swift
//  appetit
//
//  Created by Frank Hu on 4/17/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

class SavedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recipeImage.contentMode = .scaleAspectFill
        recipeImage.image = UIImage(imageLiteralResourceName: "ombre")
        configureCell()

        // Initialization code
    }
    
    public func configureData(name: String, image: UIImage){
        recipeName.text = name
        recipeImage.image = image
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
        
        
        let view = UIView(frame: self.contentView.layer.frame)
        let layer = CAGradientLayer()
        layer.frame = self.contentView.layer.frame
        layer.colors = [UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.6).cgColor, UIColor.clear.cgColor]
        layer.locations = [0.0, 1.0]
        view.layer.insertSublayer(layer, at: 0)

        self.recipeImage.addSubview(view)
        self.recipeImage.bringSubviewToFront(view)

        

    
    }
    
}
