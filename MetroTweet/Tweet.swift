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


var tweetCache = [Tweet]()
var selectedLinesDictionary = [String: Bool]()
