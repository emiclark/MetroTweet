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
    var routeUrl: URL

    init(id: String, createdAt: String, tweetString: String, routeUrl: URL) {
        self.id = id
        self.createdAt = createdAt
        self.tweetString = tweetString
        self.routeUrl = routeUrl
    }

}

var selectedLinesDictionary = [String:Bool]()
