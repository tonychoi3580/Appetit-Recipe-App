//
//  MainNavigationController.swift
//  audible
//
//  Created by Brian Voong on 9/27/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        isNavigationBarHidden = true
        if isLoggedIn() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! UITabBarController
            viewControllers = [SwipingController(), tabBarController]
            
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showLoginController() {
        let loginController = SwipingController()
        pushViewController(loginController, animated: true)
    }
}






