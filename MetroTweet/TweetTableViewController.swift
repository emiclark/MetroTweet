
//  TweetTableViewController.swift
//  MetroTweet
//
//  Created by Emiko Clark on 7/20/17.
//  Copyright © 2017 Avery Barrantes. All rights reserved.
//

import UIKit


fileprivate var tweetCache = [Tweet]()
fileprivate var tweetDisplayIndexes = [Int]()

class TweetTableViewController: UITableViewController, BackEndDelegate {
    
    
    @IBOutlet var tweetTableView: UITableView!
    
    let updatedLabel: UILabel = {
        let ul = UILabel(frame: CGRect(x: 87.5 , y: 55, width: 375, height: 15))
        ul.text = "Click on the Update button to get tweets"
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.textAlignment = .center
        ul.numberOfLines = 0
        ul.textColor = UIColor.darkGray
        ul.font=UIFont.systemFont(ofSize: 12)
        return ul
    }()

    private let backend = BackEnd.sharedInstance
    var vcTitle = String()
    var labelTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = vcTitle
        updatedLabel.text = labelTitle
        
        // register custom cell class
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")

        backend.delegate = self
        backend.getAccessToken()

    }
    

    
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Delegate method called when we successfully received an access token from Twitter.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    func didGetAccessToken() {
        // enable update button
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Delegate method called when we successfully received tweets from Twitter.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    func didGetSubwayTweets(_ tweets: [Tweet]) {
        if tweets.count > 0 {
            if tweetCache.count > 0 {
                tweetCache.insert(contentsOf: tweets, at: 0)
            } else {
                tweetCache.append(contentsOf: tweets)
            }
        }
        
        // purge cache of old tweets
        
        // Refresh the tweetDisplayIndexArray
        tweetDisplayIndexes.removeAll()
        for (index, tweet) in tweetCache.enumerated() {
            if selectedLinesDictionary[tweet.id]!  {
                tweetDisplayIndexes.append(index)
            }
        }
        
        // update table view
        tableView.reloadData()

    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Delegate method called when we failed to received an access token from Twitter.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    func failedToGetAccessToken(_ errorMsg: String) {
        showErrorAlert(for: errorMsg)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Delegate method called when we failed to received tweets from Twitter.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    func failedToGetSubwayTweets(_ errorMsg: String) {
        showErrorAlert(for: errorMsg)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method for displaying an "error dialog box".
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    private func showErrorAlert(for errorMsg: String) {
        let alert = UIAlertController(title: "Error",
                                      message: errorMsg,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view Header
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(100)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let mybuttonColor = UIColor(
            red:0.3,
            green:0.6,
            blue:0.9,
            alpha:1.0)
        
        let myheaderBgColor = UIColor(
            red:0.92,
            green:0.92,
            blue:0.92,
            alpha:1.0)
        
        // create button
        let xcoord = (self.view.frame.size.width - 200)/2;
        let updateButton = UIButton(frame: CGRect(x: xcoord , y: 15, width: 200, height: 30))
        updateButton.addTarget(self, action: #selector(updateTweet), for: .touchUpInside)
        updateButton.setTitle("Update Tweets", for: .normal)
        updateButton.backgroundColor = mybuttonColor
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.setTitleColor(.white, for: .normal)

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 100))
        headerView.backgroundColor = myheaderBgColor
        headerView.addSubview(updateButton)   // add the button to the view
        headerView.addSubview(updatedLabel)
        updatedLabel.center.x = self.view.center.x
        
        return headerView
    }
    
    
    
    
    func updateTweet() {
        backend.getSubwayTweets()
        updatedLabel.text = "Last updated \(Date())"
        if tweetCache.count == 0 {
            // display text that there are no new tweets for the lines selected
            let labelText = "Last updated \(Date())" + "\nNo new tweets for the lines selected"
            updatedLabel.numberOfLines = 0
            updatedLabel.text = labelText
            print("no new tweets")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetDisplayIndexes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TweetTableViewCell
        
        cell.tweet.numberOfLines = 0
        cell.tweet.lineBreakMode = NSLineBreakMode.byWordWrapping
        let cacheIndex = tweetDisplayIndexes[indexPath.row]
        cell.createdAt.text = tweetCache[cacheIndex].createdAt
        cell.tweet.text = tweetCache[cacheIndex].tweetString
        let lineID = tweetCache[cacheIndex].id
        cell.metroID.image = UIImage(named: backend.getImageName(for: lineID)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let subwayLine = tweetCache[tweetDisplayIndexes[indexPath.row]].id
        if let urlStr = backend.getMapURL(for: subwayLine) {
            let webVC = LineWebDataViewController()
            webVC.url = URL(string: urlStr)
            webVC.navigationItem.title = "Route for " + subwayLine
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
}
