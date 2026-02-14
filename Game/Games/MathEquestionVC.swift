//
//  MathEquestionVC.swift
//  Game
//
//  Created by test on 06/06/25.
//

import UIKit
import GoogleMobileAds

class MathEquestionVC: UIViewController {

    @IBOutlet weak var btnTrue: UIButton!
    @IBOutlet weak var btnFalse: UIButton!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblEquestion: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var vwScore: UIView!
    @IBOutlet weak var vwEquestion: UIView!
    @IBOutlet weak var adVw: BannerView!
    
    var timer = Timer()
    var seconds : Float = 0.0
    var time_Intervals : Double = 0.0
    var strLevel : String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setEquation()
        lblScore.text = "0"
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[1] as! [NSDictionary]
        VC.strGameName = "Math Equestion"
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[1] as! [NSDictionary]
        VC.strGameName = "Math Equestion"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    
    func setEquation() {
        MathEquestionVC.btnDropShadow(views: [btnTrue,btnFalse,vwScore,vwEquestion])
        let index = Int(arc4random_uniform(UInt32(Singleton.sharedInstance.arrEquetions.count)))
        lblEquestion.text = Singleton.sharedInstance.arrEquetions[index] as? String
        progressBar.progress = 1.0
        runTimer()
    }
    
    func runTimer() {
        timer.invalidate()
        
        if strLevel == "Easy" {
            seconds = 4
        } else if strLevel == "Medium" {
            seconds = 3
        } else {
            seconds = 2
        }
        time_Intervals = Double(Double(seconds)/Double(100))
        timer = Timer.scheduledTimer(timeInterval: time_Intervals, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds > 0 {
           seconds = seconds - Float(time_Intervals)
           progressBar.progress = (seconds)/Float((time_Intervals*100))
        } else {
           timer.invalidate()
           btnTrue.isUserInteractionEnabled = false
           btnFalse.isUserInteractionEnabled = false
            DEFAULTS.Set_Best_Score_Of_Math_Equestion(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }


    @IBAction func btnTap(_ sender: UIButton) {
        let index = Int(Singleton.sharedInstance.arrEquetions.index(of: lblEquestion.text!))
        if Singleton.sharedInstance.arrAnswers[index] as! String == String(sender.tag) {
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
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_Math_Equestion(mode: strLevel))"
        VC.score = "Score : \(lblScore.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            setEquation()
            lblScore.text = "0"
            btnTrue.isUserInteractionEnabled = true
            btnFalse.isUserInteractionEnabled = true
        }
        present(VC, animated: true)
    }
}
