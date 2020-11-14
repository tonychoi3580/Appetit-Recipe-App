//
//  FocusRecipeViewController.swift
//  appetit
//
//  Created by Frank Hu on 4/6/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

final class FocusRecipeViewController: UIViewController {
    
    //Labels to update with strings from Recipe API
    let recipeLabel = UILabel() //Name of dish
    let ingredientsLabel =  UITextView() //List of Ingredients - add \n after each ingredient
    
    @IBOutlet weak var textView: UITextView!
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    
    let menuView = UIView()
    let menuHeight = UIScreen.main.bounds.height / 2
    var isPresenting = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FocusRecipeViewController.handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupLayout(){
        view.backgroundColor = .clear
        view.addSubview(backdropView)
        view.addSubview(menuView)
        
        menuView.backgroundColor = .white
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        menuView.layer.cornerRadius = 10.0
        menuView.layer.borderWidth = 1.0
        menuView.layer.borderColor = UIColor.clear.cgColor
        menuView.layer.masksToBounds = true
        recipeLabel.text = "Ombre Stacks"
        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(recipeLabel)
        recipeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        recipeLabel.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 20).isActive = true
        recipeLabel.bottomAnchor.constraint(equalTo:menuView.topAnchor, constant: 50).isActive = true
        recipeLabel.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 30).isActive = true
        recipeLabel.rightAnchor.constraint(equalTo: menuView.rightAnchor, constant: -20).isActive = true
        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(recipeLabel)
        recipeLabel.font = UIFont.boldSystemFont(ofSize: 28)

        
        let ingredientsView = UILabel()
        ingredientsView.numberOfLines = 1
        ingredientsView.text = "Ingredients"
//        ingredientsView.backgroundColor = .red
        ingredientsView.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(ingredientsView)
        ingredientsView.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        ingredientsView.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 5).isActive = true
        ingredientsView.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 30).isActive = true
        ingredientsView.rightAnchor.constraint(equalTo: menuView.rightAnchor, constant: -20).isActive = true
        
        ingredientsLabel.isEditable = false
        ingredientsLabel.text = "• 1 cup butter, softened\n• 1 cup white sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar\n• 1 cup packed brown sugar"
//        ingredientsLabel.backgroundColor = .yellow
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(ingredientsLabel)
        ingredientsLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        ingredientsLabel.topAnchor.constraint(equalTo: ingredientsView.bottomAnchor).isActive = true
        ingredientsLabel.bottomAnchor.constraint(equalTo: menuView.bottomAnchor, constant: -30).isActive = true
        ingredientsLabel.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 30).isActive = true
        ingredientsLabel.rightAnchor.constraint(equalTo: menuView.rightAnchor, constant: -20).isActive = true
        
    }
}


extension FocusRecipeViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            menuView.frame.origin.y += menuHeight
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
