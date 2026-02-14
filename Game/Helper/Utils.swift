//
//  Utils.swift
//  SwiftDemo
//
//  Created by Redspark on 19/12/17.
//  Copyright © 2017 Redspark. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import EventKit
import StoreKit
import QuickLook
//import Firebase
import MobileCoreServices
import ProgressHUD
import AVFoundation


class Utils: NSObject {
        
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController!.present(alert, animated: true, completion: nil)
        
    }
    
    func showDialouge(_ title: String,_ message: String, view: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
        view.present(alert, animated: true, completion: nil)
    }
    
    func showAlertControllerWith(title:String, message:String?, onVc:UIViewController , style: UIAlertController.Style = .alert, buttons:[String], completion:((Bool,Int)->Void)?) -> Void {
         let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
         for (index,title) in buttons.enumerated() {
             let action = UIAlertAction.init(title: title, style: UIAlertAction.Style.default) { (action) in
                 completion?(true,index)
             }
             alertController.addAction(action)
         }
         onVc.present(alertController, animated: true, completion: nil)
     }
    
    func showLoader(text: String) {
        ProgressHUD.animationType = .circleDotSpinFade
        ProgressHUD.colorAnimation = UIColor.systemYellow
        ProgressHUD.colorHUD = UIColor.secondarySystemGroupedBackground
        ProgressHUD.fontStatus = UIFont(name: "AvenirNext-DemiBold", size: 24)!
        ProgressHUD.animate(text, interaction: false)
    }

    func hideLoader() {
        ProgressHUD.dismiss()
    }
    
    func isFlashlightAvailable() -> Bool {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return false
        }
        return device.hasTorch
    }
        
//    func logEvent(event: String, param: [String:Any]?) {
//        Analytics.logEvent(event, parameters: param)
//    }
    
    func documentsUrl() -> URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl
    }
    
    func saveFile(data: Data?, fileName: String) -> String? {
        let fileURL = documentsUrl().appendingPathComponent(fileName)
        if let imageData = data {
            try? imageData.write(to: fileURL, options: .atomicWrite)
            return fileName
        }
        return nil
    }
    
    func getImageFromDocumentDirectory(fileName: String) -> UIImage? {
        let fileURL = documentsUrl().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func deleteFileFromDirectory(arraydeleteURL: String) {
        let imageURL = documentsUrl().appendingPathComponent(arraydeleteURL)
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print("Error deleting image: \(error.localizedDescription)")
        }
    }

}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                if #available(iOS 14.0, *) {
                    requestReview(in: scene)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
}
