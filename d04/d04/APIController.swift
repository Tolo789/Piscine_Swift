//
//  APIController.swift
//  d04
//
//  Created by Claudio MUTTI on 10/4/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import Foundation

class APIController {
    weak var delegate : APITwitterDelegate?
    
    let token: String
    
    init(delegate: APITwitterDelegate, token: String) {
        self.delegate = delegate
        self.token = token
    }
    
    func requestLastTweets(keyword: String) {
        print("Fetching tweets with: \(keyword)")
        let escapedkeyword = (keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        let query = "?q=" + escapedkeyword + "&count=100" + "&lang=fr" + "&result_type=recent"
        print("Query:", query)
        let url = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json" + query)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            //            print("Response\n", response as Any)
            if let err = error {
                self.delegate?.handleError(error: err as NSError)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                        print("Print\n", dic)
                        if let statuses : [NSDictionary] = dic.value(forKey: "statuses") as? [NSDictionary] {
//                            print("Status\n", statuses)
                            var tweets = [Tweet]()
                            for status in statuses {
                                if let user : NSDictionary = status.value(forKey: "user") as? NSDictionary,
                                    let userName = user.value(forKey: "name") as? String,
                                    let text = status.value(forKey: "text") as? String,
                                    let createDate = status.value(forKey: "created_at") as? String {
                                    // Date is in UTC format, lets make it more readable
                                    let formattedDate = self.UTCToLocal(UTCDateString: createDate)
                                    
                                    // Tweet creation
                                    tweets.append(Tweet(description: formattedDate, name: userName, text: text))
                                }
                            }
                            self.delegate?.treatTweets(tweets: tweets)
                        }
                        else {
                            print("No statuses[] in dictionary")
                        }
                    }
                }
                catch (let err) {
                    self.delegate?.handleError(error: err as NSError)
                }
            }
        }
        task.resume()
    }
    
    private func UTCToLocal(UTCDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss ZZZZZ yyyy" //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let UTCDate = dateFormatter.date(from: UTCDateString)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
    }
}
