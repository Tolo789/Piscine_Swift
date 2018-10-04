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
    
    var showingImg: UIImage? = nil
    var showingAlert = false

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageLinks.allLinks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        if let image = ImageLinks.allLinks[indexPath.row].data {
            cell.reloadImage(image: image)
        }
        else {
            cell.loadImage(imageUrl: ImageLinks.allLinks[indexPath.row].link, idx: indexPath.row, viewController: self)
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

    func showError(message: String) {
        if showingAlert {
            return
        }
        showingAlert = true
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            print("Closing alert");
            self.showingAlert = false
        }
        alertController.addAction(closeAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func openImageRequest(image: UIImage) {
        showingImg = image
        performSegue(withIdentifier: "openImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openImage" {
            let dvc = segue.destination as! MyScrollViewController
            dvc.image = showingImg
        }
        else {
            print("Unkown segue id")
        }
    }
}

