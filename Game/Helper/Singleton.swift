//
//  Singleton.swift
//  Speed Dial
//
//  Created by PRAGMA on 24/08/18.
//  Copyright © 2018 PRAGMA. All rights reserved.
//

import UIKit
import Contacts

class Singleton: NSObject
{
    
    // Declare our 'sharedInstance' property
    static let sharedInstance = Singleton()
    var selectedGameIndex = ""
    private override init() {}
    var arrAnswers : NSMutableArray = ["1","0","0","0","1",
                                              "0","0","0","1","1",
                                              "0","0","0","0","0",
                                              "0","0","1"," 1","0",
                                              "1","0","1","0","1",
                                              "0", "1","0","0","0","0",

                                              "1","0","1","0","1",
                                              "1","0","0","1","1", "1",
                                              "0","1","0","1","0",
                                              "1","1","0","0","1",
                                              "0","1","1","1","1",
                                              "1","0","0","1","0",
                                              "1","1"," 0","0","0"
    ]
    var arrEquetions : NSMutableArray = ["1 + 1 = 2","1 - 1 = 1","2 - 1 = - 1","1 - 2 = 1","1 * 1 = 1",
                                              "1 * -1 = 1","1 / 0 = 0","0 / 1 = ∞","1 / 0 = ∞","0 / 1 = 0",
                                              "∞ * 0  = ∞","∞ - ∞ = ∞","∞ - ∞ = 0","0 * 1 = 1","2 - 4 = 2",
                                              "1 + (- 1) = 2","1 * 2 = 1","1 * 2 = 2"," 0 * 1 = 0"," 8 - 9 = 1",
                                              "8 - 9 = - 1","-1 + 1 = 2","-1 + 1 = 0","log1 = 1","log1 = 0",
                                              "0! = 0", "0! = 1", "352 - 231 = 131","2 + 2 = 2","2 * 2 = 2","2 - (-2) = -4",
                                              "2^2 = 4","1.0 + 0.1 = 1.01","1.0 + 0.1 = 1.1","2.3 - 3.2 = -1.1","2.3 - 3.2 = -0.9",
                                              "2 / 1 = 2","1 * 3 = 31","1 + 1 = 11","3.5 + 5.3 = 8.8","2 * (-3) = -6", "378 + 492 = 870",
                                              "378 + 492 = 860","32 - 43 = -11","7 * 6 = 24","6 * 8 = 48","1^0 = 0",
                                              "1^0 = 1","1 <= 1","1 <= -1","1 < -1","1 < 2",
                                              "sin(c) = 1 / cos(c)","sin(0) = 0","sin(90) = 1","cos(0) = 1","cos(90) = 0",
                                              "sin(45) = cos(45)","cos(c) / sin(c) = tan(c)","1 / sin(c) = cot(c)","1 / sin(c) = cosec(c)","2 - 3 = 1",
                                              "2 - 6 = -4","1 + 0 = 1"," 0 * 9 = 9","1.5 - 5.1 = -4.4","4.4 - 0.05 = 3.9"
                                              ]
    var arrSpellings : NSMutableArray = ["Wednesday","Luck","River","Rain","Hello","Hi","Recovery","Delete","House","Office","Restaurant","Sunrise","Airplane","Bus","Car","Person","People","Ready","Happy","Dinner","Drinks","Monday","Night","Sleep","Download","Common","Out","In","Under","Temple","Search","Church","Button","Switch","Table","Collection","Tuesday","Word","Hard","Soft","Easy","Mango","Meat","Tea","Gold","Mac","Book","Bad","Bed","Bat","Rate","Cat","Brother","Mother","Father","Friday","Sister","Dad","Mom","Chair","Phone","Mouse","Watch","Apple","Banana","Memory","Dial","Date","Dear","Deer","Peer","Rear","Year","Ear","Flim","Doctor","Engineer","Clock","Glass","Desk","Key","Wrong","Cup","Sun","Right","Pass","Pin"]

    var Arr_Birds : NSMutableArray = ["B1","B2","B3","B4","B5","B6","B7","B8","B9"]
    var Arr_Animal : NSMutableArray = ["A1","A2","A3","A4","A5","A6","A7","A8","A9"]
    var Arr_Fruits : NSMutableArray = ["F1","F2","F3","F4","F5","F6","F7","F8","F9"]
    var Arr_Vegitables : NSMutableArray = ["V1","V2","V3","V4","V5","V6","V7","V8","V9"]
    var Arr_Alphabets : NSMutableArray = ["AL1","AL2","AL3","AL4","AL5","AL6","AL7","AL8","AL9"]
    var Arr_Number : NSMutableArray = ["N1","N2","N3","N4","N5","N6","N7","N8","N9"]
    var Arr_Sweet : NSMutableArray = ["S1","S2","S3","S4","S5","S6","S7","S8","S9"]
    var Arr_Spicy : NSMutableArray = ["SP1","SP2","SP3","SP4","SP5","SP6","SP7","SP8","SP9"]
    var Arr_Sea_Animal : NSMutableArray = ["SA1","SA2","SA3","SA4","SA5","SA6","SA7","SA8","SA9"]
    var Arr_Normal_Animal : NSMutableArray = ["NA1","NA2","NA3","NA4","NA5","NA6","NA7","NA8","NA9"]

    var arrCards : NSMutableArray = ["NA1","NA2","NA3","NA4","NA6","NA7","NA8","NA9","SA1","SA2","SA3","SA4","SA6","SA7","SA8","SP1","SP2","SP3","SP4","SP5","SP6","SP7","SP8","SP9","S1","S2","S3","S4","S5","S6","S7","S8","V3","V4","V6","V7","V8","V9","F1","F2","F3","F4","F6","F7","F8","A1","A2","A3","A4","A5","A6","A7","A8","A9","B3","B4","B5","B7","B8","B9"]

    var arrGameInstructions1 : NSMutableArray = ["1. There will be 2 Players.\n2. Whoever select right answer,\n    score will increase by 1.\n3. Wrong answer deduct your score\n    by 1.\n4. Whomever score reaches 10,\n    player will win the game."
        ,"1. There will be one math equation.\n2. If equation is right, press 'TRUE'.\n3. If equation is wrong, press 'FALSE'.",
         "1. There will be one math equation.\n2. There will be four operators\n    as options.\n3. A Player has to choose operator\n    which satisfy that equation.",
         "1. There will be one Spelling.\n2. A Player has tap on number as per\n    occurrence of Spelling.\n3. Ex. If 'Chair' comes for the\n    first time, tap on '0'.",
         "1. There will be one Spelling.\n2. If spelling comes for the first time,\n    press 'No'.\n3. If spelling occurrence is more than\n    one, press 'Yes'.",
         "1. There will be one number.\n2. A Player has tap on number which\n    has been 'Displayed' from given\n    options.",
         "1. There will be one number.\n2. There will be four options.\n3. A Player has to choose right\n    option which satisfy that question",
         "1. There will be 9 cards.\n2. A Player has to choose odd\n    man out from 9 cards.\n3. Ex. If there will be 8 cards of\n    number and one card of alphabet,\n    select one card of alphabet.",
         "1. There will be one math equation.\n2. If equation is right, press 'FALSE'.\n3. If equation is wrong, press 'TRUE'.",
         "1. There will be 9 cards, each card\n    has one label which is given below\n    to card.\n2. A Player has to pick right card\n    which matches the label.",
         "1. There will be 9 cards, each card\n    contains one color name which is \n    given below to card.\n2. A Player has to pick right card\n    which matches the color name\n    & color tile.",
         "1. There will be 9 cards, each card\n    contains one color name which is \n    given below to card.\n2. A Player has to pick card which\n    does not match the color name\n    & color tile.",
         "1. There will be 9 color tiles.\n2. A Player has to tap on any color\n    tile which has more number of\n    color tiles.",
         "1. There will be 3 color tiles.\n2. There will be one color label\n    shown below to color tiles.\n3. A Player has to pick right color tile\n    which matches the color label."]
    var ArrGameInstruction2 : NSMutableArray = [["There will be 2 Players.","The Player who select the right answer, score will increase by 1 and wrong answer will reduce the score by 1.","Player will win the game, whose score reaches 10 first."],
                                                ["There will be one math equation.","If equation is right press 'TRUE' otherwise 'FALSE'."],
                                                ["There will be one math equation.","Select the right operator from given options."]]
    var arrGameInstructions : NSMutableArray = [[["InstructionNumber" : "1. ","Instruction":"There will be 2 Players."],["InstructionNumber" : "2. ","Instruction":"The Player who select the right answer, score will increase by 1 and wrong answer will reduce the score by 1."],["InstructionNumber" : "3. ","Instruction":"Player will win the game, whose score reaches 10 first."]],
                                                [["InstructionNumber" : "1. ","Instruction":"There will be one math equation."],["InstructionNumber" : "2. ","Instruction":"If equation is right press 'TRUE' otherwise 'FALSE'."]],
                                                [["InstructionNumber" : "1. ","Instruction":"There will be one math equation."],["InstructionNumber" : "2. ","Instruction":"Select the right operator from given options."]],
                                                [["InstructionNumber" : "","Instruction" : ""],["InstructionNumber" : "1. ","Instruction" : "There will be one Spelling."],["InstructionNumber" : "2. ","Instruction":"A Player has tap on number as per occurrence of word."],["InstructionNumber" : "3. ","Instruction":"Ex. If 'Chair' comes for the first time, tap on '0'."]],
                                                [["InstructionNumber" : "","Instruction" : ""],["InstructionNumber" : "1. ","Instruction":"There will be one Spelling."],["InstructionNumber" : "2. ","Instruction":"If spelling comes for the first time, press 'No'"],["InstructionNumber" : "3. ","Instruction":"If spelling occurrence is more than one, press 'Yes'"]],
                                                [["InstructionNumber" : "1. ","Instruction":"There will be one number."],["InstructionNumber" : "2. ","Instruction":"Find the Displayed number from the options."]],
                                                [["InstructionNumber" : "1. ","Instruction":"There will be one question."],["InstructionNumber" : "2. ","Instruction":"Select an option which satisfy the question."]],
                                                [["InstructionNumber" : "1. ","Instruction":"A Player has to choose odd man out from 9 cards."],["InstructionNumber" : "2. ","Instruction":"Ex. If there will be 8 cards of number and one card of alphabet, select one card of alphabet."]],
                                                [["InstructionNumber" : "","Instruction" : ""],["InstructionNumber" : "1. ","Instruction":"There will be one math equation."],["InstructionNumber" : "2. ","Instruction":"If equation is right, press 'FALSE'."],["InstructionNumber" : "3. ","Instruction":"If equation is wrong, press 'TRUE'."]],
                                                [["InstructionNumber" : "1. ","Instruction":"There will be 9 cards."],["InstructionNumber" : "2. ","Instruction":"Pick the right card with matching label."]],
                                                [["InstructionNumber" : "1. ","Instruction":"There will be 9 cards with color name."],["InstructionNumber" : "2. ","Instruction":"Pick the card, which match the color name & color tile."]],
                                                [["InstructionNumber" : "1. ","Instruction":"There will be 9 cards with color name."],["InstructionNumber" : "2. ","Instruction":"Pick the card, which don't match the color name & color tile."]],
                                                [["InstructionNumber" : "1. ","Instruction":"There will be 9 color tiles."],["InstructionNumber" : "2. ","Instruction":"A player has to pick any color tile with greater number of same color tile."]],
                                                [["InstructionNumber" : "1. ","Instruction":"There will be 3 color tiles."],["InstructionNumber" : "2. ","Instruction":"A player has to pick color tile which is displayed on label."]]]
    // MARK: - Check Reachability
//    func NetworkRechability() -> Bool {
//        let reachability = Reachability()!
//        if reachability.isReachable {
//            if reachability.isReachableViaWiFi || reachability.isReachableViaWWAN {
//                return true
//            } else {
//                return false
//            }
//        } else {
//            return false
//        }
//    }
    func IsDisplayAd() -> Bool {
        let data = UserDefaults.standard
        var count = data.integer(forKey: "GoogleAdCounter")
        print(count)
        if(count<4) {
            count = count + 1
            data.set(count, forKey: "GoogleAdCounter")
            data.synchronize()
            return false
        } else {
            data.set(0, forKey: "GoogleAdCounter")
            data.synchronize()
            return true;
        }
    }
    func IncreaseGoogleAdCounter() {
        let data = UserDefaults.standard
        var count = data.integer(forKey: "GoogleAdCounter")
        count += 1;
        data.set(count, forKey: "GoogleAdCounter")
        data.synchronize()
    }
}

