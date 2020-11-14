//
//  FocusLauncher.swift
//  appetit
//
//  Created by codeplus on 4/19/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit


class FocusLauncher: NSObject, UICollectionViewDelegate {
    
    
    var homeController: RecipesViewController?
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 20
        cv.layer.masksToBounds = true
        return cv
    }()
    
    let menuView = UIView()
    
    let IngredientLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 0
        label.textAlignment = .center;
        return label
    }()
    
    let healthLabel: UILabel = {
        let label = UILabel()
        label.text = "Health"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 0
        label.textAlignment = .center;
        return label
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    
    var healthListLabels: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    var ingredientListLines: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    
    func showsSettings() {
           //Sign out for now
       if let window = UIApplication.shared.keyWindow {
                
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                
            window.addSubview(blackView)
                
            window.addSubview(collectionView)
                
        let height: CGFloat = 400
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
                
            blackView.frame = window.frame
            blackView.alpha = 0
                
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                self.blackView.alpha = 1
                    
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                    
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    
    override init() {
        super.init()
        collectionView.addSubview(menuView)
        menuView.addSubview(IngredientLabel)
        menuView.addSubview(healthLabel)
        menuView.addSubview(lineSeparatorView)
        menuView.addSubview(healthListLabels)
        menuView.addSubview(ingredientListLines)
        
        menuView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        IngredientLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(menuView.snp.top).offset(30)
            make.centerX.equalTo(menuView.snp.centerX).offset(-100)
            make.bottom.equalTo(menuView.snp.top).offset(60)
        })
        
        healthLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(menuView.snp.top).offset(30)
            make.centerX.equalTo(menuView.snp.centerX).offset(100)
            make.bottom.equalTo(menuView.snp.top).offset(60)
        })
        
        lineSeparatorView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(3)
        }
        
        
        ingredientListLines.snp.remakeConstraints { make in
            make.top.equalTo(healthLabel.snp.bottom).offset(20)
            //make.bottom.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(lineSeparatorView.snp.left).offset(-10)
        }
        
        healthListLabels.snp.remakeConstraints { make in
            make.top.equalTo(healthLabel.snp.bottom).offset(20)
            //make.bottom.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(lineSeparatorView.snp.right).offset(10)
        }
        
        
    }
    
}
