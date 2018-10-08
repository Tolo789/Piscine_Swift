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
    
    @IBAction func logInButton(_ sender: Any) {
        APIController.currentView = self
        let url = URL(string: APIController.authLink)
        safariView = SFSafariViewController(url: url!)
        present(safariView!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Skip auth if Access Token is set
        if APIController.canSkipAuth() {
            performSegue(withIdentifier: "showForum", sender: self)
        }
    }
    
    func loginEnded() {
        safariView?.dismiss(animated: false) {
            self.performSegue(withIdentifier: "showForum", sender: self)
        }
    }
}

