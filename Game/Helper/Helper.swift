//
//  Helper.swift
//  Game
//
//  Created by Hiren R. Chauhan on 06/04/25.
//

import Foundation
import UIKit
import GoogleMobileAds


extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        // ✅ Adjust font & constraints for iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Scale font
            self.font = self.font.withSize((self.font.pointSize / 2) * 3)
            
            // Scale constraints
//            for constraint in self.constraints {
//                constraint.constant = (constraint.constant / 2) * 3
//            }
        }
    }
}

extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let titleLabel = self.titleLabel else { return }
        
        // ✅ Adjust font & constraints for iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Scale font
            titleLabel.font = titleLabel.font.withSize((titleLabel.font.pointSize / 2) * 3)
            
            // Scale constraints
//            for constraint in self.constraints {
//                constraint.constant = (constraint.constant / 2) * 3
//            }
        }
    }
}

extension UIViewController {
    
    func showDialouge(_ title: String,_ message: String, view: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
        view.present(alert, animated: true, completion: nil)
    }
    
    func setupBanner(GADAdSize: AdSize , Banner: BannerView) {
        if Utils().isConnectedToNetwork() && Constants.USERDEFAULTS.value(forKey: "isShowAds") == nil {
            Banner.adUnitID = Constants.USERDEFAULTS.string(forKey: "BANNER")
            Banner.adSize = GADAdSize
            Banner.rootViewController = self
            Banner.load(Request())
        }
    }

    
    func IpadorIphone(value:Double) -> Double {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return ((value / 2) * 3)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            return value
        } else {
            return value
        }
    }
    
    class func setcornerRadius(view : UIView, cornerradius : CGFloat) {
        view.layer.cornerRadius = cornerradius
        view.layer.masksToBounds = true
    }
    
    class func DropShadow(views : [UIView]) {
        for view in views {
            view.dropShadow(color: UIColor(red: 223/255, green: 228/255, blue: 238/255, alpha: 1.0), opacity: 0.5, offSet: CGSize(width: 2, height: 5), radius: 5, scale: true)
        }
    }
    
    class func btnDropShadow(views : [UIView]) {
        for view in views {
            view.applyShadow()
        }
    }
}

extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
        func applyShadow(
            color: UIColor = UIColor(red: 223/255, green: 228/255, blue: 238/255, alpha: 1.0),
            opacity: Float = 0.3,
            offset: CGSize = CGSize(width: 0, height: 2),
            radius: CGFloat = 4
        ) {
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = offset
            self.layer.shadowRadius = radius
            self.layer.masksToBounds = false
        }
}

extension UISegmentedControl {
    func setFontSize(fontSize: CGFloat) {
        guard let avenirFont = UIFont(name: "AvenirNext-Medium", size: fontSize) else {
            print("⚠️ Font 'AvenirNext-DemiBold' not found.")
            return
        }

        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: avenirFont
        ]

        let boldTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: avenirFont
        ]

        self.setTitleTextAttributes(normalTextAttributes, for: .normal)
        self.setTitleTextAttributes(normalTextAttributes, for: .highlighted)
        self.setTitleTextAttributes(boldTextAttributes, for: .selected)
    }
}

extension UIColor {
    convenience init(hex: UInt32) {
        let mask = 0x000000FF
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex) & mask
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        self.init(red:red, green:green, blue:blue, alpha:1)
    }

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension Array {
    
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }

    @discardableResult
    mutating func shuffle() -> Array {
        let count = self.count
        indices.lazy.dropLast().forEach {
            swapAt($0, Int(arc4random_uniform(UInt32(count - $0))) + $0)
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}
