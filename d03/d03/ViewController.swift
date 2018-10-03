//
//  ViewController.swift
//  d03
//
//  Created by Claudio MUTTI on 10/3/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageLinks.allLinks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        if let image = ImageLinks.allLinks[indexPath.row].data {
            cell.reloadImage(image: image)
        }
        else {
            cell.loadImage(imageUrl: ImageLinks.allLinks[indexPath.row].link, idx: indexPath.row)
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

