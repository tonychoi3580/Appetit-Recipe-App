//
//  IngredientEntity.swift
//  appetit
//
//  Created by Mark Kang on 4/6/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import Foundation

public struct IngredientEntity{
    let ingredient: String
    let servings: Int
    
    init(ingredientName: String, servingsAmount: Int) {
        ingredient = ingredientName
        servings = servingsAmount
    }
}
