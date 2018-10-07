//
//  ViewController.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit
import SafariServices

class LogInViewController: UIViewController {
    var safariView: SFSafariViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if APIController.canSkipAuth() {
            performSegue(withIdentifier: "showForum", sender: self)
        }
        else {
            APIController.currentView = self
            let url = URL(string: APIController.authLink)
            safariView = SFSafariViewController(url: url!)
            present(safariView!, animated: true, completion: nil)
        }
        
    }
    
    func loginEnded() {
        safariView?.dismiss(animated: false) {
            self.performSegue(withIdentifier: "showForum", sender: self)
        }
    }
}

