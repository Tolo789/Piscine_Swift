//
//  ForumViewController.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class ForumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var requestedId = 0
    @IBOutlet weak var tableView: UITableView!
    
    var totalTopics = 0
    var fetchedTopics = [Topic]()
    var quering = false
    var queriedTopics = [(idx: Int, action: (Bool, Any) -> Void)]()
    
    let tmpTopic = Topic(userName: "", createDate: "", topicTitle: "Loading...", id: -1)
    
    @IBAction func myUnwind(unwindSegue: UIStoryboardSegue) {
        print("Coming back")
        APIController.currentView = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        APIController.currentView = self
        quering = true
        APIController.getToken {
            success in
            if success {
                APIController.getTopics(page: 1) {
                    success, myArray, totalElems in
                    if success, let allTopics = myArray as? [Topic] {
                        self.totalTopics = totalElems
                        self.fetchedTopics = allTopics
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        self.displayAlert(message: "Could not fetch Topics")
                    }
                }
            } else {
                self.displayAlert(message: "Could not fetch Token")
            }
            // Can now start new queries
            self.quering = false
        }
    }
    
    func askForTopic(at idx: Int, action: @escaping (Bool, Any) -> Void) {
        for (i, savedQuery) in queriedTopics.enumerated() {
            if savedQuery.idx == idx {
                // Topic was already queried, just update action
                queriedTopics[i].action = action
                return
            }
        }
        
        queriedTopics.append((idx, action))
        askForQueriedTopics();
    }
    
    private func askForQueriedTopics() {
        if !quering, queriedTopics.count > 0 {
            quering = true
            
            APIController.getTopics(page: ((queriedTopics[0].idx + 1) / APIController.pageSize) + 1) {
                success, myArray, totalElems in
                if success, let allTopics = myArray as? [Topic] {
                    DispatchQueue.main.async {
                        for (i, _) in allTopics.enumerated() {
                            for (j, savedQuery) in self.queriedTopics.enumerated() {
                                if savedQuery.idx == i + self.fetchedTopics.count {
                                    self.queriedTopics[j].idx = -1
                                }
                            }
                        }
                        // Only clear topics that get an action
                        self.queriedTopics = self.queriedTopics.filter { $0.idx >= 0 }
                        
                        // Add just retrieved topics to all
                        self.fetchedTopics = self.fetchedTopics + allTopics
                        
                        // Force update of ui
                        self.tableView.reloadData()
                    }
                } else {
                    self.displayAlert(message: "Could not fetch Topics")
                    self.queriedTopics.removeAll()
                }
                
                // Can now start new queries
                self.quering = false
                self.askForQueriedTopics()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalTopics
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell") as! TopicTableViewCell
        if (indexPath.row >= fetchedTopics.count) {
            // API request to fetch new elems
            cell.topic = tmpTopic
            
            askForTopic(at: indexPath.row) {
                success, data in
                if success, let topic = data as? Topic {
                    cell.topic = topic
                }
            }
        }
        else {
            cell.topic = fetchedTopics[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !quering {
            requestedId = fetchedTopics[indexPath.row].id
            performSegue(withIdentifier: "openTopic", sender: self)
        }
    }
    
    func displayAlert(title: String = "Error", message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("Closing alert");
            }
            alertController.addAction(closeAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openTopic" {
            let dvc = segue.destination as! TopicViewController
            dvc.topicId = requestedId
        }
    }
}
