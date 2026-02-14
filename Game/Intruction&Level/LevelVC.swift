//
//  LevelVC.swift
//  Game
//
//  Created by test on 05/06/25.
//

import UIKit

class LevelVC: UIViewController {

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    
    var strGameName : String = ""
    var arrInstructions : [NSDictionary] = []
    var IsLevel: ((String) -> Void)?
    var isGame = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        LevelVC.btnDropShadow(views: [btn1,btn3,btn3])
        if isGame {
            btn1.setTitle("Play", for: .normal)
            btn2.setTitle("Reset", for: .normal)
            btn3.setTitle("Home", for: .normal)
            btnDismiss.isHidden = true
        } else {
            btn1.setTitle("Easy", for: .normal)
            btn2.setTitle("Medium", for: .normal)
            btn3.setTitle("Hard", for: .normal)
            btnDismiss.isHidden = false
        }
        
    }
    
    @IBAction func btnInfoTap(_ sender: UIButton) {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = arrInstructions
        VC.strGameName = strGameName
        VC.isLevel = true
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @IBAction func btnCloseTap(_ sender: UIButton) {
        self.dismiss(animated: true) {
            AdMob.sharedInstance()?.loadInste(self)
        }
    }
    
    @IBAction func btnPlayTap(_ sender: UIButton) {
        if isGame {
            if sender.tag == 1 {
                IsLevel?("Play")
                self.dismiss(animated: true)
            } else if sender.tag == 2 {
                IsLevel?("Reset")
                self.dismiss(animated: true)
            } else {
                if let tabBarController = Constants.storyBoard.instantiateViewController(withIdentifier: "GameVC") as? GameVC {
                    tabBarController.navigationItem.largeTitleDisplayMode = .always
                    var nav = UINavigationController(rootViewController: tabBarController)
                    nav.navigationBar.prefersLargeTitles = true
                    if let window = UIApplication.shared.windows.first {
                        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                            window.rootViewController = nav }, completion: nil)
                    }
                }
            }
        } else {
            if sender.tag == 1 {
                IsLevel?("Easy")
            } else if sender.tag == 2 {
                IsLevel?("Medium")
            } else {
                IsLevel?("Hard")
            }
            self.dismiss(animated: true) {
                AdMob.sharedInstance()?.loadInste(self)
            }
        }
    }
    
}
