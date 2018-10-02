//
//  NewNoteViewController.swift
//  d02
//
//  Created by Claudio MUTTI on 10/2/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCanceled" {
            print("Add Canceled")
        }
        else {
            print("Noob")
        }
    }
    
}
