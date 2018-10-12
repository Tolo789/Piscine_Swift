
import CoreData

public class ArticleManager {
    public static let toto = 42
    
    var context: NSManagedObjectContext
    var allArticles = [Article]()
    
    public init() {
        // Load right bundle (tip in pdf)
        let myBundle = Bundle(for: Article.self)
        
        // ----- Tutorial at https://www.andrewcbancroft.com/2017/04/16/creating-the-core-data-stack-with-backwards-compatibility-in-swift/ -----------
        // Initialize NSManagedObjectModel
        let modelURL = myBundle.url(forResource: "articles", withExtension: "momd")
        guard let model = NSManagedObjectModel(contentsOf: modelURL!) else { fatalError("model not found") }
        
        // Configure NSPersistentStoreCoordinator with an NSPersistentStore
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let storeURL = try! FileManager
            .default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("articles.sqlite")
        
        try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
        // Create and return NSManagedObjectContext
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        // ----- End tutorail --------------------------
    }
    
    public func newArticle(title: String, content: String, language: String, image: NSData?) -> Article {
        var article : Article!
        context.performAndWait() {
            let ent: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Article", in: context)!
            article = Article(entity: ent, insertInto: context)
//            article = Article(context: self.context)
            article.title = title
            article.content = content
            article.language = language
            article.image = image
            article.create_date = NSDate()
            article.update_date = article.create_date
        }
        return article
    }
    
    public func testFunction() -> Int {
        return ArticleManager.toto
    }
    
    public func getAllArticles() -> [Article] {
        var fetchedResult = [Article]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        do {
            if let tmpRes = try context.fetch(fetchRequest) as? [Article] {
                fetchedResult = tmpRes
            }
            
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
        return fetchedResult
    }
    
    public func getArticles(withLang lang : String) -> [Article] {
        var fetchedResult = [Article]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "language == %@", lang)
        do {
            fetchedResult = try context.fetch(fetchRequest) as! [Article]
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
        
        return fetchedResult
    }
    
    public func getArticles(containString str : String)  -> [Article] {
        var fetchedResult = [Article]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS %@ OR content CONTAINS %@", str, str)
        do {
            fetchedResult = try context.fetch(fetchRequest) as! [Article]
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
        
        return fetchedResult
    }
    
    public func removeArticle(article : Article) {
        context.delete(article)
    }
    
    public func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("[ArticleManager] Changes saved")
            }
            catch(let error) {
                print("Error while saving\n", error)
            }
        }
    }
}
