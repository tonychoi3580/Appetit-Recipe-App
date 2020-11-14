//
//  RecipeInfo.swift
//  appetit
//
//  Created by Mark Kang on 4/17/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import Foundation

struct RecipeInfo: Decodable{
    let label: String
    let image: String
    let uri: String
    let url: String
    let healthLabels: [String]
    let ingredientLines: [String]
}
