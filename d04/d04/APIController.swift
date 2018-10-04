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
        let CUSTOMER_KEY = "ks34Pe0ncn4ztQSX2HVUMeORR"
        let CUSTOMER_SECRET = "ykt4F3i0HdNmU5MGxNWXURH1lTmtXwxqWilJBTymTxhSoJVqly"
        let BEARER = ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let url = NSURL(string: "hhtps:://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, error, response) in
            print(response as Any)
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(dic)
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }
}
