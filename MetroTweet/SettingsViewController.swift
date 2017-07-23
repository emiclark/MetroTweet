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
    
    @IBOutlet var subwayLineButtons: [UIButton]!
    
    private let tagDictionary = [
        1: "1",
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
        23: "W"
    ]

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        var lineString: String = ""
        
        let tweetTVC = TweetTableViewController()
        
        for (key, value) in selectedLinesDictionary {
            if value {
                lineString += key
            }
        }
        
        let title = lineString.characters.count > 1 ? String(Array(lineString.characters).sorted()) : lineString
        
        if title.characters.count > 0 {
            tweetTVC.vcTitle = "Tweets for \(title)"
        } else {
            tweetTVC.vcTitle = "No Tweets"
        }
        
        tweetTVC.navigationController?.navigationItem.title = "test"
        self.navigationController?.pushViewController(tweetTVC, animated: true)
    }
 
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        
        // Translate the button tag to a subway line
        let subwayLine = tagDictionary[sender.tag]!
        
        // If the button is currently selected then ...
        if selectedLinesDictionary[subwayLine]! {
            // unselect it
            selectedLinesDictionary[subwayLine] = false
            disableBorder(on: sender)
        // Otherwise, ...
        } else {
            // set the button to selected
            selectedLinesDictionary[subwayLine] = true
            enableBorder(on: sender)
        }
        
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

