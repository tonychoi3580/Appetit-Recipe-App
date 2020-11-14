import SnapKit
import UIKit

protocol SwipingControllerDelegate: class {
    func finishLoggingIn()
}

class SwipingController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SwipingControllerDelegate {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.contentInsetAdjustmentBehavior = .never

        return cv
    }()

    let cellId = "cellId"
    let loginCellId = "loginCellId"

    let pages: [Page] = {
        let firstPage = Page(title: "Welcome to Appetit!", message: "Are you wanting to try out new recipies but don't know what to make based on what you have at home? With Appetit you can do just that!", imageName: "Fridge")

        let secondPage = Page(title: "Add Items to Your Fridge!", message: "Based on the items you have at home, add each item onto under the Frdige tap. You can either scan the bar code or add them manually yourself.", imageName: "scanning")

        let thirdPage = Page(title: "Start Cooking!", message: "Under the recipes tab, selected the items from your Fridge to generate a list of recipes. Choose and save your favorites and start cooking!", imageName: "Recipes")

        return [firstPage, secondPage, thirdPage]
    }()

    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(displayP3Red: 5/255.0, green: 50/255.0, blue: 103/255.0, alpha: 1)
        pc.numberOfPages = self.pages.count + 1
        return pc
    }()

    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()

    @objc func skip() {
        pageControl.currentPage = pages.count - 1
        nextPage()
    }

    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor(displayP3Red: 5/255.0, green: 50/255.0, blue: 103/255.0, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()

    @objc func nextPage() {
        // We are on the last page
        if pageControl.currentPage == pages.count {
            return
        }

        // second last page
        if pageControl.currentPage == pages.count - 1 {
            moveControlConstraintsOffScreen()

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)

        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        observeKeyboardNotifications()

        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)

        setCollectionsConstraints()
        registerCells()
    }

    func setCollectionsConstraints() {
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-40)
            make.centerX.equalTo(self.view)
            make.height.equalTo(40)
        }

        skipButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(25)
            make.bottom.equalTo(view.snp.bottom).offset(-35)
            make.width.equalTo(60)
            make.height.equalTo(50)
        }

        nextButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(-25)
            make.bottom.equalTo(view.snp.bottom).offset(-35)
            make.width.equalTo(60)
            make.height.equalTo(50)
        }

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.visibleCells.forEach { cell in cell.setNeedsUpdateConstraints() }
    }

    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        }, completion: nil)
    }

    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100 : -100
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)

        }, completion: nil)
    }

    func scrollViewDidScroll(_: UIScrollView) {
        view.endEditing(true)
    }

    func scrollViewWillEndDragging(_: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber

        // we are on the last page
        if pageNumber == pages.count {
            moveControlConstraintsOffScreen()
        } else {
            // back on regular pages
            // pageControlBottomAnchor?.constant = 0
            pageControl.snp.updateConstraints { make in
                make.bottom.equalTo(view.snp.bottom).offset(-40)
            }
            // skipButtonBottomAnchor?.constant = -30
            // nextButtonBottomAnchor?.constant = -30

            skipButton.snp.updateConstraints { make in
                make.bottom.equalTo(view.snp.bottom).offset(-35)
            }
            nextButton.snp.updateConstraints { make in
                make.bottom.equalTo(view.snp.bottom).offset(-35)
            }
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    fileprivate func moveControlConstraintsOffScreen() {
        pageControl.snp.updateConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(80)
        }

        skipButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(80)
        }
        nextButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(80)
        }
    }

    fileprivate func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
        // HomeView
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return pages.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // we're rendering our last login cell
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            loginCell.delegate = self
            return loginCell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell

        let page = pages[(indexPath as NSIndexPath).item]
        cell.page = page

        return cell
    }

    func finishLoggingIn() {
        // we'll perhaps implement the home controller a little later
        self.view.endEditing(true)
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let mainNavigationController = rootViewController as? MainNavigationController else { return }
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        mainNavigationController.view.layer.add(transition, forKey: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! UITabBarController
        mainNavigationController.view.layer.add(transition, forKey: nil)
        mainNavigationController.viewControllers = [self, tabBarController]
      
        UserDefaults.standard.setIsLoggedIn(value: true)
        
        
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return view.bounds.size
    }

    override func willTransition(to collection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: collection, with: coordinator)

        collectionView.collectionViewLayout.invalidateLayout()

        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        // scroll to indexPath after the rotation is going
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: true
            )
            self?.collectionView.reloadData()
        }
    }
}
