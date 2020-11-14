//
//  RecipesViewController.swift
//  appetit
//
//  Created by Frank Hu on 4/6/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var selectedIngredients:[String] = [String]()
    // CollectionView variable:
    var collectionView : UICollectionView?

    // Variables asociated to collection view:
    fileprivate var currentPage: Int = 0
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    struct Result: Decodable{
        let hits: [Recipe]
    }
    struct Recipe: Decodable{
        let recipe: RecipeInfo
    }
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var atGlanceInfo: UIView!
    let urlString = "https://api.edamam.com/search?"
    let apiKey = "e789925699272fcebc9ebbc5957d99b1"
    let appId = "798efc6d"
    var userEmail: String = ""
    var recipeList: [Recipe] = []
    var listOfIngredients: String = ""
    var globalcount: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        let virtualFridgeController = VirtualFridgeController()
        userEmail =  UserDefaults.standard.string(forKey: "email") ?? "no email"
        //print(userEmail)
        do{
            
            let listOfUserIngredients:[IngredientEntity] = try virtualFridgeController.getUserIngredients(email: userEmail)
            if selectedIngredients.count == 0{
                for ingredient in listOfUserIngredients{
                    listOfIngredients = listOfIngredients + " " + ingredient.ingredient
                }
            }else{
                for ingredient in selectedIngredients{
                    listOfIngredients = listOfIngredients + " " + ingredient
                }
            }
        }catch ErrorMessage.ErrorCodes.dataSearchFailed{
            //error is that we could not read from database
        }catch{
            //unknown error
        }
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        let urlWithQueryParameters = urlString + "q=" + listOfIngredients + "&app_id=" + appId + "&app_key=" + apiKey
        let url = URL(string: urlWithQueryParameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!

        let task = mySession.dataTask(with: url) { data, response, error in
            guard error == nil else {
                //error message here for internet problems
                    DispatchQueue.main.async{
                    let alert = UIAlertController(title: "No Internet Connection", message: "There is a problem connecting to appetit. Please try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (s) in}))
                    self.present(alert, animated: true, completion: nil)
                    }
                return
            }
            guard let jsonData = data else {
                //error message here for no data
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Result.self, from: jsonData)
                self.recipeList = result.hits
                DispatchQueue.main.async {
                    self.addCollectionView()
                    self.setupLayout()
                    
                    //self.globalcount = self.recipeList.count
                    /*TODO: Reload table data since data structure is relaoded*/
                }
            } catch {
                //error message here while loading data
            }
        }
        task.resume()
        
//        self.addCollectionView()
//        self.setupLayout()
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        //dismisses screen when tabs to another screen
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupMenuButton(){
        //let leftItem = UIBarButtonItem(customView: longTitleLabel)
        let menu = UIButton()
        menu.imageView?.contentMode = .scaleAspectFit
        menu.addTarget(self, action: #selector(menuButtonClicked), for: .touchUpInside)
        menu.setImage(UIImage(imageLiteralResourceName: "menu"), for: .normal)
        menu.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        menu.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        let rightItem = UIBarButtonItem(customView: menu)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
       
    func setupLayout(){
            // This is just an utility custom class to calculate screen points
            // to the screen based in a reference view. You can ignore this and write the points manually where is required.
            
        let pointEstimator = RelativeLayoutUtilityClass(referenceFrameSize: self.view.frame.size)

        self.collectionView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            
        self.collectionView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        self.collectionView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            
        self.collectionView?.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

    //        self.collectionView?.heightAnchor.constraint(equalToConstant: pointEstimator.relativeHeight(multiplier: 0.6887)).isActive = true

        self.currentPage = 0
    }


    func addCollectionView(){

            // This is just an utility custom class to calculate screen points
            // to the screen based in a reference view. You can ignore this and write the points manually where is required.
        let pointEstimator = RelativeLayoutUtilityClass(referenceFrameSize: self.view.frame.size)

            // This is where the magic is done. With the flow layout the views are set to make costum movements. See https://github.com/ink-spot/UPCarouselFlowLayout for more info
        let layout = UPCarouselFlowLayout()
            // This is used for setting the cell size (size of each view in this case)
            // Here I'm writting 400 points of height and the 73.33% of the height view frame in points.
        layout.itemSize = CGSize(width: pointEstimator.relativeWidth(multiplier: 0.73333), height: 400)
            // Setting the scroll direction
        layout.scrollDirection = .horizontal

            // Collection view initialization, the collectionView must be
            // initialized with a layout object.
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            // This line if for able programmatic constrains.
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
            // CollectionView delegates and dataSource:
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
            // Registering the class for the collection view cells
        self.collectionView?.register(RecipeCell.self, forCellWithReuseIdentifier: "cellId")

            // Spacing between cells:
        let spacingLayout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        spacingLayout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 20)

        self.collectionView?.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView!)

    }

        // MARK: - Card Collection Delegate & DataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! RecipeCell
        
        if(indexPath.row % 2 == 0){
            cell.customView.backgroundColor = UIColor(displayP3Red: 252.0/255.0, green: 244.0/255.0, blue: 236.0/255.0, alpha: 1)
        }
        else{
            cell.customView.backgroundColor = UIColor(displayP3Red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)
            }
        
        //cell.customView.backgroundColor = colors[indexPath.row]
//        let Recipe = recipeList[indexPath.row]
//        cell.recipeLabel.text = Recipe.recipe.label
        //Cell image layout

        //customView.backgroundColor = colors[indexPath.row]
        
        let RecipeItem = recipeList[indexPath.row]
        cell.recipeLabel.text = RecipeItem.recipe.label
        
        let healthlist = RecipeItem.recipe.healthLabels
        let ingredientList = RecipeItem.recipe.ingredientLines
        
        var finalhealthList: String = ""
        var finalingredientList: String = ""

        
        for item in healthlist{
            finalhealthList = finalhealthList + "• " + item + "\n"
        }
        
        
        for item in ingredientList{
            let array = item.components(separatedBy: ", ")
            finalingredientList = finalingredientList + "• " + array[0] + "\n"
        }
        
        cell.ingredientsList = finalingredientList
        cell.healthList = finalhealthList
        cell.recipe = RecipeItem.recipe
        cell.email = userEmail
        
        
        let url = URL(string: RecipeItem.recipe.image)!
        
        do{
            let imageData = try Data(contentsOf: url)
            let image = UIImage(data: imageData)
            cell.recipeImage.image = image
        }catch{
            //Set a defualt image icon later
            print("NOOOOO")
        }
        return cell
    }
    
    let focusLauncher = FocusLauncher()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let name = alist[indexPath.row]
        let RecipeItem = recipeList[indexPath.row]
        let healthlist = RecipeItem.recipe.healthLabels
        let ingredientList = RecipeItem.recipe.ingredientLines
        
        var finalhealthList: String = ""
        var finalingredientList: String = ""

        
        for item in healthlist{
            finalhealthList = finalhealthList + "• " + item + "\n"
        }
        
        
        for item in ingredientList{
            let array = item.components(separatedBy: ", ")
            finalingredientList = finalingredientList + "• " + array[0] + "\n"
        }
        
        focusLauncher.showsSettings()
        focusLauncher.healthListLabels.text = finalhealthList
        focusLauncher.ingredientListLines.text = finalingredientList
        
        
//        let viewController = UIViewController()
//        viewController.view.backgroundColor = .white
//
//
//
//        let transition: CATransition = CATransition()
//        transition.duration = 0.75
//        transition.type = CATransitionType.moveIn
//        transition.subtype = CATransitionSubtype.fromTop
//
//        self.view.window?.layer.add(transition, forKey: nil)
//        //self.navigationController?.pushViewController(viewController, animated: true)
//        self.navigationController?.present(viewController, animated: false, completion: nil)

    }
    

        // MARK: - UIScrollViewDelegate

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
            currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
    
//    @IBAction func saveButton(_ sender: Any) {
//        let recipeController = RecipeController()
//        do {
//            try recipeController.saveUserRecipe(email: userEmail, recipeInfo: recipeList[currentPage].recipe)
//            print("saved")
//        }
//        catch{
//            print("couldn't save")
//        }
//    }
    
//    class RecipeCell: UICollectionViewCell {
//        let customView: UIView = {
//            let view = UIView()
//            view.translatesAutoresizingMaskIntoConstraints = false
//            view.layer.cornerRadius = 12
//            return view
//        }()
//
//
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//
//            self.addSubview(self.customView)
//
//            self.customView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//            self.customView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//            self.customView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
//            self.customView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
//
//
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//
//    } // End of CardCell
//    class RelativeLayoutUtilityClass {
//
//        var heightFrame: CGFloat?
//        var widthFrame: CGFloat?
//
//        init(referenceFrameSize: CGSize){
//            heightFrame = referenceFrameSize.height
//            widthFrame = referenceFrameSize.width
//        }
//
//        func relativeHeight(multiplier: CGFloat) -> CGFloat{
//
//            return multiplier * self.heightFrame!
//        }
//
//        func relativeWidth(multiplier: CGFloat) -> CGFloat{
//            return multiplier * self.widthFrame!
//
//        }
//
//
//
//    }
    //Handles Side menu
    //########################################################
    lazy var settingsLauncher: SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.RPController = self
        return launcher
    }()
    
    @objc func menuButtonClicked(_ sender: UIButton) {
        settingsLauncher.showsSettings()
    }
    
    func showControllerForSetting(setting: Setting) {

        let SettingViewController = AccountViewController()
        SettingViewController.view.backgroundColor = .white
        SettingViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Didot-Bold", size: 25)!]
        navigationController?.navigationBar.tintColor = .black
        
        let transition = CATransition()
        transition.duration = 0.75
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(SettingViewController, animated: true)
    }
    
    //########################################################

}



    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

