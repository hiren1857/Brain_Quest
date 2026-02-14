//
//  GameOverVC.swift
//  Game
//
//  Created by test on 07/06/25.
//

import UIKit

class GameOverVC: UIViewController {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblGameOver: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblHighestScore: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var mainVw: UIView!
    
    var gameOver = ""
    var highestScore = ""
    var score = ""
    var IsReset: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        GameOverVC.btnDropShadow(views: [btnHome,btnReset,btnShare,imgVw,mainVw])
        lblGameOver.text = gameOver
        lblScore.text = highestScore
        lblHighestScore.text = score
    }
    
    @IBAction func btnHomeTap(_ sender: UIButton) {
        if let tabBarController = Constants.storyBoard.instantiateViewController(withIdentifier: "GameVC") as? GameVC {
            tabBarController.navigationItem.largeTitleDisplayMode = .always
            var nav = UINavigationController(rootViewController: tabBarController)
            nav.navigationBar.prefersLargeTitles = true
            if let window = UIApplication.shared.windows.first {
                UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = nav }, completion: nil)
                    AdMob.sharedInstance()?.loadInste(self)
            }
        }
    }
    
    @IBAction func btnResetTap(_ sender: UIButton) {
        IsReset?(true)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnShareTap(_ sender: UIButton) {
        
    }
    
}
