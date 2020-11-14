//
//  Error.swift
//  appetit
//
//  Created by Mark Kang on 4/4/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import Foundation

class ErrorMessage{
    enum ErrorCodes: Error{
        case dataSearchFailed
        case dataSaveFailed
        case userExists
        case ingredientDoesNotExist
    }
}
