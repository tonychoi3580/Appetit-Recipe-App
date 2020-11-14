//
//  AddCell.swift
//  appetit
//
//  Created by Frank Hu on 4/9/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

protocol AddCellDelegate: class {
    func didAddPressButton()
}


class AddCell: UICollectionViewCell {

    @IBOutlet weak var addButton: UIButton!
    weak var delegate: AddCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
        let origImage = UIImage(named: "plus")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(tintedImage, for: .normal)

        // Initialization code
    }
    
    @IBAction func didAddPressButton(_ sender: Any) {
        delegate?.didAddPressButton()
    }
    
    private func configureCell() {
            self.contentView.layer.backgroundColor =  UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1).cgColor
            self.contentView.layer.cornerRadius = 10.0
            self.contentView.layer.borderWidth = 1.0
            self.contentView.layer.borderColor = UIColor.clear.cgColor
            self.contentView.layer.masksToBounds = true
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            self.layer.shadowRadius = 2.0
            self.layer.shadowOpacity = 0.7
            self.layer.masksToBounds = false
            
    //        self.contentView.layer.backgroundColor =  UIColor(red: 252/255, green: 244/255, blue: 236/255, alpha: 1).cgColor
    //        self.contentView.layer.cornerRadius = 10
    
//            self.layer.masksToBounds = false
//            self.layer.shadowColor = UIColor.black.cgColor
//            self.layer.shadowOpacity = 0.7
//            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    
}
