
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
    var vcTitle = ""
    var currentTweet: Tweet? = nil
    
    private let backend = BackEnd.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = vcTitle
        
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
//        tweetTableView.reloadData()
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
    
//    func UpdateButtonTapped(_ sender: UIButton) {
//        backend.getSubwayTweets()
//    }
    
    // MARK: - Table view Header
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(60)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //        let frame = tweetTableView.frame
        
        // create button
        let button = UIButton(frame: CGRect(x: 120 , y: 15, width: 200, height: 30))
        button.addTarget(self, action: #selector(updateTweet), for: .touchUpInside)
        button.setTitle("Update Tweets", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 60))
        headerView.backgroundColor = .lightGray
        headerView.addSubview(button)   // add the button to the view
        
        return headerView
    }
    
    func updateTweet() {
        backend.getSubwayTweets()
        print("updateTweet")
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
