//
//  RecipeCellTableViewCell.swift
//  appetit
//
//  Created by codeplus on 4/17/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

class RecipeCellTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
