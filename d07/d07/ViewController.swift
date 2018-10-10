//
//  ViewController.swift
//  d07
//
//  Created by Claudio MUTTI on 10/10/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    
    var recastBot : RecastAIClient?
    let recastToken = "189ed0318d082d68741947f976446bbb"
    let recastLanguage = "en"
    
    var forecastBot: DarkSkyClient?
    let forecastToken = "9e2fad2e332d0fb2684aa2cad59ae658"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recastBot = RecastAIClient(token : recastToken, language: recastLanguage)
        forecastBot = DarkSkyClient(apiKey: forecastToken)
        forecastBot?.units = .si
        forecastBot?.language = .english
    }

    @IBAction func searchButton(_ sender: UIButton) {
        if recastBot != nil, forecastBot != nil, let question = textField.text, !question.isEmpty {
            // Start request
            print("Start RecastAi textRequest()")
            self.recastBot!.textRequest(question, token: recastToken, lang: recastLanguage,
              successHandler: { response in
//                print("Success\n\(response)")
                if let intent = response.intent(), let location = response.get(entity: "location"), let latitude = location["lat"] as? Double, let longitude = location["lng"] as? Double {
                    print("Intent:\n\(intent)")
//                    answer = "Lat: \(latitude)\nLng: \(longitude)"
                    print("Start ForecastIO getForecast()")
                    self.forecastBot!.getForecast(latitude: latitude, longitude: longitude) { result in
                        switch result {
                        case .success(let currentForecast, _):
//                            print("Forecast\n\(currentForecast)")
//                            print("Metadata\n\(requestMetadata)")
                            if let summary = currentForecast.currently?.summary {
                                DispatchQueue.main.async {
                                    self.answerLabel.text = summary
                                }
                            }
                        case .failure(let error):
                            print("Error with forecast\n\(error)")
                            DispatchQueue.main.async {
                                self.answerLabel.text = "Error with ForecastIO"
                            }
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.answerLabel.text = "Error: No intent/location detected"
                    }
                }
                
              },
              failureHandle: { error in
                print("Error: failure with recast query\n\(error)")
                DispatchQueue.main.async {
                    self.answerLabel.text = "Error: failure with recast query"
                }
              }
            )
        }
        else {
            print("One of your bots may be nil or text is empty")
            DispatchQueue.main.async {
                self.answerLabel.text = "One of your bots may be nil or text is empty"
            }
        }
    }
    
}

