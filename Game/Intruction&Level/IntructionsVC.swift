//
//  IntructionsVC.swift
//  Game
//
//  Created by test on 05/06/25.
//

import UIKit

class IntructionsVC: UIViewController {

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tbleVw: UITableView!
    @IBOutlet weak var vwHeghit: NSLayoutConstraint!
    @IBOutlet weak var buttonVw: UIView!
    @IBOutlet weak var buttonVwHeight: NSLayoutConstraint!
    
    var strGameName : String = ""
    var arrInstructions : [NSDictionary] = []
    var IsNotShowAgian: ((Bool) -> Void)?
    var isLevel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        IntructionsVC.btnDropShadow(views: [btnPlay])
        lblTitle.text = strGameName
        
        if arrInstructions.count > 2 {
            vwHeghit.constant =  400
            if UIDevice.current.userInterfaceIdiom == .pad {
                vwHeghit.constant = 600
            }
        } else {
            vwHeghit.constant = 300
            if UIDevice.current.userInterfaceIdiom == .pad {
                vwHeghit.constant = 450
            }
        }
        
        if strGameName == "Wrong Answer" {
            vwHeghit.constant = IpadorIphone(value: 350)
        }
        if isLevel {
            buttonVwHeight.constant = 0
            buttonVw.isHidden = true
            vwHeghit.constant =  arrInstructions.count > 2 ? 300 : 200
            if strGameName == "Wrong Answer" {
                vwHeghit.constant = IpadorIphone(value: 250)
            }
        } else {
            buttonVwHeight.constant = 100
            buttonVw.isHidden = false
        }
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        if isLevel { IsNotShowAgian?(false) }
        self.dismiss(animated: true) {
            if !self.isLevel {
                AdMob.sharedInstance()?.loadInste(self)
            }
        }
    }
    
    @IBAction func btnPlayTap(_ sender: UIButton) {
        IsNotShowAgian?(false)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnNotShowAgianTap(_ sender: UIButton) {
        IsNotShowAgian?(true)
        DEFAULTS.SetShowInstructionPopupFlag(gameName: strGameName)
        self.dismiss(animated: true)
    }
    
}

extension IntructionsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrInstructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntructionsCell", for: indexPath) as! IntructionsCell
        cell.lblNumber.text = (arrInstructions[indexPath.row]).value(forKey: "InstructionNumber") as? String
        cell.lblTitle.text = (arrInstructions[indexPath.row]).value(forKey: "Instruction") as? String
        return cell
    }
    
}

class IntructionsCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
}
