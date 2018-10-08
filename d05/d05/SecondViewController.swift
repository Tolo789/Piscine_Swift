//
//  SecondViewController.swift
//  d05
//
//  Created by Claudio MUTTI on 10/8/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! SavedPlaceTableViewCell
        cell.place = SavedPlace.allPlaces[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SavedPlace.allPlaces.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tabBarController != nil, let controllers = tabBarController?.viewControllers, controllers.count > 0, let vc = tabBarController?.viewControllers![0] as? FirstViewController {
            vc.consumableSavedPlace = SavedPlace.allPlaces[indexPath.row]
            tabBarController?.selectedIndex = 0
        }
    }
}

