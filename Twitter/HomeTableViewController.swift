//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Alex Rich on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numOfTweets: Int!
    
    //for pull down from top
    let tweetRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()

        tweetRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tableView.refreshControl = tweetRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets();
    }
    
    @objc func loadTweets() {
        numOfTweets = 20
        let tweetURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let tweetParams = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetURL, parameters: tweetParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.tweetRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("error loading tweets")
        })
    }
    
    
    
    func loadMoreTweets() {
        let tweetURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let tweetParams = ["count": numOfTweets]
        numOfTweets += 20
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetURL, parameters: tweetParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Error loading Tweets")
        })
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    
    
    @IBAction func logoutUser(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "currentlyLoggedIn")
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        
        cell.profilePicture.af_setImage(withURL: imageURL!)
        cell.username.text = (user["name"] as! String)
        cell.tweetText.text = (tweetArray[indexPath.row]["text"] as! String)
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        return cell
    }
    
    
    
    //reloads tweets when scroll down to bottom
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
}
