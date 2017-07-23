//
//  SettingsViewController.swift
//  MetroTweet
//
//  Created by Emiko Clark on 7/20/17.
//  Copyright © 2017 Emiko Clark. All rights reserved.
//

import UIKit
import WebKit


// Global variable
var selectedLinesDictionary = [String : Bool]()


class SettingsViewController: UIViewController {
    
    var lineString = String()
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        var lineString: String = ""
        
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

    
        
        
        // Save the setting to UserDefaults
        let data = NSKeyedArchiver.archivedData(withRootObject: selectedLinesDictionary)
        UserDefaults.standard.setValue(data, forKeyPath: "selectedLinesDictionary")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // If selectedLinesDictionary has been saved to UserDefaults previously on this device then ...
        if let archivedData = UserDefaults.standard.value(forKey: "selectedLinesDictionary") as? Data,
            let unarchivedDictionary = NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? [String:Bool] {

            // Read it in
            selectedLinesDictionary = unarchivedDictionary

            // Loop through all on the buttons
            for button in subwayLineButtons {
                // Translate the button tag to a subway line
                let subwayLine = tagDictionary[button.tag]
                
                // If the subway line has been selected by the user then ...
                if selectedLinesDictionary[subwayLine!]! {
                    // display a border around the current button
                    enableBorder(on: button)
                }
            }
            
            return
        }
        
        selectedLinesDictionary = [
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func enableBorder(on button: UIButton) {
        button.layer.cornerRadius =  button.frame.width / 2
        button.layer.borderWidth = 3
        button.layer.masksToBounds = true
    }
    
    private func disableBorder(on button: UIButton) {
        button.layer.cornerRadius =  0
        button.layer.borderWidth = 0
        button.layer.masksToBounds = false
    }
}

