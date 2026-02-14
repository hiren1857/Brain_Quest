//
//  FindOperatorVC.swift
//  Game
//
//  Created by test on 06/06/25.
//

import UIKit
import GoogleMobileAds

class FindOperatorVC: UIViewController {
    
    @IBOutlet weak var mainVw: UIView!
    @IBOutlet weak var socreVw: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var equestionVw: UIView!
    @IBOutlet weak var lblEquestion: UILabel!
    @IBOutlet weak var btnOp1: UIButton!
    @IBOutlet weak var btnOp2: UIButton!
    @IBOutlet weak var btnOp3: UIButton!
    @IBOutlet weak var btnOp4: UIButton!
    @IBOutlet weak var adVw: BannerView!
    
    var timer = Timer()
    var seconds : Float = 0.0
    var time_Intervals : Double = 0.0
    var strLevel : String = "Easy"
    var str_Answer : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEquestion()
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[2] as! [NSDictionary]
        VC.strGameName = "Find Operator"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Play" {
                runTimer()
            } else {
                setEquestion()
                lblScore.text = "0"
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[2] as! [NSDictionary]
        VC.strGameName = "Find Operator"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)

    }
    
    func setEquestion() {
        lblEquestion.text = getEquetion(Mode: strLevel)
        FindOperatorVC.btnDropShadow(views: [socreVw,equestionVw,btnOp1,btnOp2,btnOp3,btnOp4])
        let Arr_shuffled_operator : NSMutableArray = NSMutableArray(array: Array(["+","-","*","/"]).shuffled)
        btnOp4.setTitle(Arr_shuffled_operator[3] as? String, for: .normal)
        btnOp3.setTitle(Arr_shuffled_operator[2] as? String, for: .normal)
        btnOp2.setTitle(Arr_shuffled_operator[1] as? String, for: .normal)
        btnOp1.setTitle(Arr_shuffled_operator[0] as? String, for: .normal)
        runTimer()
    }
    // MARK: - Set Timer
    func runTimer(){
        timer.invalidate()
        if strLevel == "Easy" {
           seconds = 5
        } else if strLevel == "Medium" {
            seconds = 4
        } else {
            seconds = 3
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
            mainVw.isUserInteractionEnabled = false
            DEFAULTS.Set_Best_Score_Of_Find_Operator(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }

    func getEquetion(Mode : String) -> String {
        var Operator : Int = Int()
        var Operant_One : Int = Int()
        var Operant_Two : Int = Int()
        switch strLevel {
        case "Easy" :
            Operator = Int(arc4random_uniform(4))
            Operant_One = Int(arc4random_uniform(20)+1)
            Operant_Two = Int(arc4random_uniform(20)+1)
        case "Medium" :
            Operator = Int(arc4random_uniform(4))
            Operant_One = Int(arc4random_uniform(50)+1)
            Operant_Two = Int(arc4random_uniform(50)+1)
        case "Hard" :
            Operator = Int(arc4random_uniform(4))
            Operant_One = Int(arc4random_uniform(99)+1)
            Operant_Two = Int(arc4random_uniform(99)+1)
        default:
            Operator = Int(arc4random_uniform(4))
            Operant_One = Int(arc4random_uniform(20)+1)
            Operant_Two = Int(arc4random_uniform(20)+1)
        }
        var str_Question : String = String()
        switch Operator {
        case 0:
            str_Question = String(format: "%d ? %d = %d", Operant_One,Operant_Two,(Operant_One+Operant_Two))
            str_Answer = "+"
        case 1:
            str_Question = String(format: "%d ? %d = %d", Operant_One,Operant_Two,(Operant_One-Operant_Two))
            str_Answer = "-"
        case 2:
            str_Question = String(format: "%d ? %d = %d", Operant_One,Operant_Two,(Operant_One*Operant_Two))
            str_Answer = "*"
        case 3:
            str_Question = String(format: "%d ? %d = %.2f", Operant_One,Operant_Two,Float(Float(Operant_One)/Float(Operant_Two)))
            str_Answer = "/"
        default:
            str_Question = String(format: "%d ? %d = %d", Operant_One,Operant_Two,(Operant_One+Operant_Two))
            str_Answer = "+"
        }
        return (str_Question)
    }
    
    @IBAction func btnOpTap(_ sender: UIButton) {
        if str_Answer == sender.currentTitle! {
            lblScore.text = String(Int(lblScore.text!)! + 1)
            setEquestion()
        } else {
            timer.invalidate()
            mainVw.isUserInteractionEnabled = false
            DEFAULTS.Set_Best_Score_Of_Find_Operator(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_Find_Operator(mode: strLevel))"
        VC.score = "Score : \(lblScore.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            setEquestion()
            mainVw.isUserInteractionEnabled = true
            lblScore.text = "0"
        }
        present(VC, animated: true)
    }
}
