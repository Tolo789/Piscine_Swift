//
//  CollectionViewCell.swift
//  d03
//
//  Created by Claudio MUTTI on 10/3/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private static var loadingThreads = 0
    private static var viewToCall : ViewController!

    private static func increaseLoadingThreads() {
        if (loadingThreads == 0) {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        loadingThreads += 1
    }
    
    private static func decreaseLoadingThreads() {
        if (loadingThreads == 0) {
            return
        }
        
        loadingThreads -= 1
        if (loadingThreads == 0) {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    @IBOutlet weak var myImage: UIImageView!
    
    func loadImage(imageUrl: String, idx: Int, viewController: ViewController) {
        let qos = DispatchQoS.userInitiated.qosClass
        let queue = DispatchQueue.global(qos: qos)
        
        // Clear prev img
        myImage.isUserInteractionEnabled = false
        if let gestures = myImage.gestureRecognizers {
            for gesture in gestures {
                myImage.removeGestureRecognizer(gesture)
            }
        }
        myImage.image = nil
        
        // Load img
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
        activityIndicator.center = myImage.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        myImage.addSubview(activityIndicator);
        activityIndicator.startAnimating();
        
        
        // Start fetch on other thread
        queue.async {
            CollectionViewCell.increaseLoadingThreads()
            
            if let url = URL(string: imageUrl) {
                let data = try? Data(contentsOf: url)
                
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating();
                            self.myImage.image = image
                            
                            // Add gesture on image
                            CollectionViewCell.viewToCall = viewController
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageClick) )
                            self.myImage.isUserInteractionEnabled = true
                            self.myImage.addGestureRecognizer(tapGestureRecognizer)
                        }
                        // Enable save of image
                        //                ImageLinks.allLinks[idx].data = image
                    }
                    else {
                        DispatchQueue.main.async {
                            viewController.showError(message: "No image at link  (\(imageUrl))")
                            activityIndicator.stopAnimating();
                            self.myImage.image = UIImage(named: "brokenImage")
                        }
                        
                    }
                }
                else {
                    DispatchQueue.main.async {
                        viewController.showError(message: "No data in given link  (\(imageUrl))")
                        activityIndicator.stopAnimating();
                        self.myImage.image = UIImage(named: "brokenImage")
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    viewController.showError(message: "Invalid Url (\(imageUrl))")
                    activityIndicator.stopAnimating();
                    self.myImage.image = UIImage(named: "brokenImage")
                }
            }
            
            // Last action will always be to decrement loadingThreads
            CollectionViewCell.decreaseLoadingThreads()
        }
    }
    
    func reloadImage(image: UIImage) {
        self.myImage.image = image
    }
    
    @objc func imageClick(recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view as? UIImageView, let image = view.image {
            CollectionViewCell.viewToCall.openImageRequest(image: image)
        }
    }
}
