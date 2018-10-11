//
//  ViewController.swift
//  cmutti2018
//
//  Created by Tolo789 on 10/10/2018.
//  Copyright (c) 2018 Tolo789. All rights reserved.
//

import UIKit
import CoreData
import cmutti2018

@available(iOS 10.0, *)
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let articleManager = ArticleManager()
        
        // Print saved articles
        print("--- Print saved articles -----------------------")
        for article in articleManager.getAllArticles() {
            print(article.description, "\n")
        }
        print("--- End print saved articles -----------------------\n")
        
        
        print("--- Add mulitples articles --------------------")
        var newArticle: Article
        newArticle = articleManager.newArticle(title: "title", content: "toto", language: "en", image: nil)
        print(newArticle.description, "\n")
        newArticle = articleManager.newArticle(title: "le Titre est 'toto'", content: "Mindblowing test ;)", language: "en", image: nil)
        print(newArticle.description, "\n")
        newArticle = articleManager.newArticle(title: "French test", content: "Mot 'title' dans le contenu", language: "fr", image: nil)
        print(newArticle.description, "\n")
        newArticle = articleManager.newArticle(title: "title3", content: "toto3", language: "en", image: nil)
        print(newArticle.description, "\n")
        newArticle = articleManager.newArticle(title: "title4", content: "4", language: "en", image: nil)
        print(newArticle.description, "\n")
        newArticle = articleManager.newArticle(title: "title5", content: "tot6", language: "fr", image: nil)
        print(newArticle.description, "\n")
        print("--- End add mulitples articles --------------------\n")        
        
        print("--- Print all articles -----------------------")
        for article in articleManager.getAllArticles() {
            print(article.description, "\n")
        }
        print("--- End print all articles -----------------------\n")
        
        
        print("--- Search articles with 'toto' inside -----------------------")
        for article in articleManager.getArticles(containString: "toto") {
            print(article.description, "\n")
        }
        print("--- End print 'toto' articles -----------------------\n")
        
        
        print("--- Search articles in 'en' language -----------------------")
        for article in articleManager.getArticles(withLang: "en") {
            print(article.description, "\n")
        }
        print("--- End print 'en' articles -----------------------\n")
        
        
        print("--- Search articles in 'it' language -----------------------")
        for article in articleManager.getArticles(withLang: "it") {
            print(article.description, "\n")
        }
        print("--- End print 'it' articles -----------------------\n")
        
        print(" - Delete all articles\n")
        for article in articleManager.getAllArticles() {
            articleManager.removeArticle(article: article)
        }
        
        print(" - Add one article")
        newArticle = articleManager.newArticle(title: "New generation", content: "Only article that survived from last iteration", language: "en", image: nil)
        print(newArticle.description)
        
        print("\n - Save")
        articleManager.save()
        
        print("\n - Add another article but don't save")
        newArticle = articleManager.newArticle(title: "Sad article", content: "This article will NOT be saved", language: "en", image: nil)
        print(newArticle)
    }
}
