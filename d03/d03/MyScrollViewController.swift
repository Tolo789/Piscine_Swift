//
//  MyScrollViewController.swift
//  d03
//
//  Created by Claudio MUTTI on 10/4/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class MyScrollViewController : UIViewController, UIScrollViewDelegate {
    var imageView: UIImageView?
    var image: UIImage?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIImage filled with segue
        imageView = UIImageView(image: image)
        scrollView.addSubview(imageView!)
        scrollView.contentSize = imageView!.frame.size
        scrollView.maximumZoomScale = 1
        
        // Limit minimum zoom to fit screen with image width
        scrollView.minimumZoomScale = self.view.bounds.size.width / (self.imageView?.image?.size.width)!
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("changing orientation")
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.scrollView.minimumZoomScale = self.view.bounds.size.width / (self.imageView?.image?.size.width)!
            if (self.scrollView.zoomScale < self.scrollView.minimumZoomScale) {
                self.scrollView.zoomScale = self.scrollView.minimumZoomScale
            }
        }
        
    }
}
