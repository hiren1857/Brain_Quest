//
//  ChooseRandomColorVC.swift
//  Game
//
//  Created by test on 07/06/25.
//

import UIKit
import GoogleMobileAds

class ChooseRandomColorVC: UIViewController {

    @IBOutlet weak var scoreVw: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var qusVw: UIView!
    @IBOutlet weak var lblQus: UILabel!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var adVw: BannerView!
    
    var ArrNineColors : NSMutableArray = ["Red","Blue","Green","Yellow","Oragne","Black","Brown","Purpule","Cyan"]
    var ArrNineUIColors : NSMutableArray = [UIColor.red,UIColor.blue,UIColor.green,UIColor.yellow,
                                         UIColor.orange,UIColor.black,UIColor.brown,UIColor.purple,
                                         UIColor.cyan]
    var firstColor : Int = Int()
    var secondColor : Int = Int()
    var thirdcolor : Int = Int()
    var selectedColor : Int = Int()
    var timer = Timer()
    var seconds : Float = 0.0
    var timeIntervals : Double = 0.0
    var strLevel : String = "Easy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScore.text = "0"
        loadColors()
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[13] as! [NSDictionary]
        VC.strGameName = "Choose Random Color"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Play" {
                runTimer()
            } else {
                loadColors()
                lblScore.text = "0"
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[13] as! [NSDictionary]
        VC.strGameName = "Choose Random Color"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    func loadColors() {
        ChooseRandomColorVC.DropShadow(views: [scoreVw,vw1,vw2,vw3])
        ChooseRandomColorVC.btnDropShadow(views: [qusVw])
        firstColor = Int(arc4random_uniform(9))
        secondColor = (firstColor == 0) ? 8 : (firstColor - 1)
        thirdcolor = (secondColor == 0) ? 7 : ((secondColor == 1) ? 8 : (secondColor - 2))
        vw1.backgroundColor = ArrNineUIColors[firstColor] as? UIColor
        vw2.backgroundColor = ArrNineUIColors[secondColor] as? UIColor
        vw3.backgroundColor = ArrNineUIColors[thirdcolor] as? UIColor
        selectedColor = Int(arc4random_uniform(3))
        if selectedColor == 0 {
            lblQus.text = ArrNineColors[firstColor] as? String
            lblQus.textColor = ArrNineUIColors[secondColor] as? UIColor
        } else if selectedColor == 1 {
            lblQus.text = ArrNineColors[secondColor] as? String
            lblQus.textColor = ArrNineUIColors[firstColor] as? UIColor
        } else if selectedColor == 2 {
            lblQus.text = ArrNineColors[thirdcolor] as? String
            lblQus.textColor = ArrNineUIColors[firstColor] as? UIColor
        }
        runTimer()
    }

    func runTimer() {
        timer.invalidate()
        if strLevel == "Easy" {
            seconds = 6
        } else if strLevel == "Medium" {
            seconds = 4
        } else {
            seconds = 2
        }
        timeIntervals = Double(Double(seconds)/Double(100))
        timer = Timer.scheduledTimer(timeInterval: timeIntervals, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        if seconds > 0 {
            seconds = seconds - Float(timeIntervals)
            progressBar.progress = (seconds)/Float((timeIntervals*100))
        } else {
            timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_RandomColor(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }

    @IBAction func btnTap(_ sender: UIButton) {
        if selectedColor == sender.tag {
            lblScore.text = String(Int(lblScore.text!)! + 1)
            loadColors()
        } else {
            timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_RandomColor(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_RandomColor(mode: strLevel))"
        VC.score = "Score : \(lblScore.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            loadColors()
            lblScore.text = "0"
        }
        self.present(VC, animated: true)
    }
    
}
