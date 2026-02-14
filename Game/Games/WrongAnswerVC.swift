//
//  WrongAnswerVC.swift
//  Game
//
//  Created by test on 07/06/25.
//

import UIKit
import GoogleMobileAds

class WrongAnswerVC: UIViewController {

    @IBOutlet weak var scoreVw: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var progessBar: UIProgressView!
    @IBOutlet weak var qusVw: UIView!
    @IBOutlet weak var lblQus: UILabel!
    @IBOutlet weak var btnTrue: UIButton!
    @IBOutlet weak var btnFalse: UIButton!
    @IBOutlet weak var adVw: BannerView!
    
    var timer = Timer()
    var seconds : Float = 0.0
    var timeIntervals : Double = 0.0
    var strLevel : String = "Easy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScore.text = "0"
        setEquation()
        setBarBtn()
    }
    
    func setBarBtn() {
        setupBanner(GADAdSize: AdSizeFullBanner, Banner: adVw)

        let rightButton = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"), style: .plain, target: self, action: #selector(rightButtonTapped))
        rightButton.tintColor = UIColor.systemYellow
        self.navigationItem.rightBarButtonItem = rightButton
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: self, action: #selector(leftButtonTapped))
        leftButton.tintColor = UIColor.systemYellow
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func leftButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "LevelVC") as! LevelVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[8] as! [NSDictionary]
        VC.strGameName = "Wrong Answer"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Play" {
                runTimer()
            } else {
                setEquation()
                lblScore.text = "0"
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[8] as! [NSDictionary]
        VC.strGameName = "Wrong Answer"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    func setEquation() {
        WrongAnswerVC.btnDropShadow(views: [btnTrue,btnFalse,qusVw,scoreVw])
        let index = Int(arc4random_uniform(UInt32(Singleton.sharedInstance.arrEquetions.count)))
        lblQus.text = Singleton.sharedInstance.arrEquetions[index] as? String
        progessBar.progress = 1.0
        runTimer()
    }
    
    func runTimer(){
        self.timer.invalidate()
        if strLevel == "Easy" {
            seconds = 4
        } else if strLevel == "Medium" {
            seconds = 3
        } else {
            seconds = 2
        }
        self.timeIntervals = Double(Double(seconds)/Double(100))
        timer = Timer.scheduledTimer(timeInterval: timeIntervals, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds > 0 {
            seconds = seconds - Float(timeIntervals)
            progessBar.progress = (seconds)/Float((timeIntervals*100))
        } else {
            timer.invalidate()
            btnTrue.isUserInteractionEnabled = false
            btnFalse.isUserInteractionEnabled = false
            DEFAULTS.Set_Best_Score_Of_Math_Equestion(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }
    
    
    @IBAction func btnTap(_ sender: UIButton) {
        let index = Int(Singleton.sharedInstance.arrEquetions.index(of: lblQus.text!))
        if Singleton.sharedInstance.arrAnswers[index] as! String != String(sender.tag) {
            lblScore.text = String(Int(lblScore.text!)! + 1)
            setEquation()
        } else {
            timer.invalidate()
            btnTrue.isUserInteractionEnabled = false
            btnFalse.isUserInteractionEnabled = false
            DEFAULTS.Set_Best_Score_Of_Math_Equestion(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_Wrong_Answer(mode: strLevel))"
        VC.score = "Score : \(lblScore.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            setEquation()
            btnTrue.isUserInteractionEnabled = true
            btnFalse.isUserInteractionEnabled = true
            lblScore.text = "0"
        }
        self.present(VC, animated: true)
    }
    
}
