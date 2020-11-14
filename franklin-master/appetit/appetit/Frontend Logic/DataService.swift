//
//  DataService.swift
//  appetit
//
//  Created by Yoo Bin Shin on 4/15/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import Foundation

/// A food item returned from Nutritionix API
struct FoodItem: Codable {
    /// Name of the food
    var food_name: String

    /// Amount in a serving
    var serving_qty: Double

    /// Unit of a serving
    var serving_unit: String
}

/// JSON return from Nutritionix API
struct FoodJSON: Codable {
    /// List of food items
    var foods: [FoodItem]
}


final class DataService {
    static let dataService = DataService()
        
    class func searchAPI(codeNumber: String, completionHandler: @escaping (_ scanInfo: (String, Int, String)) -> Void) {
        enum Error: Swift.Error {
            case requestFailed
        }
        let url = "https://trackapi.nutritionix.com/v2/search/item"
        let urlWithParams = url + "?upc=" + codeNumber
        let myUrl = URL(string: urlWithParams)
        guard let requestUrl = myUrl else { fatalError() }
        var name = ""
        var qty = 0
        var unit = ""
        // Create URL Request
        var request = URLRequest(url: requestUrl)

        // Specify HTTP Method to use
        request.httpMethod = "GET"
        //Headers
        request.setValue("e6f7f2ae", forHTTPHeaderField: "x-app-id")
        request.setValue("0d6f81b2f952da8b1acbd5d3db372855", forHTTPHeaderField: "x-app-key")
        
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }

            guard let data = data else {
                print("No data")
                return
            }
            
//                do {
//                    let convertedString = String(data: data, encoding: String.Encoding.utf8) // the data will be converted to the string
//                    print(convertedString ?? "defaultvalue")
//                }
            do {
                let decoder = JSONDecoder()
                let foodJSON = try decoder.decode(FoodJSON.self, from: data)
//                print(foodJSON.foods)
                for food in foodJSON.foods {
                        /*TODO: Reload table data since data structure is relaoded*/
                    name = food.food_name
                    qty = Int(ceil(food.serving_qty))
                    unit = food.serving_unit
                    completionHandler((name, qty, unit))
                    print("Food name: \(name), serving quantity: \(qty), serving unit: \(unit)")
                }
            } catch let error as NSError {
                completionHandler(("error",0,""))
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
}

