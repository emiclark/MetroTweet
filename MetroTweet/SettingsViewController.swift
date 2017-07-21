//
//  SettingsViewController.swift
//  MetroTweet
//
//  Created by Emiko Clark on 7/20/17.
//  Copyright © 2017 Emiko Clark. All rights reserved.
//

import UIKit
import WebKit

class SettingsViewController: UIViewController {
    
    // FIXME: set nav title to lines
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        let tweetTVC = TweetTableViewController()
//        tweetTVC.vcTitle = "Tweets for " + "E, F, M"
        tweetTVC.title = "Tweets for " + "E, F, M"

//        self.navigationController?.pushViewController(tweetTVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

