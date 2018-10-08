//
//  ViewController.swift
//  d06
//
//  Created by Claudio MUTTI on 10/8/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let viewColors : [UIColor] = [.red, .blue, .green, .yellow, .gray, .cyan]
    
    var dynamicAnimator = UIDynamicAnimator()
    let gravityBehavior = UIGravityBehavior()
    let collisionBehaviour = UICollisionBehavior()
    let elasticityBehavior = UIDynamicItemBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        gravityBehavior.magnitude = 2
        dynamicAnimator.addBehavior(gravityBehavior)
        
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehaviour)
        
        elasticityBehavior.elasticity = 0.6
        dynamicAnimator.addBehavior(elasticityBehavior)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        let newView = UIView(frame: CGRect(x: sender.location(in: view).x - 50, y: sender.location(in: view).y - 50, width: 100, height: 100))
        newView.backgroundColor = viewColors[Int(arc4random_uniform(UInt32(viewColors.count)))]
        
        if Int(arc4random_uniform(UInt32(2))) == 1 {
             newView.layer.cornerRadius = newView.frame.size.width / 2
        }
        
        view.addSubview(newView)
        gravityBehavior.addItem(newView)
        collisionBehaviour.addItem(newView)
        elasticityBehavior.addItem(newView)
    }
}

