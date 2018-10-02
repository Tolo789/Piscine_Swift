//
//  ViewController.swift
//  d02
//
//  Created by Claudio MUTTI on 10/2/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newNoteSegue" {
            if segue.destination is NewNoteViewController {
                print("Add Started")
            }
        }
    }
    
    @IBAction func myUnwind(unwindSegue: UIStoryboardSegue) {
        print("Coming back")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Notes.allNotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell")
        cell?.textLabel?.text = Notes.allNotes[indexPath.row].name
        cell?.detailTextLabel?.text = Notes.allNotes[indexPath.row].cause
        return cell!
    }

}

