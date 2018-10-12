//
//  ArticleViewController.swift
//  d09
//
//  Created by Claudio MUTTI on 10/12/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit
import Photos
import cmutti2018

class ArticleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var toOpen: Article?
    let pickerController = UIImagePickerController()
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBAction func saveArticleButton(_ sender: UIBarButtonItem) {
        if titleText.text?.isEmpty == false && contentText.text.isEmpty == false {
            toOpen?.update_date = NSDate()
            if toOpen?.title == "" {
                toOpen?.create_date = toOpen?.update_date
            }
            
            toOpen?.title = titleText.text
            toOpen?.content = contentText.text
            toOpen?.language = Locale.current.languageCode ?? "en"
            
            if let imageUI = articleImageView.image, let selectedImage = UIImagePNGRepresentation(imageUI) as NSData? {
                toOpen?.image = selectedImage
            }
            performSegue(withIdentifier: "saveArticle", sender: self)
        }
    }
    @IBAction func takePictureButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.sourceType = .camera
            present(pickerController, animated: true, completion: nil)
        }
    }
    @IBAction func openGalleryButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerController.delegate = self
        
        // Prefill fields if is not empty article
        if toOpen?.title?.isEmpty == false {
            titleText.text = toOpen?.title
            contentText.text = toOpen?.content
            if let imageData = toOpen?.image as Data?, let myImage = UIImage(data: imageData) {
                articleImageView.image = myImage
            }
            // TODO: load image
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        articleImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
}
