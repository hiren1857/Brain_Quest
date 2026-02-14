//
//  MathDualVC.swift
//  Game
//
//  Created by test on 05/06/25.
//

import UIKit

class MathDualVC: UIViewController {
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnPlayer2Op1: UIButton!
    @IBOutlet weak var btnPlayer2Op2: UIButton!
    @IBOutlet weak var btnPlayer2Op3: UIButton!
    @IBOutlet weak var btnPlayer1Op1: UIButton!
    @IBOutlet weak var btnPlayer1Op2: UIButton!
    @IBOutlet weak var btnPlayer1Op3: UIButton!
    @IBOutlet weak var btnPlayer2Q: UILabel!
    @IBOutlet weak var btnPlayer1Q: UILabel!
    @IBOutlet weak var btnPlayer2S: UILabel!
    @IBOutlet weak var btnPlayer1S: UILabel!
    @IBOutlet weak var vwDivier: UIView!
    
    var strQuestion : String = ""
    var strFirstOption : String = ""
    var strSecoundOption : String = ""
    var strThirdOption : String = ""
    var strFourthOption : String = ""
    var strAnswer : String = ""
    var strPlayer2Score : Int = 0
    var strPlayer1Score : Int = 0
    var strLevel : String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestion()
        setBarBtn()
    }
    
    func setBarBtn() {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"), style: .plain, target: self, action: #selector(rightButtonTapped))
        rightButton.tintColor = UIColor.systemYellow
        self.navigationItem.rightBarButtonItem = rightButton
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: self, action: #selector(leftButtonTapped))
        leftButton.tintColor = UIColor.systemYellow
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func leftButtonTapped() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "LevelVC") as! LevelVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[0] as! [NSDictionary]
        VC.strGameName = "Math Dual"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Reset" {
                setQuestion()
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[0] as! [NSDictionary]
        VC.strGameName = "Math Dual"
        VC.isLevel = true
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    func setQuestion() {
        (strQuestion,strAnswer,strFirstOption,strSecoundOption,strThirdOption) = getEquetion(mode: strLevel)
        btnPlayer1Q.text = strQuestion
        btnPlayer2Q.text = strQuestion
        btnPlayer1Op1.setTitle(strFirstOption, for: .normal)
        btnPlayer1Op2.setTitle(strSecoundOption, for: .normal)
        btnPlayer1Op3.setTitle(strThirdOption, for: .normal)
        btnPlayer2Op1.setTitle(strFirstOption, for: .normal)
        btnPlayer2Op2.setTitle(strSecoundOption, for: .normal)
        btnPlayer2Op3.setTitle(strThirdOption, for: .normal)
        rotateView(views: [btnPlayer2S,btnPlayer2Q,btnPlayer2Op1,btnPlayer2Op2,btnPlayer2Op3])
        MathDualVC.btnDropShadow(views: [btnPlayer1Op1,btnPlayer1Op2,btnPlayer1Op3,btnPlayer2Op1,btnPlayer2Op2,btnPlayer2Op3])
    }
    
    func rotateView(views : [UIView]) {
        for view in views {
            view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
    
    func getEquetion(mode : String) -> (String,String,String,String,String) {
        var Operator : Int = Int()
        var Operant_One : Int = Int()
        var Operant_Two : Int = Int()
        switch mode {
        case "Easy" :
            Operator = Int(arc4random_uniform(2))
            Operant_One = Int(arc4random_uniform(20)+1)
            Operant_Two = Int(arc4random_uniform(20)+1)
        case "Medium" :
            Operator = Int(arc4random_uniform(3))
            Operant_One = Int(arc4random_uniform(50)+1)
            Operant_Two = Int(arc4random_uniform(50)+1)
        case "Hard" :
            Operator = Int(arc4random_uniform(3))
            Operant_One = Int(arc4random_uniform(99)+1)
            Operant_Two = Int(arc4random_uniform(99)+1)
        default:
            Operator = Int(arc4random_uniform(2))
            Operant_One = Int(arc4random_uniform(20)+1)
            Operant_Two = Int(arc4random_uniform(20)+1)
        }
        var str_Question : String = String()
        var str_Answer : String = String()
        var Arr_Options : NSMutableArray = NSMutableArray()
        switch Operator {
        case 0:
            str_Question = String(format: "%d + %d", Operant_One,Operant_Two)
            str_Answer = String(Operant_One+Operant_Two)
        case 1:
            str_Question = String(format: "%d - %d", Operant_One,Operant_Two)
            str_Answer = String(Operant_One-Operant_Two)
        case 2:
            str_Question = String(format: "%d * %d", Operant_One,Operant_Two)
            str_Answer = String(Operant_One*Operant_Two)
        default:
            str_Question = String(format: "%d + %d", Operant_One,Operant_Two)
            str_Answer = String(Operant_One+Operant_Two)
        }
        Arr_Options.add(str_Answer)
        Arr_Options.add(String(Int(str_Answer)! + Int(arc4random_uniform(20))))
        Arr_Options.add(String(Int(str_Answer)! - Int(arc4random_uniform(20))))
        Arr_Options = NSMutableArray(array: Array(Arr_Options).shuffled)
        return (str_Question,str_Answer,String(describing : Arr_Options[0]),String(describing : Arr_Options[1]),String(describing : Arr_Options[2]))
    }

    @IBAction func btnPlayer2AnsTap(_ sender: UIButton) {
        setPlayer2Score(answer: sender.currentTitle!)
    }
    
    @IBAction func btnPlayer1AnsTap(_ sender: UIButton) {
        setPlayer1Score(answer: sender.currentTitle!)
    }
    
    func setPlayer1Score(answer : String) {
        if strAnswer == answer {
            strPlayer1Score = strPlayer1Score + 1
            if strPlayer1Score == 10 {
                vwMain.isUserInteractionEnabled = false
                gameOver(player1Score: "Player 1 : \(strPlayer1Score)", player2Score: "Player 2 : \(strPlayer2Score)", message: "Winner : P1")
            } else {
                setQuestion()
            }
        } else {
            strPlayer1Score = (strPlayer1Score > 0) ? (strPlayer1Score-1) : 0
        }
        btnPlayer1S.text = "P1 : " + String(strPlayer1Score)
    }

    func setPlayer2Score(answer : String) {
        if strAnswer == answer {
            strPlayer2Score = strPlayer2Score + 1
            if strPlayer2Score == 10 {
                vwMain.isUserInteractionEnabled = false
                gameOver(player1Score: "Player 2 : \(strPlayer2Score)", player2Score: "Player 1 : \(strPlayer1Score)", message: "Winner : P2")
            } else {
                setQuestion()
            }
        } else {
            strPlayer2Score = (strPlayer2Score > 0) ? (strPlayer2Score-1) : 0
        }
        btnPlayer2S.text = "P2 : " + String(strPlayer2Score)
    }
    
    func gameOver(player1Score: String, player2Score: String, message : String) {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = player2Score
        VC.score = player1Score
        VC.gameOver = message
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            vwMain.isUserInteractionEnabled = true
            setQuestion()
        }
        present(VC, animated: true)
    }
}
