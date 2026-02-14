//
//  Constants.swift
//  Bankable Solution
//
//  Created by Appster on 09/05/17.
//  Copyright © 2017 alm. All rights reserved.
//
//com.googleusercontent.apps.313192316404-ghum6vmr956psnjv486841c1ut1pbsvf gmail URL type
import Foundation
import UIKit
import Photos

class Constants {
         
    public static let NetworkUnavailable = "Network unavailable. Please check your internet connectivity"
    
    public static let USERDEFAULTS = UserDefaults.standard
    public static var ROOTVIEW = UIApplication.shared.windows.filter {$0.isKeyWindow}.last?.rootViewController

    public static let DEVICE_TYPE = "iOS"
    
    public static let PRIVACY = "https://devjogisoftechbrainquestpp.netlify.app/"
    public static let TERMS = "https://devjogisoftechbrainquesttu.netlify.app/"
            
    public static let BANNER = "ca-app-pub-3940256099942544/6300978111"
    public static let INTERTIALS = "ca-app-pub-3940256099942544/5135589807"
    public static let OPEN = "ca-app-pub-3940256099942544/3419835294"
    public static let NATIVE = "ca-app-pub-3940256099942544/2247696110"
    
    public static let storyBoard = UIStoryboard(name: "Main", bundle:Bundle.main)
    public static let sryBoard = UIStoryboard(name: "Onboard", bundle:Bundle.main)
    public static let Home = UIStoryboard(name: "Home", bundle:Bundle.main)
        
}
