//
//  OnboardVC.swift
//  Game
//
//  Created by test on 21/08/25.
//

import UIKit
import StoreKit

class OnboardVC: UIViewController {

    
    @IBOutlet weak var collVw_onboarding: UICollectionView!
    @IBOutlet weak var stackVw_pageController: UIStackView!
    @IBOutlet var vw_pageController: [UIView]!
    
    var arrTitle = ["Play with Numbers","Learn and Achieve", "Explore Colors", "Meet the Numbers", "Support us to Grow"]
    var arrSubTitle = ["Turn learning into fun with exciting math games and challenges!", "From letters to goals, discover new ways to grow every day!", "Unleash your creativity with endless color choices and fun tools!", "Numbers come alive to make counting fun and friendly for everyone!", "Show appreciation to the share by leaving a review!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btn_nextTapped(_ sender: UIButton) {
        let cellWidth = collVw_onboarding.frame.width
        let currentOffset = collVw_onboarding.contentOffset
        let nextIndex = Int(currentOffset.x / cellWidth) + 1
        
        if nextIndex > 4 {
            Utils().showLoader(text: "Loading...")
            SKStoreReviewController.requestReview()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                openPremiumPage()
            }
            return
        }
        
        let newOffset = CGPoint(x: CGFloat(nextIndex) * cellWidth, y: currentOffset.y)
        collVw_onboarding.setContentOffset(newOffset, animated: true)
    }
    
    func openPremiumPage() {
        collVw_onboarding.isHidden = true
        UserDefaults.standard.set(1, forKey: "startUp")
        Utils().hideLoader()
        if let tabBarController = Constants.storyBoard.instantiateViewController(withIdentifier: "GameVC") as? GameVC {
            tabBarController.navigationItem.largeTitleDisplayMode = .always
            let nav = UINavigationController(rootViewController: tabBarController)
            nav.navigationBar.prefersLargeTitles = true
            if let window = UIApplication.shared.windows.first {
                UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = nav }, completion: nil)
            }
        }
    }

}

extension OnboardVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVw_onboarding.dequeueReusableCell(withReuseIdentifier: "CollVw_OnboardingCell", for: indexPath) as! CollVw_OnboardingCell
        cell.imgView.image = UIImage(named: arrTitle[indexPath.row])
        cell.lblTitle.text = arrTitle[indexPath.row]
        cell.lblsubtitle.text = arrSubTitle[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffsetX = scrollView.contentOffset.x
        let scroll = currentContentOffsetX / view.frame.width
        let nextIndex = Int(round(scroll))
        
        for (index, page) in vw_pageController.enumerated() {
            page.backgroundColor = (index == nextIndex) ? .systemYellow : .white
        }
        
        if nextIndex == 4 {
            stackVw_pageController.isHidden = true
        } else {
            stackVw_pageController.isHidden = false
        }
        
        if scrollView.contentOffset.x >= (view.frame.width * 4) {
            collVw_onboarding.isScrollEnabled = false
        }
    }
}

class CollVw_OnboardingCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblsubtitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}
