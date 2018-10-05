//
//  ViewController.swift
//  d04
//
//  Created by Claudio MUTTI on 10/4/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var token: String = ""
    var apiController: APIController?
    var tweets = [Tweet]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText.delegate = self
        getToken()
    }
    
    private func getToken() {
        let CUSTOMER_KEY = "ks34Pe0ncn4ztQSX2HVUMeORR"
        let CUSTOMER_SECRET = "ykt4F3i0HdNmU5MGxNWXURH1lTmtXwxqWilJBTymTxhSoJVqly"
        let BEARER = ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let url = NSURL(string: "https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
//            print("Response\n", response as Any)
            if let err = error {
                print("Error in URL response\n", err)
                self.handleError(error: err as NSError)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                        print("Print\n", dic)
                        if let accToken = dic.value(forKey: "access_token") as? String {
                            self.token = accToken
                            print("Token: " + self.token)
                            self.apiController = APIController(delegate: self, token: self.token)
                            self.askForTweets(with: "ecole 42")
                        }
                    }
                }
                catch (let err) {
                    print("Catched Error\n", err)
                    self.handleError(error: err as NSError)
                }
            }
        }
        task.resume()
    }
    
    func askForTweets(with keyword: String) {
        if let apiC = apiController {
            apiC.requestLastTweets(keyword: keyword)
        }
    }
    
    func treatTweets(tweets: [Tweet]) {
        print("Treating Tweets\n", tweets)
        for tweet in tweets {
            print("Tweet\n\tName: \(tweet.name)\n\tDescription: \(tweet.description)\n\tText: \(tweet.text)")
        }
        self.tweets = tweets
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func handleError(error: NSError) {
        print("Handling Error\n", error)
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("Closing alert");
            }
            alertController.addAction(closeAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = searchText.text {
            askForTweets(with: text)
        }
        searchText.resignFirstResponder()
        return true
    }
}

