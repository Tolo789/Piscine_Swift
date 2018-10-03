//
//  CollectionViewCell.swift
//  d03
//
//  Created by Claudio MUTTI on 10/3/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var myImage: UIImageView!
    
    func loadImage(imageUrl: String, idx: Int) {
        let qos = DispatchQoS.default.qosClass
        let queue = DispatchQueue.global(qos: qos)
        
        // Tmp img
        myImage.image = UIImage(named: "brokenImage")
        
        
        // Start fetch on other thread
        queue.async {
            let url = URL(string: imageUrl)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.myImage.image = image
                }
                
                ImageLinks.allLinks[idx].data = image
            }
            else {
                print("Error")
            }
        }
    }
    
    func reloadImage(image: UIImage) {
        self.myImage.image = image
    }
}
