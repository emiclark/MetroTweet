//
//  Tweet.swift
//  MetroTweet
//
//  Created by Emiko Clark on 7/20/17.
//  Copyright © 2017 Avery Barrantes. All rights reserved.
//


import UIKit


class Tweet: NSObject {
    
    let createdAt: String
    let tweetString: String
    let id: String
    
    init(id: String, createdAt: String, tweetString: String) {
        self.id = id
        self.createdAt = createdAt
        self.tweetString = tweetString
    }
}


var selectedLinesDictionary = [
            "1": false,
            "2": false,
            "3": false,
            "4": false,
            "5": false,
            "6": false,
            "A": false,
            "C": false,
            "E": false,
            "N": false,
            "Q": false,
            "R": false,
            "B": false,
            "D": false,
            "F": false,
            "M": false,
            "J": false,
            "Z": false,
            "7": false,
            "G": false,
            "L": false,
            "S": false,
            "W": false  ]

                              

var tagDictionary = [  1: "1",
                       2: "2",
                       3: "3",
                       4: "4",
                       5: "5",
                       6: "6",
                       7: "A",
                       8: "C",
                       9: "E",
                       10: "N",
                       11: "Q",
                       12: "R",
                       13: "B",
                       14: "D",
                       15: "F",
                       16: "M",
                       17: "J",
                       18: "Z",
                       19: "7",
                       20: "G",
                       21: "L",
                       22: "S",
                       23: "W",]


var lineString = String()

