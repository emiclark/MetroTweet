//
//  TestViewController.swift
//  MetroTweet
//
//  Created by Emiko Clark on 7/23/17.
//  Copyright © 2017 Avery Barrantes. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    @IBAction func testButtonTapped(_ sender: UIBarButtonItem) {
        let tweetVC = TweetTableViewController()
        tweetVC.vcTitle = "take it away Sam!"
        self.navigationController?.pushViewController(tweetVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
