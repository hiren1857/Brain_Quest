//
//  GuessWeekDayVC.swift
//  Game
//
//  Created by test on 06/06/25.
//

import UIKit
import GoogleMobileAds

class GuessWeekDayVC: UIViewController {
    
    @IBOutlet weak var scoreVw: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var qusVw: UIView!
    @IBOutlet weak var lblQus: UILabel!
    @IBOutlet weak var btnOp1: UIButton!
    @IBOutlet weak var btnOp2: UIButton!
    @IBOutlet weak var btnOp3: UIButton!
    @IBOutlet weak var btnOp4: UIButton!
    @IBOutlet weak var adVw: BannerView!
    
    var timer = Timer()
    var seconds : Float = 0.0
    var timeIntervals : Double = 0.0
    var strLevel : String = "Easy"
    var randomIndexToday : Int = 0
    var randomIndexNoOfDays : Int = 0
    var randomIndexBeforeAfter : Int = 0
    var AnswerIndex : Int = 0
    var strAnswer : String = ""
    var ArrWeekDays : [String] = ["Sun","Mon","Tues","Wednes","Thurs","Fri","Satur"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScore.text = "0"
        setQuestion()
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[6] as! [NSDictionary]
        VC.strGameName = "Guess Week Day"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Play" {
                runTimer()
            } else {
                setQuestion()
                lblScore.text = "0"
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[6] as! [NSDictionary]
        VC.strGameName = "Guess Week Day"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    func setQuestion() {
        GuessWeekDayVC.DropShadow(views: [scoreVw])
        GuessWeekDayVC.btnDropShadow(views: [btnOp1,btnOp2,btnOp3,btnOp4,qusVw])

        randomIndexToday = Int(arc4random_uniform(UInt32(ArrWeekDays.count)))
        randomIndexNoOfDays = Int(arc4random_uniform(14)) + 1
        randomIndexBeforeAfter = Int(arc4random_uniform(2))
        AnswerIndex = Int(arc4random_uniform(3))
        if randomIndexBeforeAfter == 0 {
            lblQus.text = "If today is \(self.ArrWeekDays[randomIndexToday])day, before \(randomIndexNoOfDays) days which day was there?"
            let index : Int = randomIndexToday - (randomIndexNoOfDays%7)
            let IndexOfAnswer : Int = ((index < 0) ? (7+index) : (index))
            strAnswer = (index < 0) ? (ArrWeekDays[7+index]) : (ArrWeekDays[index])
            Set_Options(Indexs: [IndexOfAnswer,((IndexOfAnswer+1)%7),((IndexOfAnswer+2)%7),((IndexOfAnswer+3)%7)])
        } else {
            lblQus.text = "If today is \(ArrWeekDays[randomIndexToday])day, after \(randomIndexNoOfDays) days which day will be there?"
            strAnswer = ArrWeekDays[(randomIndexNoOfDays + randomIndexToday)%7]
            Set_Options(Indexs: [((randomIndexNoOfDays + randomIndexToday)%7),((randomIndexNoOfDays + randomIndexToday + 1)%7),((randomIndexNoOfDays + randomIndexToday + 2)%7),((randomIndexNoOfDays + randomIndexToday + 3)%7)])
        }
        runTimer()
    }
    // MARK: - Set Options of questions
    func Set_Options(Indexs : [Int]) {
        let ArrNewIndexs = Array(Indexs).shuffled
        btnOp1.setTitle("\(ArrWeekDays[ArrNewIndexs[0]])day", for: .normal)
        btnOp2.setTitle("\(ArrWeekDays[ArrNewIndexs[1]])day", for: .normal)
        btnOp3.setTitle("\(ArrWeekDays[ArrNewIndexs[2]])day", for: .normal)
        btnOp4.setTitle("\(ArrWeekDays[ArrNewIndexs[3]])day", for: .normal)
    }
    // MARK: - Timer
    func runTimer() {
        self.timer.invalidate()
        if strLevel == "Easy" {
            seconds = 10
        } else if strLevel == "Medium" {
            seconds = 8
        } else {
            seconds = 5
        }
        self.timeIntervals = Double(Double(seconds)/Double(100))
        timer = Timer.scheduledTimer(timeInterval: timeIntervals, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds > 0 {
            seconds = seconds - Float(timeIntervals)
            progressBar.progress = (seconds)/Float((timeIntervals*100))
        } else {
            timer.invalidate()
            btnOp1.isEnabled = false
            btnOp2.isEnabled = false
            btnOp3.isEnabled = false
            btnOp4.isEnabled = false
            DEFAULTS.Set_Best_Score_Of_GuessWeekDay(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }
    
    @IBAction func btnOpTap(_ sender: UIButton) {
        if sender.currentTitle == "\(strAnswer)day" {
            lblScore.text = String(Int(lblScore.text!)! + 1)
            setQuestion()
        } else {
            timer.invalidate()
            btnOp1.isEnabled = false
            btnOp2.isEnabled = false
            btnOp3.isEnabled = false
            btnOp4.isEnabled = false
            DEFAULTS.Set_Best_Score_Of_GuessWeekDay(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_GuessWeekDay(mode: strLevel))"
        VC.score = "Score : \(lblScore.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            setQuestion()
            btnOp1.isEnabled = true
            btnOp2.isEnabled = true
            btnOp3.isEnabled = true
            btnOp4.isEnabled = true
            lblScore.text = "0"
        }
        self.present(VC, animated: true)
    }
  
}
