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
    
    var lineString = String()
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let tweetTVC = TweetTableViewController()
        UserDefaults.standard.setValue(selectedLinesDictionary, forKeyPath: "selectedLinesDictionary")
//        tweetTVC.vcTitle = "Tweets for lines " + lineString
        tweetTVC.navigationController?.title = "Tweets for lines " + lineString
        self.navigationController?.pushViewController(tweetTVC, animated: true)
    }
 
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        
        selectedLinesDictionary[sender.description] = true
        // set border to show seleccted
        sender.layer.cornerRadius =  sender.frame.size.width/2
        sender.layer.borderWidth = 3
        sender.layer.masksToBounds = true
        
        //
//        if(sender.isHighlighted) {
//            sender.layer.borderColor = UIColor.green as! CGColor
//        } else {
//            sender.layer.borderWidth = 0
//        }
        lineString.append(tagDictionary[sender.tag]!)
        print("lineString:", lineString)

    
        
        
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

