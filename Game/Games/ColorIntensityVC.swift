//
//  ColorIntensityVC.swift
//  Game
//
//  Created by test on 07/06/25.
//

import UIKit
import GoogleMobileAds

class ColorIntensityVC: UIViewController {
    
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
    var arrCurrentColors : NSMutableArray = NSMutableArray()
    var arrCurrentUIColors : NSMutableArray = NSMutableArray()
    var arrDisplayColors : NSMutableArray = NSMutableArray()
    var arrDisplayUIColors : NSMutableArray = NSMutableArray()
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[12] as! [NSDictionary]
        VC.strGameName = "Color Intensity"
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
        VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[12] as! [NSDictionary]
        VC.strGameName = "Color Intensity"
        VC.isLevel = true
        VC.IsNotShowAgian = { _ in
            self.runTimer()
        }
        VC.isModalInPresentation = true
        self.present(VC, animated: true)
    }
    
    func setColors() {
        rightColorIndex = Int(arc4random_uniform(9))
        wrongColorIndex = (rightColorIndex == 8) ? 2 : ((rightColorIndex == 9) ? 3 : (rightColorIndex + 1))
        arrCurrentColors = [arrNineColors[rightColorIndex] as! String,arrNineColors[wrongColorIndex] as! String]
        arrCurrentUIColors = [arrNineUIColors[rightColorIndex] as! UIColor,arrNineUIColors[wrongColorIndex] as! UIColor]
        arrDisplayColors = NSMutableArray()
        arrDisplayUIColors = NSMutableArray()
        for _ in 0..<9 {
            let color_Index : Int = Int(arc4random_uniform(2))
            arrDisplayColors.add(arrCurrentColors[color_Index])
            arrDisplayUIColors.add(arrCurrentUIColors[color_Index])
        }
        runTimer()
        collVw.reloadData()
    }
    func runTimer() {
        timer.invalidate()
        if strLevel == "Easy" {
            seconds = 3
        } else if strLevel == "Medium" {
            seconds = 2
        } else {
            seconds = 1
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
            DEFAULTS.Set_Best_Score_Of_ColorIntensity(Score: lblScore.text!, mode: strLevel)
            collVw.isUserInteractionEnabled = false
            gameOver()
        }
    }
    
    func gameOver() {
        let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        VC.highestScore = "Highest Score : \(DEFAULTS.Get_Best_Score_Of_ColorIntensity(mode: strLevel))"
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

extension ColorIntensityVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDisplayUIColors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
        cell.lblBg.backgroundColor = arrDisplayUIColors[indexPath.row] as? UIColor
        cell.lblNumber.isHidden = true
        cell.lblNumber.layer.cornerRadius = 8
        cell.lblBg.layer.cornerRadius = 8
        cell.lblNumber.layer.masksToBounds = true
        cell.lblBg.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        ChooseRightColorVC.DropShadow(views: [cell])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let str_setected_Color : String = arrDisplayColors[indexPath.row] as! String
        if (arrDisplayColors.filter{ ($0 as! String) == str_setected_Color } as NSArray).count > 4 {
            lblScore.text = String(Int(lblScore.text!)! + 1)
            setColors()
        } else {
            timer.invalidate()
            DEFAULTS.Set_Best_Score_Of_ColorIntensity(Score: lblScore.text!, mode: strLevel)
            collVw.isUserInteractionEnabled = false
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
