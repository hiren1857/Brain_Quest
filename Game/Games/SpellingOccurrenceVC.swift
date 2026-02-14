//
//  SpellingOccurrenceVC.swift
//  Game
//
//  Created by test on 06/06/25.
//

import UIKit

class SpellingOccurrenceVC: UIViewController {

    @IBOutlet weak var scoreVw: UIView!
    @IBOutlet weak var lblSocre: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var LblQus: UILabel!
    
    var previousNumber: UInt32?
    var Current_Number : Int = 0
    let itemsperrow : CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 8.0, left:  8.0, bottom: 0.0, right: 8.0)
    var timer = Timer()
    var seconds : Float = 0.0
    var time_Intervals : Double = 0.0
    var strLevel : String = "Easy"
    var Arr_Previous_Spellings : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSpellings()
        lblSocre.text = "0"
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
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "LevelVC") as! LevelVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[3] as! [NSDictionary]
        VC.strGameName = "Spelling Occurrence"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Play" {
                runTimer()
            } else {
                setSpellings()
                lblSocre.text = "0"
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[3] as! [NSDictionary]
        VC.strGameName = "Spelling Occurrence"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    func setSpellings() {
        SpellingOccurrenceVC.DropShadow(views: [scoreVw])
        let arr_index = Int(arc4random_uniform(2))
        var index : Int = 0
        if arr_index == 0 && self.Arr_Previous_Spellings.count > 0 {
            index = Int(arc4random_uniform(UInt32(self.Arr_Previous_Spellings.count)))
            self.LblQus.text = self.Arr_Previous_Spellings[index] as? String
        } else if arr_index == 1 {
            index = Int(arc4random_uniform(UInt32(Singleton.sharedInstance.arrSpellings.count)))
            self.LblQus.text = Singleton.sharedInstance.arrSpellings[index] as? String
        } else {
            index = Int(arc4random_uniform(UInt32(Singleton.sharedInstance.arrSpellings.count)))
            self.LblQus.text  = Singleton.sharedInstance.arrSpellings[index] as? String
        }
        Arr_Previous_Spellings.add(LblQus.text!)
        runTimer()
        collVw.delegate = self
        collVw.dataSource = self
        collVw.reloadData()
    }

    func runTimer(){
        timer.invalidate()
        if strLevel == "Easy" {
            seconds = 8
        } else if strLevel == "Medium" {
            seconds = 5
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
            collVw.isUserInteractionEnabled = false
            DEFAULTS.Set_Best_Score_Of_SpellingOccurrence(Score: lblSocre.text!, mode: strLevel)
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_SpellingOccurrence(mode: strLevel))"
        VC.score = "Score : \(lblSocre.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            setSpellings()
            collVw.isUserInteractionEnabled = true
            lblSocre.text = "0"
        }
        self.present(VC, animated: true)
    }

}
extension SpellingOccurrenceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
        SpellingOccurrenceVC.DropShadow(views: [cell])
        cell.lblNumber.text = String(indexPath.item)
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if ((self.Arr_Previous_Spellings.filter{ ($0 as! String) == LblQus.text! } as NSArray).count-1) == indexPath.row {
            lblSocre.text = String(Int(lblSocre.text!)! + 1)
            self.setSpellings()
        } else {
            self.timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_SpellingOccurrence(Score: lblSocre.text!, mode: strLevel)
            collVw.isUserInteractionEnabled = false
            gameOver()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsperrow + 1)
        let availableWidth = (collectionView.frame.width) - paddingSpace
        let availableheight = collectionView.frame.height - 64
        let widthPerItem = availableWidth / itemsperrow
        let heightPerItem = availableheight / 4
        return CGSize(width: Int(widthPerItem), height: Int(heightPerItem))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

class NumberCell: UICollectionViewCell {
    @IBOutlet weak var lblBg: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
}
