//
//  SettingVC.swift
//  Game
//
//  Created by Hiren R. Chauhan on 06/04/25.
//

import UIKit
import StoreKit
import SafariServices
import MessageUI

class SettingVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tbleVw: UITableView!
    
    var arrImg = [["3-0"],["1-0", "1-1", "1-2","1-3"],["2-0", "2-1"]]
    var arr = [["Theme"],["Rate Us","Share App","Help","More App"],["Privacy Policy", "Terms of Usage"]]
    var arrHeader = ["Theme","Other","Legal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    @objc func modeAction(_ sender: UISegmentedControl) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let keyWindow = windowScene.windows.first {
                switch sender.selectedSegmentIndex {
                case 0:
                    Constants.USERDEFAULTS.set(0, forKey: "isMode")
                    keyWindow.overrideUserInterfaceStyle = .unspecified
                case 1:
                    Constants.USERDEFAULTS.set(1, forKey: "isMode")
                    keyWindow.overrideUserInterfaceStyle = .light
                case 2:
                    Constants.USERDEFAULTS.set(2, forKey: "isMode")
                    keyWindow.overrideUserInterfaceStyle = .dark
                default:
                    print(sender.selectedSegmentIndex)
                }
            }
        }
    }
    
    func setupTable() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.IpadorIphone(value: 50)))
        customView.backgroundColor = .clear
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.IpadorIphone(value: 50)))
        label.text = "Version  \(appVersion!)"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        } else {
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        customView.addSubview(label)
        tbleVw.tableFooterView = customView
    }
    
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        arrImg.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbleVwCell", for: indexPath) as! tbleVwCell
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.modeBtn.isHidden = true
        if indexPath.row == 0  && indexPath.section == 0 {
            cell.modeBtn.isHidden = false
            cell.accessoryType = .none
            let selectedSegmentAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
            cell.modeBtn.setTitleTextAttributes(selectedSegmentAttributes, for: .selected)
            cell.modeBtn.selectedSegmentIndex = Constants.USERDEFAULTS.integer(forKey: "isMode")
            cell.modeBtn.addTarget(self, action: #selector(modeAction(_:)), for: .valueChanged)
            if(Device.DeviceType.IS_IPAD) {
                cell.modeBtn.setFontSize(fontSize: 25)
            }
        }
        cell.lblTitle.text = arr[indexPath.section][indexPath.row]
        cell.imgView.image = UIImage(named: arrImg[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                if let scene = view.window?.windowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            case 1: break
            case 2:
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setSubject("Feedback for Whatsapp Web iOS")
                    mail.setToRecipients(["devjogisoftech@gmail.com"])
                    mail.setMessageBody("body", isHTML: false)
                    present(mail, animated: true)
                } else {
                    showDialouge("Mail Error", "Your phone does not have Apple's Mail app installed.", view: self)
                }
            default: break
                
            }
        default:
            if indexPath.section == 0 { return }
            switch indexPath.row {
            case 0:
                if let url = URL(string: Constants.PRIVACY) {
                    let controller = SFSafariViewController(url: url)
                    controller.delegate = self
                    present(controller, animated: true, completion: nil)
                }
            default:
                if let url = URL(string: Constants.TERMS) {
                    let controller = SFSafariViewController(url: url)
                    controller.delegate = self
                    present(controller, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IpadorIphone(value: 50)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        let label = UILabel(frame: .init(x: IpadorIphone(value: 5), y: IpadorIphone(value: 15), width: IpadorIphone(value: 100), height: IpadorIphone(value: 20)))
        label.text = self.arrHeader[section]
        label.font = UIFont.systemFont(ofSize: IpadorIphone(value: 16))
        label.textColor = .init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return IpadorIphone(value: 50)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

extension SettingVC: SFSafariViewControllerDelegate{
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


class tbleVwCell1: UITableViewCell {
}

class tbleVwCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var modeBtn: UISegmentedControl!
    
}
