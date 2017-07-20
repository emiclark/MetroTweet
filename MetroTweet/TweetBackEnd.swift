//
//  TweetBackEnd.swift
//  MetroTweet
//
//  Created by Emiko Clark on 7/20/17.
//  Copyright © 2017 Avery Barrantes. All rights reserved.
//

import UIKit

class TweetBackEnd: NSObject {
    
    var tweetArray = [Tweet]()
    var metroImage: UIImage?
    var metroImageDict: Dictionary<String, String>?
    
    override init() {
        super.init()
        createTweetArray()
        createMetroImageDict()
    }
    
    func createTweetArray() {
        // this is test data to populate tableview cells
        for i in 0...10 {
            var tweetString = "\(i). Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            
            // get time
            let date = Date()
            let calendar = Calendar.current
            
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            let createdAt = ("\(hour):\(minutes):\(seconds)")
            print(createdAt)
            
            let id = "7"
            
            let tweet = Tweet(id: id, createdAt: createdAt, tweetString: tweetString)
            
            tweetArray.append(tweet)
        }
    }
    
    func createMetroImageDict() {
        
//        metroImageDict["1"] = "1.png"
        
        
//        metroImageDict["1"] = "1.png"
//        metroImageDict["2"] = "2.png"
//        metroImageDict["3"] = "3.png"
//        metroImageDict["4"] = "4.png"
//        metroImageDict["5"] = "5.png"
//        metroImageDict["6"] = "6.png"
//        metroImageDict["7"] = "7.png"
//        metroImageDict["A"] = "A.png"
//        metroImageDict["B"] = "B.png"
//        metroImageDict["C"] = "C.png"
//        metroImageDict["D"] = "D.png"
//        metroImageDict["E"] = "E.png"
//        metroImageDict["F"] = "F.png"
//        metroImageDict["G"] = "G.png"
//        metroImageDict["J"] = "J.png"
//        metroImageDict["L"] = "L.png"
//        metroImageDict["M"] = "M.png"
//        metroImageDict["N"] = "N.png"
//        metroImageDict["Q"] = "Q.png"
//        metroImageDict["R"] = "R.png"
//        metroImageDict["S"] = "S.png"
//        metroImageDict["W"] = "W.png"
//        metroImageDict["Z"] = "Z.png"
//        metroImageDict["SIR"] = "SIR.png"

        
        
        
    }
    
 
    
}
