//
//  TweetTableViewController.swift
//  MetroTweet
//
//  Created by Emiko Clark on 7/20/17.
//  Copyright © 2017 Avery Barrantes. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController {

    
    @IBOutlet var tweetTableView: UITableView!
    let tweetBackend = TweetBackEnd()
    var vcTitle = "Tweets for " + "E, F, M"
    var currentTweet: Tweet? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetBackend.createTweetArray()
        self.navigationItem.title = vcTitle

        // register custom cell class
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        tweetBackend.createTweetArray()
        
    }


    func UpdateButtonTapped(_ sender: UIButton) {
    }
    
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
        print("updateTweet")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetBackend.tweetArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TweetTableViewCell
        
        cell.tweet.numberOfLines = 0
        cell.tweet.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.createdAt.text = tweetBackend.tweetArray[indexPath.row].createdAt
        cell.tweet.text = tweetBackend.tweetArray[indexPath.row].tweetString
        let lineID = tweetBackend.tweetArray[indexPath.row].id
        cell.metroID.image = UIImage(named: tweetBackend.metroImageDict[lineID]!)
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        currentTweet = tweetBackend.tweetArray[indexPath.row]
        
        print(indexPath.row, tweetBackend.tweetArray[indexPath.row].id, tweetBackend.tweetArray[indexPath.row].createdAt, tweetBackend.tweetArray[indexPath.row].tweetString, tweetBackend.tweetArray[indexPath.row].routeUrl)
        
        let webVC = LineWebDataViewController()
        webVC.url = currentTweet?.routeUrl
        webVC.navigationItem.title = "Routes for " + (currentTweet?.id)!
        self.navigationController?.pushViewController(webVC, animated: true)
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
