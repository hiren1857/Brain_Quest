//
//  TaponthennumberVC.swift
//  Game
//
//  Created by test on 06/06/25.
//

import UIKit

class TaponthennumberVC: UIViewController {

    @IBOutlet weak var scoreVw: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblQus: UILabel!
    @IBOutlet weak var collVw: UICollectionView!
    
    var currentNumber : Int = 0
    let itemsperrow : CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 16.0, left:  16.0, bottom: 0.0, right: 16.0)
    var timer = Timer()
    var seconds : Float = 0.0
    var time_Intervals : Double = 0.0
    var strLevel : String = "Easy"
    var previousNumber: UInt32?
    var arrAllNumbers : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScore.text = "0"
        setNumbers()
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[5] as! [NSDictionary]
        VC.strGameName = "Tap On The Number"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Play" {
                runTimer()
            } else {
                setNumbers()
                lblScore.text = "0"
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[5] as! [NSDictionary]
        VC.strGameName = "Tap On The Number"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    func randomNumber() -> UInt32 {
        var randomNumber = arc4random_uniform(99)
        while self.arrAllNumbers.contains(randomNumber) {
            randomNumber = arc4random_uniform(99)
        }
        return randomNumber
    }

    func setNumbers() {
        TaponthennumberVC.DropShadow(views: [scoreVw])
        self.arrAllNumbers = NSMutableArray()
        for _ in 0..<12 {
            arrAllNumbers.add(randomNumber())
        }
        currentNumber = Int(arc4random_uniform(12))
        lblQus.text = "Tap on \(arrAllNumbers[currentNumber])"
        collVw.delegate = self
        collVw.dataSource = self
        collVw.reloadData()
        runTimer()
    }

    func runTimer() {
        timer.invalidate()
        if strLevel == "Easy" {
            seconds = 4
        } else if strLevel == "Medium" {
            seconds = 2
        } else {
            seconds = 1.5
        }
        self.time_Intervals = Double(Double(seconds)/Double(100))
        timer = Timer.scheduledTimer(timeInterval: time_Intervals, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds > 0 {
            seconds = seconds - Float(time_Intervals)
            progressBar.progress = (seconds)/Float((time_Intervals*100))
        } else {
            timer.invalidate()
            collVw.isUserInteractionEnabled = false
            DEFAULTS.Set_Best_Score_Of_Taponthnumber(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_Taponthnumber(mode: strLevel))"
        VC.score = "Score : \(lblScore.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            setNumbers()
            collVw.isUserInteractionEnabled = true
            lblScore.text = "0"
        }
        self.present(VC, animated: true)
    }
    
}

extension TaponthennumberVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
        cell.lblNumber.text = String(describing: arrAllNumbers[indexPath.row])
        TaponthennumberVC.DropShadow(views: [cell])
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == currentNumber {
            lblScore.text = String(Int(lblScore.text!)! + 1)
            setNumbers()
        } else {
            timer.invalidate()
            collectionView.isUserInteractionEnabled = false
            DEFAULTS.Set_Best_Score_Of_Taponthnumber(Score: lblScore.text!, mode: strLevel)
            gameOver()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsperrow + 1)
        let availableWidth = (collectionView.frame.width) - paddingSpace
        let availableheight = collectionView.frame.height - 80
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
