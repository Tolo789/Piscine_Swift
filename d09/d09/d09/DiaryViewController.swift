//
//  DiaryViewController.swift
//  d09
//
//  Created by Claudio MUTTI on 10/12/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit
import cmutti2018

class DiaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let articleManager = ArticleManager()
    var articles = [Article]()
    var selectedArticle: Article? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addArticleButton(_ sender: UIBarButtonItem) {
        let newArticle = articleManager.newArticle(title: "", content: "", language: "", image: nil)
        openArticle(article: newArticle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        _ = articleManager.newArticle(title: "Test", content: "yoooo", language: "en", image: nil)
//        articleManager.save()
        
        updateArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // clean tmp Article if we are coming back from ArticleViewController
        if selectedArticle != nil {
            // if it was a new article and it hasn't been changed, then delete it
            if selectedArticle!.title == "" {
                articleManager.removeArticle(article: selectedArticle!)
            }
            selectedArticle = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openArticle" && selectedArticle != nil {
            let dest = segue.destination as! ArticleViewController
            dest.toOpen = selectedArticle
        }
    }
    
    @IBAction func myUnwind(unwindSegue: UIStoryboardSegue) {
        // This unwind will only be called when an article is saved
        articleManager.save()
        updateArticles()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleTableViewCell
        cell.article = articles[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clickedArticle = articles[indexPath.row]
        openArticle(article: clickedArticle)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.articleManager.removeArticle(article: self.articles[editActionsForRowAt.row])
            self.articleManager.save()
            self.updateArticles()
        }
        delete.backgroundColor = .red
        let useless = UITableViewRowAction(style: .normal, title: "                                               ") { action, index in
            print("Easter Egg ;)")
        }
        useless.backgroundColor = .red
        return [useless, delete]
    }
    
    private func updateArticles() {
        articles = articleManager.getArticles(withLang: (Locale.current.languageCode ?? "en"))
        tableView.reloadData()
    }
    
    private func openArticle(article: Article) {
        selectedArticle = article
        performSegue(withIdentifier: "openArticle", sender: self)
    }
}
