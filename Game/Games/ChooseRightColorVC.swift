//
//  ChooseRightColorVC.swift
//  Game
//
//  Created by test on 07/06/25.
//

import UIKit
import GoogleMobileAds

class ChooseRightColorVC: UIViewController {

    @IBOutlet weak var scoreVw: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var adVw: BannerView!
    
    var timer = Timer()
    var seconds : Float = 0.0
    var timeIntervals : Double = 0.0
    var strLevel : String = "Easy"
    var rightColorIndex : Int = Int()
    var wrongColorIndex : Int = Int()
    let itemsPerRow : CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 16.0, left:  16.0, bottom: 0.0, right: 16.0)
    var arrDisplaedColors : NSMutableArray = NSMutableArray()
    var arrDisplaedUIColors : NSMutableArray = NSMutableArray()
    var arrNineColors : NSMutableArray = ["Red","Blue","Green","Yellow","Oragne","Black","Brown","Purpule","Cyan"]
    var arrNineUIColors : NSMutableArray = [UIColor.red,UIColor.blue,UIColor.green,UIColor.yellow,
                                         UIColor.orange,UIColor.black,UIColor.brown,UIColor.purple,
                                         UIColor.cyan]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScore.text = "0"
        setColors()
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[10] as! [NSDictionary]
        VC.strGameName = "Choose Right Color"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Play" {
                runTimer()
            } else {
                setColors()
                lblScore.text = "0"
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[10] as! [NSDictionary]
        VC.strGameName = "Choose Right Color"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    func setColors() {
        ChooseRightColorVC.DropShadow(views: [scoreVw])
        arrDisplaedColors = NSMutableArray(array: Array(arrNineColors).shuffled)
        rightColorIndex = Int(arc4random_uniform(9))
        arrDisplaedUIColors = NSMutableArray()
        for i in 0..<arrDisplaedColors.count {
            let color_UI_index : Int = arrNineColors.index(of: arrDisplaedColors[i] as! String)
            let color_UI_index2 = (color_UI_index == 8) ? 0 : (color_UI_index + 1)
            arrDisplaedUIColors.add(arrNineUIColors[color_UI_index2])
        }
        runTimer()
        collVw.reloadData()
    }

    func runTimer(){
        timer.invalidate()
        if strLevel == "Easy" {
            seconds = 7
        } else if strLevel == "Medium" {
            seconds = 5
        } else {
            seconds = 3
        }
        timeIntervals = Double(Double(seconds)/Double(100))
        timer = Timer.scheduledTimer(timeInterval: timeIntervals, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds > 0 {
            seconds = seconds - Float(timeIntervals)
            progressBar.progress = (seconds)/Float((timeIntervals*100))
        } else {
            timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_ChoseRightColor(Score: lblScore.text!, mode: strLevel)
            collVw.isUserInteractionEnabled = false
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_ChoseRightColor(mode: strLevel))"
        VC.score = "Score : \(lblScore.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            setColors()
            collVw.isUserInteractionEnabled = true
            lblScore.text = "0"
        }
        self.present(VC, animated: true)
    }

}

extension ChooseRightColorVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrDisplaedUIColors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
        if rightColorIndex == indexPath.row {
            cell.lblBg.backgroundColor = arrDisplaedUIColors[indexPath.row] as? UIColor
            let index : Int = arrNineUIColors.index(of: arrDisplaedUIColors[indexPath.row] as? UIColor ?? UIColor.red)
            cell.lblNumber.text = arrNineColors[index] as? String
        } else {
            cell.lblBg.backgroundColor = arrDisplaedUIColors[indexPath.row] as? UIColor
            cell.lblNumber.text = arrDisplaedColors[indexPath.row] as? String
        }
        cell.lblNumber.layer.cornerRadius = 8
        cell.lblBg.layer.cornerRadius = 8
        cell.lblNumber.layer.masksToBounds = true
        cell.lblBg.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        ChooseRightColorVC.DropShadow(views: [cell])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == rightColorIndex {
            lblScore.text = String(Int(lblScore.text!)! + 1)
            setColors()
        } else {
            timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_ChoseRightColor(Score: lblScore.text!, mode: strLevel)
            collectionView.isUserInteractionEnabled = false
            gameOver()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = (collectionView.frame.width) - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: Int(widthPerItem), height: Int(widthPerItem))
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
