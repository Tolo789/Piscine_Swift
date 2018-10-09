//
//  ViewController.swift
//  d06
//
//  Created by Claudio MUTTI on 10/8/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dynamicAnimator: UIDynamicAnimator!
    let gravityBehavior = UIGravityBehavior()
    let collisionBehaviour = UICollisionBehavior()
    let elasticityBehavior = UIDynamicItemBehavior()
    
    var addedForms = [MyForm]()
    var selectedFormIdx = -1
    
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
        // Only spawn if click on an empty space
        if addedForms.first(where: {$0.frame.contains(sender.location(in: view))}) == nil {
            let newForm = MyForm(x: sender.location(in: view).x, y: sender.location(in: view).y)
            
            addedForms.append(newForm)
            view.addSubview(newForm)
            gravityBehavior.addItem(newForm)
            collisionBehaviour.addItem(newForm)
            elasticityBehavior.addItem(newForm)
        }
    }
    
    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            if let (idx, _) = addedForms.enumerated().first(where: {$0.element.frame.contains(sender.location(in: view))}) {
                print("pinch start")
                selectedFormIdx = idx
                gravityBehavior.removeItem(addedForms[selectedFormIdx])
//                                collisionBehaviour.removeItem(addedForms[selectedFormIdx])
//                                elasticityBehavior.removeItem(addedForms[selectedFormIdx])
                view.bringSubview(toFront: addedForms[selectedFormIdx])
            }
        }
        
        if (sender.state == .began || sender.state == .changed) && selectedFormIdx >= 0 {
            addedForms[selectedFormIdx].changeScale(scale: sender.scale)
            dynamicAnimator.updateItem(usingCurrentState: addedForms[selectedFormIdx])
            sender.scale = 1
        }
        else {
            if selectedFormIdx >= 0 {
                gravityBehavior.addItem(addedForms[selectedFormIdx])
//                                collisionBehaviour.addItem(addedForms[selectedFormIdx])
//                                elasticityBehavior.addItem(addedForms[selectedFormIdx])
                dynamicAnimator.updateItem(usingCurrentState: addedForms[selectedFormIdx])
            }
            selectedFormIdx = -1
            sender.scale = 1
        }
    }
    
    @IBAction func rotationGesture(_ sender: UIRotationGestureRecognizer) {
        guard sender.view != nil else { return }
        
        if sender.state == .began {
            if let (idx, _) = addedForms.enumerated().first(where: {$0.element.frame.contains(sender.location(in: view))}) {
                print("rotation start")
                selectedFormIdx = idx
                gravityBehavior.removeItem(addedForms[selectedFormIdx])
//                collisionBehaviour.removeItem(addedForms[selectedFormIdx])
//                elasticityBehavior.removeItem(addedForms[selectedFormIdx])
                view.bringSubview(toFront: addedForms[selectedFormIdx])
                
            }
        }
        
        if (sender.state == .began || sender.state == .changed) && selectedFormIdx >= 0 {
            addedForms[selectedFormIdx].changeRotation(by: sender.rotation)
            dynamicAnimator.updateItem(usingCurrentState: addedForms[selectedFormIdx])
            sender.rotation = 0
        }
        else {
            if selectedFormIdx >= 0 {
                gravityBehavior.addItem(addedForms[selectedFormIdx])
//                collisionBehaviour.addItem(addedForms[selectedFormIdx])
//                elasticityBehavior.addItem(addedForms[selectedFormIdx])
                dynamicAnimator.updateItem(usingCurrentState: addedForms[selectedFormIdx])
            }
            selectedFormIdx = -1
        }
    }
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if let (idx, _) = addedForms.enumerated().first(where: {$0.element.frame.contains(sender.location(in: view))}) {
                selectedFormIdx = idx
                gravityBehavior.removeItem(addedForms[selectedFormIdx])
                view.bringSubview(toFront: addedForms[selectedFormIdx])
            }
        case .changed:
            if selectedFormIdx >= 0 {
                addedForms[selectedFormIdx].changePosition(newX: sender.location(in: view).x, newY: sender.location(in: view).y)
                dynamicAnimator.updateItem(usingCurrentState: addedForms[selectedFormIdx])
            }
        case .ended:
            if selectedFormIdx >= 0 {
                addedForms[selectedFormIdx].changePosition(newX: sender.location(in: view).x, newY: sender.location(in: view).y)
                dynamicAnimator.updateItem(usingCurrentState: addedForms[selectedFormIdx])
                gravityBehavior.addItem(addedForms[selectedFormIdx])
                selectedFormIdx = -1
            }
        case .failed, .cancelled:
            print("Failed/Canceled")
            if selectedFormIdx > 0 {
                selectedFormIdx = -1
                gravityBehavior.addItem(addedForms[selectedFormIdx])
            }
        case .possible:
            print("possibile")
        }
    }
}

