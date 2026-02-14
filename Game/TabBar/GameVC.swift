//
//  GameVC.swift
//  Game
//
//  Created by test on 05/06/25.
//

import UIKit
import SkeletonView
import AppTrackingTransparency

class GameVC: UIViewController {

    @IBOutlet weak var collHeghit: NSLayoutConstraint!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var adsVw: UIView!
    @IBOutlet weak var adsVwHeight: NSLayoutConstraint!
    
    var arrGameNames = ["Math\nDual","Math\nEquation",
                        "Find\nOperator","Spelling\nOccurrence",
                        "Remember\nSpelling","Tap\nOn The\nNumber",
                        "Guess\nWeek\nDay","Odd\nMan\nOut","Wrong\nAnswer",
                        "Find\nThe\nCard",
                        "Choose\nRight\nColor","Choose\nWrong\nColor",
                        "Color\nIntensity","Choose\nRandom\nColor"]
    
    var arrGameIcon = ["MathDualVC","MathEquestionVC","FindOperatorVC","SpellingOccurrenceVC","RememberSpellingVC","TaponthennumberVC","GuessWeekDayVC","OddManOutVC","WrongAnswerVC","FindTheCardVC","ChooseRightColorVC","ChooseWrongColorVC","ColorIntensityVC","ChooseRandomColorVC"]
    
    let nativeAdManager = NativeAdManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpColl()
    }
    
    func setUpColl() {
        let btn = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(btnSetting))
        btn.tintColor = .systemYellow
        self.navigationItem.rightBarButtonItem = btn
        
        ATTrackingManager.requestTrackingAuthorization { status in }
        DispatchQueue.main.async { [self] in
            let bound = view.bounds.width
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
            var width: CGFloat = (bound / 2.24)
            if(Device.DeviceType.IS_IPAD) {
                width = (bound / 3) - 18
            }
            layout.sectionHeadersPinToVisibleBounds = true
            let size = CGSize(width:width, height: width)
            layout.itemSize = size
            
            collVw.collectionViewLayout = layout
            collVw.delegate = self
            collVw.dataSource = self
            collVw.reloadData()
        }
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(shortCutType(_:)), name: NSNotification.Name(rawValue: "shortCutType"), object: nil)
        
        if Constants.USERDEFAULTS.value(forKey: "isShowAds") == nil && Utils().isConnectedToNetwork() {
            let adUnitID = Constants.USERDEFAULTS.value(forKey: "INTERTIALS") ?? ""
            _ = AdMob.sharedInstance()?.createAndLoadInterstitial(intID: adUnitID as! String)
            adsVw.isHidden = false
            adsVwHeight.constant = 145
            nativeAdManager.setupNativeAd(in: self, placeholderView: self.adsVw)
        } else {
            adsVw.isHidden = true
            adsVwHeight.constant = 0
            self.navigationItem.leftBarButtonItem = nil
        }
        GameVC.setcornerRadius(view: adsVw, cornerradius: 10)
        GameVC.btnDropShadow(views: [adsVw])
    }
    
    @objc func shortCutType(_ notification: NSNotification) {
        if (notification.userInfo as NSDictionary?) != nil {
        }
    }
    
    @objc func btnSetting() {
        let VC = Constants.storyBoard.instantiateViewController(identifier: "SettingVC") as! SettingVC
        VC.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(VC, animated: true)
    }

}

extension GameVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrGameNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collHeghit.constant = collectionView.contentSize.height
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameColl", for: indexPath) as! gameColl
        cell.lblTitle.text = arrGameNames[indexPath.item]
        cell.imgVw.image = UIImage(named: arrGameIcon[indexPath.item])
        GameVC.setcornerRadius(view: cell, cornerradius: 10)
        GameVC.DropShadow(views: [cell])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let gameName = arrGameNames[indexPath.item].replacingOccurrences(of: "\n", with: " ")
        if DEFAULTS.IsShowInstructionPopup(gameName: gameName) {
            let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "IntructionsVC") as! IntructionsVC
            VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[indexPath.item] as! [NSDictionary]
            VC.strGameName = gameName
            VC.IsNotShowAgian = { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                    let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "LevelVC") as! LevelVC
                    VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[indexPath.item] as! [NSDictionary]
                    VC.strGameName = gameName
                    VC.IsLevel = { [self] level in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                            goToGame(level: level, index: indexPath.item)
                        }
                    }
                    VC.isModalInPresentation = true
                    self.present(VC, animated: true)
                }
            }
            VC.isModalInPresentation = true
            self.present(VC, animated: true)
        } else {
            let VC = Constants.storyBoard.instantiateViewController(withIdentifier: "LevelVC") as! LevelVC
            VC.arrInstructions = Singleton.sharedInstance.arrGameInstructions[indexPath.item] as! [NSDictionary]
            VC.strGameName = gameName
            VC.IsLevel = { [self] level in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                    goToGame(level: level, index: indexPath.item)
                }
            }
            VC.isModalInPresentation = true
            self.present(VC, animated: true)
        }
    }
    
    func goToGame(level: String, index: Int) {
        var VC : UIViewController
        switch arrGameIcon[index] {
        case "MathDualVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "MathDualVC") as! MathDualVC
            (VC as! MathDualVC).strLevel = level
        case "MathEquestionVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "MathEquestionVC") as! MathEquestionVC
            (VC as! MathEquestionVC).strLevel = level
        case "FindOperatorVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "FindOperatorVC") as! FindOperatorVC
            (VC as! FindOperatorVC).strLevel = level
        case "SpellingOccurrenceVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "SpellingOccurrenceVC") as! SpellingOccurrenceVC
            (VC as! SpellingOccurrenceVC).strLevel = level
        case "RememberSpellingVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "RememberSpellingVC") as! RememberSpellingVC
            (VC as! RememberSpellingVC).strLevel = level
        case "TaponthennumberVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "TaponthennumberVC") as! TaponthennumberVC
            (VC as! TaponthennumberVC).strLevel = level
        case "GuessWeekDayVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "GuessWeekDayVC") as! GuessWeekDayVC
            (VC as! GuessWeekDayVC).strLevel = level
        case "OddManOutVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "OddManOutVC") as! OddManOutVC
            (VC as! OddManOutVC).strLevel = level
        case "WrongAnswerVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "WrongAnswerVC") as! WrongAnswerVC
            (VC as! WrongAnswerVC).strLevel = level
        case "FindTheCardVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "FindTheCardVC") as! FindTheCardVC
            (VC as! FindTheCardVC).strLevel = level
        case "ChooseRightColorVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "ChooseRightColorVC") as! ChooseRightColorVC
            (VC as! ChooseRightColorVC).strLevel = level
        case "ChooseWrongColorVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "ChooseWrongColorVC") as! ChooseWrongColorVC
            (VC as! ChooseWrongColorVC).strLevel = level
        case "ColorIntensityVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "ColorIntensityVC") as! ColorIntensityVC
            (VC as! ColorIntensityVC).strLevel = level
        case "ChooseRandomColorVC":
            VC = Constants.storyBoard.instantiateViewController(identifier: "ChooseRandomColorVC") as! ChooseRandomColorVC
            (VC as! ChooseRandomColorVC).strLevel = level
        default: return
        }
        VC.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}


class gameColl: UICollectionViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
}
