//
//  ViewController.swift
//  d09
//
//  Created by Claudio MUTTI on 10/12/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    let authContext = LAContext()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        authenticateUser()
    }
    
    private func authenticateUser() {
        if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: NSLocalizedString("Secrets are Secrets !", comment: "")) {
                (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "authSuccess", sender: self)
                    }
                }
                else {
                    print(error!)
                    self.authenticateUser()
                }
            }
        }
        else {
            print("Cannot find a way to authenticate")
        }
        
    }

}

