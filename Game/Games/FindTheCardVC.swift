//
//  FindTheCardVC.swift
//  Game
//
//  Created by test on 07/06/25.
//

import UIKit
import GoogleMobileAds

class FindTheCardVC: UIViewController {

    @IBOutlet weak var scoreVw: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var progessBar: UIProgressView!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var adVw: BannerView!
    
    var timer = Timer()
    var seconds : Float = 0.0
    var timeIntervals : Double = 0.0
    var strLevel : String = "Easy"
    var arrItems : NSMutableArray = ["Apple","Mango","Pizza","Chilly","Carrot","Tomato","Fish","Goat","Chips"]
    var arrItemImage : NSMutableArray =  ["F1","F5","SP6","V6","V4","V9","SA8","A6","SP3"]
    var arrDisplayItemNames : NSMutableArray = NSMutableArray()
    var arrDisplayItemImages : NSMutableArray = NSMutableArray()
    var answerIndex : Int = Int()
    let itemsperrow : CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 8.0, left:  8.0, bottom: 0.0, right: 8.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScore.text = "0"
        setCards()
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[9] as! [NSDictionary]
        VC.strGameName = "Find The Card"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Play" {
                runTimer()
            } else {
                setCards()
                lblScore.text = "0"
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[9] as! [NSDictionary]
        VC.strGameName = "Find The Card"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    func setCards() {
        FindTheCardVC.DropShadow(views: [scoreVw])
        answerIndex = Int(arc4random_uniform(9))
        arrDisplayItemNames = NSMutableArray(array: Array(arrItems).shuffled)
        arrDisplayItemImages = NSMutableArray()
        for i in 0..<arrDisplayItemNames.count {
            let TempImageIndex : Int = arrItems.index(of: arrDisplayItemNames[i] as! String)
            let ImageIndex = (TempImageIndex == 8) ? 0 : (TempImageIndex + 1)
            arrDisplayItemImages.add(arrItemImage[ImageIndex])
        }
        runTimer()
        collVw.reloadData()
    }
    // MARK: - Timer
    func runTimer(){
        self.timer.invalidate()
        if strLevel == "Easy" {
            seconds = 8
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
            progessBar.progress = (seconds)/Float((timeIntervals*100))
        } else {
            timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_FindTheCard(Score: lblScore.text!, mode: strLevel)
            collVw.isUserInteractionEnabled = false
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_FindTheCard(mode: strLevel))"
        VC.score = "Score : \(lblScore.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            setCards()
            collVw.isUserInteractionEnabled = true
            lblScore.text = "0"
        }
        self.present(VC, animated: true)
    }

    
}

extension FindTheCardVC : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrDisplayItemImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
        cell.layer.cornerRadius = 8
        FindTheCardVC.DropShadow(views: [cell])
        if answerIndex == indexPath.row {
            cell.imgVw.image = UIImage(named: arrDisplayItemImages[indexPath.row] as! String)
            let index : Int = arrItemImage.index(of: String(describing: arrDisplayItemImages[indexPath.row]))
            cell.lblNumber.text = arrItems[index] as? String
        } else {
            cell.imgVw.image = UIImage(named: arrDisplayItemImages[indexPath.row] as! String)
            cell.lblNumber.text = arrItems[indexPath.row] as? String
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.answerIndex {
            lblScore.text = String(Int(lblScore.text!)! + 1)
            setCards()
        } else {
            self.timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_FindTheCard(Score: lblScore.text!, mode: strLevel)
            collectionView.isUserInteractionEnabled = false
            gameOver()
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsperrow + 1)
        let availableWidth = (collectionView.frame.width) - paddingSpace
        let widthPerItem = availableWidth / itemsperrow
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
