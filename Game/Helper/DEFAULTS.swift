//
//  DEFAULTS.swift
//  Speed Dial
//
//  Created by PRAGMA on 24/08/18.
//  Copyright © 2018 PRAGMA. All rights reserved.
//

import UIKit


class DEFAULTS: NSObject {
    class func isDarkMode() -> Bool {
        return DEFAULTS.getAppColor() == "white" ? false : true
    }
    class func getAppColor() -> String {
        return (UserDefaults.standard.string(forKey: "appColor") == nil || UserDefaults.standard.string(forKey: "appColor") !=
                    "black") ? "white" : "black"
    }
    class func setAppColor(appColor : String) {
        UserDefaults.standard.set(appColor, forKey: "appColor")
        UserDefaults.standard.synchronize()
    }
    class func Get_Best_Score_Of_Math_Equestion(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "Math_Equestion_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "Math_Equestion_\(mode)")! : "0"
    }
    class func Set_Best_Score_Of_Math_Equestion(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_Math_Equestion(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "Math_Equestion_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_Wrong_Answer(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "Wrong_Answer_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "Wrong_Answer_\(mode)")! : "0"
    }
    class func Set_Best_Score_Of_Wrong_Answer(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_Wrong_Answer(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "Wrong_Answer_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }

    class func Get_Best_Score_Of_Find_Operator(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "Find_Operator_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "Find_Operator_\(mode)")! : "0"
    }
    class func Set_Best_Score_Of_Find_Operator(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_Find_Operator(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "Find_Operator_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_SpellingOccurrence(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "SpellingOccurrence_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "SpellingOccurrence_\(mode)")! : "0"
    }
    class func Set_Best_Score_Of_SpellingOccurrence(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_SpellingOccurrence(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "SpellingOccurrence_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_RememberSpelling(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "RememberSpelling_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "RememberSpelling_\(mode)")! : "0"
    }
    class func Set_Best_Score_Of_RememberSpelling(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_RememberSpelling(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "RememberSpelling_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_Taponthnumber(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "Taponthnumber_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "Taponthnumber_\(mode)")! : "0"

    }
    class func Set_Best_Score_Of_Taponthnumber(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_Taponthnumber(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "Taponthnumber_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_GuessWeekDay(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "GuessWeekDay_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "GuessWeekDay_\(mode)")! : "0"

    }
    class func Set_Best_Score_Of_GuessWeekDay(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_GuessWeekDay(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "GuessWeekDay_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_OddManOut(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "OddManOut_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "OddManOut_\(mode)")! : "0"

    }
    class func Set_Best_Score_Of_OddManOut(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_OddManOut(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "OddManOut_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_FindTheCard(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "FindTheCard_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "FindTheCard_\(mode)")! : "0"

    }
    class func Set_Best_Score_Of_FindTheCard(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_FindTheCard(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "FindTheCard_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_MatchTheCard(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "MatchTheCard_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "MatchTheCard_\(mode)")! : "0"

    }
    class func Set_Best_Score_Of_MatchTheCard(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_MatchTheCard(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "MatchTheCard_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_ChoseRightColor(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "ChoseRightColor_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "ChoseRightColor_\(mode)")! : "0"
    }
    class func Set_Best_Score_Of_ChoseRightColor(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_ChoseRightColor(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "ChoseRightColor_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_ChoseWrongColor(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "ChoseWrongColor_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "ChoseWrongColor_\(mode)")! : "0"
    }
    class func Set_Best_Score_Of_ChoseWrongColor(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_ChoseWrongColor(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "ChoseWrongColor_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }

    class func Get_Best_Score_Of_ColorIntensity(mode : String) -> String {
        return (UserDefaults.standard.string(forKey: "ColorIntensity_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "ColorIntensity_\(mode)")! : "0"
    }
    class func Set_Best_Score_Of_ColorIntensity(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_ColorIntensity(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "ColorIntensity_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }
    class func Get_Best_Score_Of_RandomColor(mode: String) -> String {
        return (UserDefaults.standard.string(forKey: "RandomColor_\(mode)") != nil) ? UserDefaults.standard.string(forKey: "RandomColor_\(mode)")! : "0"
    }
    class func Set_Best_Score_Of_RandomColor(Score: String, mode : String) {
        if Int(DEFAULTS.Get_Best_Score_Of_RandomColor(mode: mode))! < Int(Score)! {
             UserDefaults.standard.set(Score, forKey: "RandomColor_\(mode)")
             UserDefaults.standard.synchronize()
         }
    }


    class func IsShowInstructionPopup(gameName: String) -> Bool {
        let ArrGames : NSMutableArray = NSMutableArray(array: UserDefaults.standard.value(forKey: "donotshow") == nil ? NSArray() : UserDefaults.standard.value(forKey: "donotshow") as! NSArray)
        if ArrGames.contains(gameName) {
            return false
        }
        return true
    }
    class func SetShowInstructionPopupFlag(gameName : String) {
        let ArrGames : NSMutableArray = NSMutableArray(array: UserDefaults.standard.value(forKey: "donotshow") == nil ? NSArray() : UserDefaults.standard.value(forKey: "donotshow") as! NSArray)
        ArrGames.add(gameName)
        UserDefaults.standard.set(NSArray(array: ArrGames), forKey: "donotshow")
        UserDefaults.standard.synchronize()
    }
}
