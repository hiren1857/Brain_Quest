//
//  RememberSpellingVC.swift
//  Game
//
//  Created by test on 06/06/25.
//

import UIKit
import GoogleMobileAds

class RememberSpellingVC: UIViewController {

    @IBOutlet weak var scoreVw: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var QusVw: UIView!
    @IBOutlet weak var lblQus: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var adVw: BannerView!
    
    var timer = Timer()
    var seconds : Float = 0.0
    var time_Intervals : Double = 0.0
    var strLevel : String = "Easy"
    var Arr_Previous_Spellings : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSpelling()
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[4] as! [NSDictionary]
        VC.strGameName = "Remember Spelling"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Play" {
                runTimer()
            } else {
                setSpelling()
                lblScore.text = "0"
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[4] as! [NSDictionary]
        VC.strGameName = "Remember Spelling"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
   
    func setSpelling() {
        
        RememberSpellingVC.btnDropShadow(views: [scoreVw,QusVw])
        RememberSpellingVC.btnDropShadow(views: [btnYes,btnNo])
        
        let arr_index = Int(arc4random_uniform(2))
        var index : Int = 0
        if arr_index == 0 && Arr_Previous_Spellings.count > 0 {
            index = Int(arc4random_uniform(UInt32(Arr_Previous_Spellings.count)))
            lblQus.text = Arr_Previous_Spellings[index] as? String
        } else if arr_index == 1 {
            index = Int(arc4random_uniform(UInt32(Singleton.sharedInstance.arrSpellings.count)))
            lblQus.text = Singleton.sharedInstance.arrSpellings[index] as? String
        } else {
            index = Int(arc4random_uniform(UInt32(Singleton.sharedInstance.arrSpellings.count)))
            lblQus.text  = Singleton.sharedInstance.arrSpellings[index] as? String
        }
        Arr_Previous_Spellings.add(lblQus.text!)
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
        self.time_Intervals = Double(Double(seconds)/Double(100))
        timer = Timer.scheduledTimer(timeInterval: time_Intervals, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if self.seconds > 0 {
            self.seconds = seconds - Float(time_Intervals)
            self.progressBar.progress = (seconds)/Float((time_Intervals*100))
        } else {
            self.timer.invalidate()
            self.btnYes.isUserInteractionEnabled = false
            self.btnNo.isUserInteractionEnabled = false
            DEFAULTS.Set_Best_Score_Of_RememberSpelling(Score: self.lblScore.text!, mode: strLevel)
            gameOver()
        }
    }
    
    @IBAction func btnTap(_ sender: UIButton) {
        if (sender.currentTitle! == "YES") ? ((Arr_Previous_Spellings.filter{ ($0 as! String) == lblQus.text! } as NSArray).count > 1) : ((Arr_Previous_Spellings.filter{ ($0 as! String) == lblQus.text! } as NSArray).count == 1) {
            lblScore.text = String(Int(lblScore.text!)! + 1)
            setSpelling()
        } else {
            timer.invalidate()
            btnYes.isUserInteractionEnabled = false
            btnNo.isUserInteractionEnabled = false
            timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_RememberSpelling(Score: self.lblScore.text!, mode: strLevel)
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_RememberSpelling(mode: strLevel))"
        VC.score = "Score : \(lblScore.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            setSpelling()
            btnYes.isUserInteractionEnabled = true
            btnNo.isUserInteractionEnabled = true
            lblScore.text = "0"
        }
        self.present(VC, animated: true)
    }

}
