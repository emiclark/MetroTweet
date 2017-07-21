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
    var idArray = ["A","B","C"]
    
    // Dictionary containing names of metro number images
    var metroImageDict = [
            "1" : "1.png",
            "2" : "2.png",
            "3" : "3.png",
            "4" : "4.png",
            "5" : "5.png",
            "6" : "6.png",
            "7" : "7.png",
            "A" : "A.png",
            "B" : "B.png",
            "C" : "C.png",
            "D" : "D.png",
            "E" : "E.png",
            "F" : "F.png",
            "G" : "G.png",
            "J" : "J.png",
            "L" : "L.png",
            "M" : "M.png",
            "N" : "N.png",
            "Q" : "Q.png",
            "R" : "R.png",
            "S" : "S.png",
            "W" : "W.png",
            "Z" : "Z.png" ]
    
    // Dictionary containing urls to line routes
    var lineDict = ["1" : "http://web.mta.info/nyct/service/oneline.htm",
                    "2" : "http://web.mta.info/nyct/service/twoline.htm",
                    "3" : "http://web.mta.info/nyct/service/threelin.htm",
                    "4" : "http://web.mta.info/nyct/service/fourline.htm",
                    "5" : "http://web.mta.info/nyct/service/fiveline.htm",
                    "6" : "http://web.mta.info/nyct/service/sixline.htm",
                    "6Exp" : "http://web.mta.info/nyct/service/6d.htm",
                    "7" : "http://web.mta.info/nyct/service/sevenlin.htm",
                    "7Exp" : "http://web.mta.info/nyct/service/7d.htm",
                    "A" : "http://web.mta.info/nyct/service/aline.htm",
                    "B" : "http://web.mta.info/nyct/service/bline.htm",
                    "C" : "http://web.mta.info/nyct/service/cline.htm",
                    "D" : "http://web.mta.info/nyct/service/dline.htm",
                    "E" : "http://web.mta.info/nyct/service/eline.htm",
                    "F" : "http://web.mta.info/nyct/service/fline.htm",
                    "G" : "http://web.mta.info/nyct/service/gline.htm",
                    "J" : "http://web.mta.info/nyct/service/jline.htm",
                    "L" : "http://web.mta.info/nyct/service/lline.htm",
                    "M" : "http://web.mta.info/nyct/service/mline.htm",
                    "N" : "http://web.mta.info/nyct/service/nline.htm",
                    "Q" : "http://web.mta.info/nyct/service/qline.htm",
                    "R" : "http://web.mta.info/nyct/service/rline.htm",
                    "Shuttle" : "http://web.mta.info/nyct/service/sline.htm",
                    "W" : "http://web.mta.info/nyct/service/wline.htm",
                    "Z" : "http://web.mta.info/nyct/service/zline.htm"]
    

    override init() {
        super.init()
        createTweetArray()
    }
    
    func createTweetArray() {
        // this is test data to populate tableview cells
        for i in 0...10 {
            let tweetString = "\(i). Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            
            // get time
            let date = Date()
            let id = "7"
            let createdAt = "\(date)"
            let tweet = Tweet(id: id, createdAt: createdAt, tweetString: tweetString)
            
            tweetArray.append(tweet)
        }
    }
    
    func createIDArray() {
        // contains array of metro line number(s) that appear in a single tweet
        var idNum = "1"
        
        // parse tweet for metro line number(s) and add to idArray
        idArray.append(idNum)
        idArray.append("A")
        idArray.append("C")
    
    }
    
    

 
    
}
