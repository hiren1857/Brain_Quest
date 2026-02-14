//
//  OddManOutVC.swift
//  Game
//
//  Created by test on 07/06/25.
//

import UIKit
import GoogleMobileAds

class OddManOutVC: UIViewController {
    
    @IBOutlet weak var scoreVw: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var adVw: BannerView!
    
    var timer = Timer()
    var seconds : Float = 0.0
    var timeIntervals : Double = 0.0
    var strLevel : String = "Easy"
    var arrItems : NSMutableArray = NSMutableArray()
    var arrCurrentItems : NSMutableArray = NSMutableArray()
    let itemsperrow : CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 12.0, left:  12.0, bottom: 0.0, right: 12.0)
    var displayedArrIndex : Int = 0
    var indexOfArray : Int = 0
    var oddManOutIndex : Int = 0
    var ansOddManOutIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        setupBanner(GADAdSize: AdSizeFullBanner, Banner: adVw)

        lblScore.text = "0"
        arrItems = [Singleton.sharedInstance.Arr_Birds,Singleton.sharedInstance.Arr_Animal,Singleton.sharedInstance.Arr_Fruits,Singleton.sharedInstance.Arr_Vegitables,Singleton.sharedInstance.Arr_Alphabets,Singleton.sharedInstance.Arr_Number,Singleton.sharedInstance.Arr_Sweet,Singleton.sharedInstance.Arr_Spicy,Singleton.sharedInstance.Arr_Sea_Animal,Singleton.sharedInstance.Arr_Normal_Animal]
        loadItems()
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[7] as! [NSDictionary]
        VC.strGameName = "Odd Man Out"
        VC.isGame = true
        VC.IsLevel = { [self] level in
            if level == "Play" {
                runTimer()
            } else {
                loadItems()
                lblScore.text = "0"
            }
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        timer.invalidate()
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[7] as! [NSDictionary]
        VC.strGameName = "Odd Man Out"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    func loadItems() {
        OddManOutVC.DropShadow(views: [scoreVw])
        displayedArrIndex = Int(arc4random_uniform(10))
        indexOfArray = (displayedArrIndex % 2 == 0) ? (displayedArrIndex + 1) : (displayedArrIndex - 1)
        arrCurrentItems = NSMutableArray(array: Array(arrItems[displayedArrIndex] as! NSArray).shuffled)
        oddManOutIndex = Int(arc4random_uniform(10))
        let Arr_Odd_Man_Out_Arr : NSMutableArray = NSMutableArray(array: arrItems[indexOfArray] as! NSArray)
        let odd_man_out_object = Arr_Odd_Man_Out_Arr[Int(arc4random_uniform(9))]
        ansOddManOutIndex = Int(arc4random_uniform(9))
        arrCurrentItems.replaceObject(at: ansOddManOutIndex, with: odd_man_out_object)
        runTimer()
        collVw.delegate = self
        collVw.dataSource = self
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
        self.timeIntervals = Double(Double(seconds)/Double(100))
        timer = Timer.scheduledTimer(timeInterval: timeIntervals, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds > 0 {
            seconds = seconds - Float(timeIntervals)
            progressBar.progress = (seconds)/Float((timeIntervals*100))
        } else {
            timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_OddManOut(Score: lblScore.text!, mode: strLevel)
            collVw.isUserInteractionEnabled = false
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_OddManOut(mode: strLevel))"
        VC.score = "Score : \(lblScore.text!)"
        VC.gameOver = "Game Over"
        VC.isModalInPresentation = true
        VC.IsReset = { [self] _ in
            loadItems()
            collVw.isUserInteractionEnabled = true
            lblScore.text = "0"
        }
        self.present(VC, animated: true)
    }

}

extension OddManOutVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCurrentItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
        cell.imgVw.image = UIImage(named: (arrCurrentItems[indexPath.row] as? String)!)
        cell.layer.cornerRadius = 8
        OddManOutVC.DropShadow(views: [cell])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
        if indexPath.row == self.ansOddManOutIndex {
            lblScore.text = String(Int(lblScore.text!)! + 1)
            loadItems()
        } else {
            self.timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_OddManOut(Score: lblScore.text!, mode: strLevel)
            collectionView.isUserInteractionEnabled = false
            gameOver()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsperrow + 1)
        let availableWidth = (collectionView.frame.width) - paddingSpace
        let widthPerItem = availableWidth / itemsperrow
        return CGSize(width: Int(widthPerItem), height: Int(widthPerItem))
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
