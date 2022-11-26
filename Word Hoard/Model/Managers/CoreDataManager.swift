//
//  CoreDataManager.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/29/22.
//

import CoreData
import UIKit
import Network
import NotificationBannerSwift

class CoreDataManager
{
    var categoryArray = [Category]()
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //Core Data Contect to Save Data
    
    var networkCheck = NetworkCheck.sharedInstance()
    
    static let sharedManager = CoreDataManager() //Create Instance of Persistance Contaner
    private init() {} // Prevent clients from creating another instance.
    
    lazy var persistentContainer: NSPersistentContainer =
    {
        let container = NSPersistentContainer(name: "Learner")
        container.loadPersistentStores(completionHandler:
                                        { (storeDescription, error) in
            
            if storeDescription == storeDescription
            {
            }
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    //MARK: -  Update Score Start
    //Update and decrment score
    func addPoint(word: Item)
    {
        print("Added 1 Point to word \(word.word?.lowercased())")
        word.score = Int64(word.score) + Int64(1)
        save()
    }
    
    //Update and decrment score
    func removePoint(word: Item)
    {
        if word.score > 0
        {
            print("Removed 1 Point to word \(word.word?.lowercased())")
            word.score = Int64(word.score) - Int64(1)
            save()
        }else
        {
            print("Cannot remove points from a word with 0 points \(word.word)")
        }
       
    }
    
    func findWord(wordString: String) -> Item?
    {
        print("Looking for word \(wordString)")
        let allwords = retriveAllItems()
        
        for word in allwords
        {
            
            if word.word?.lowercased() == wordString.lowercased()
            {
              
                return word
          }

        }
        return nil
    }
    
    //MARK: -  Remove Score Start
    
    //MARK: - Categories
    func addnewCategory(categorieName: String)
    {
        if categoryAlreadyExists(categorieName: categorieName)
        {
            print("This category already exist bro")
            showDuplicateBanner()
        }
        else
        {
            print("New Category \(categorieName)")
            let newCategory = Category(context: self.context)
            newCategory.name = categorieName
            self.save()
        }
       
    }
    
    #warning("This does not work properly")
    @discardableResult
    private func categoryAlreadyExists(categorieName: String)->Bool
    {
        print("Checking for duplicate categories")
        let allCategories = getAllCategories()
        for category in categoryArray
        {
            print(category.name?.lowercased())
            if category.name?.lowercased() == categorieName.lowercased()
            {
                return true
            }
        }
        return false
    }
    
    
    //MARK: - Functions used to add items
    /**
     Function accepts a array of string and a category to be processed. Each word in the array is checked to determine if it exists in the category before it is added to the categorie
     */
    func requestDataforSingleWord(nameOfWord: [String], category: Category)
    {
        var numberOfDuplicateWords = 0 //Check for duplicate words
        
        if isConnectedToInternet()
        {
            for item in nameOfWord
            {
                //Process each item in the array
                if wordAlreadyExistInCategory(name: item, selectedCategory: category)
                {
                    numberOfDuplicateWords += 1
                }
                else
                {
                    DispatchQueue.global().async
                    {
                        _ = DictionaryRequest.init(wordPassed: item,category: category )
                    }
                   
                }
            }
           // duplicateWordErrors(numnberOfDuplicate: numberOfDuplicateWords)
           
        }
        else
        {
            noInternetBanner()
        }
    }
    
    func createWordEntry(word: String, partOfSpeech: String, wordExample: String, definition: String,category: Category)
    {
       //Word has already been defined. No need to check for an internet connectin
    
        //Create a new item and save
        let newItem = Item(context: self.context)
        
        //Asign variables
        newItem.parentCategory = category
        newItem.word = word
        newItem.partofspeech = partOfSpeech
        newItem.example = wordExample
        newItem.defenition = definition
        
        //save
        save()
    }
    
    @discardableResult
     func wordAlreadyExistInCategory(name: String,selectedCategory: Category)->Bool
    {
        let allItems = loadItems(selectedCategory: selectedCategory)
        
        for item in allItems
        {
            
            if item.word?.lowercased() == name.lowercased()
            {
                return true
            }
        }
        return false
    }
    
    func retriveAllItems()-> [Item]
    {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do
        {
            let array = try context.fetch(request)
           return array
        }catch
        {
            print("Error Loading Context \(error)")
            return []
        }
    }
//MARK: - Functions for categories
    func getAllCategories() -> [Category]
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do
        {
            let array = try context.fetch(request)
            let duplicateArray = array
            return duplicateArray.reversed()
        }
        catch
        {
            print("Error Loading Context \(error)")
            return categoryArray
        }
    }
    
    func retriveCategoriefromString(categoryName: String)->Category?
    {
        for category in getAllCategories()
        {
            if category.name == categoryName
            {
                return category
            }
        }
        return nil
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil, selectedCategory: Category) -> [Item]
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory.name!)
        
        if let addtionalPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else
        {
            request.predicate = categoryPredicate
        }
        
        do
        {
            itemArray = try context.fetch(request)
            return itemArray.reversed()
            
        }
        catch
        {
            print("Error fetching data from context \(error)")
        }
        
        return itemArray
    }
    
    //MARK: - Delete and save Function
    func requestToDeleteCategory(category : Category)
    {
        deleteItemsInCategory(categorie: category)
        do
        {
            context.delete(category)
            
        }

        save()

    }
    
    func deleteItemsInCategory(categorie: Category)
    {
        let wordsInCategory = loadItems(selectedCategory: categorie)
        
            for word in wordsInCategory
            {
                requestToDeleteWord(specificWord: word)
            }
            print("Deleted all words in the category")
        
    }
    
    func requestToDeleteWord(specificWord : Item)
    {
        do
        {
            context.delete(specificWord)
        }

        save()

    }
    
    func save()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print("Error Saving Context \(error)")
        }
        
       
        postNotifications()
        
    }
}

//MARK: - Notifications
extension CoreDataManager
{
    func postNotifications()
    {
        DispatchQueue.main.async
        {
            self.postBarcodeNotification(code: NotificationString.updateCollectionVC)
            self.postBarcodeNotification(code: NotificationString.updateWordVC)
        }
    }
    
    private func postBarcodeNotification(code: String)
    {
        var info = [String: String]()
        info[code.description] = code.description //post the notification with the key.
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationString.notificationKey), object: nil, userInfo: info)
    }
}

//MARK: - Internet Connection Protocol function
extension CoreDataManager: NetworkCheckObserver
{
    func statusDidChange(status: NWPath.Status)
    {
        if status == .satisfied
        {
            //Do something
        }else if status == .unsatisfied
        {
            //Show no network alert
        }
    }
    
    @discardableResult
    func isConnectedToInternet()->Bool
    {
        networkCheck.addObserver(observer: self)
        
        if networkCheck.currentStatus == .satisfied{
            
            return true
        }else
        {
            return false
        }
       
    }
    
}

//MARK: - Banners
extension CoreDataManager
{
    private func noInternetBanner()
    {
        let banner = FloatingNotificationBanner(title: "🌎", subtitle: "No internet connection- Try again later", style: .danger)
        banner.show(queuePosition: .front, bannerPosition: .top, cornerRadius: 15)
    }
    
    private func duplicateWordErrors(numnberOfDuplicate: Int)
    {
        if numnberOfDuplicate == 1
        {
            let banner = FloatingNotificationBanner(title: "Duplicate Found", subtitle: "\(numnberOfDuplicate) Duplicate word was found", style: .danger)
            banner.show(queuePosition: .front, bannerPosition: .top, cornerRadius: 15)
            return
        }
        
        if numnberOfDuplicate > 1
        {
            let banner = FloatingNotificationBanner(title: "Duplicate Found", subtitle: "\(numnberOfDuplicate) Duplicate words were found", style: .danger)
            banner.show(queuePosition: .front, bannerPosition: .top, cornerRadius: 15)
            return
        }
       
       
        
        
    }
    
    private func showDuplicateBanner()
    {
        let banner = FloatingNotificationBanner(title: "Duplicate", subtitle: "This category already exists!", style: .danger)
        banner.show(queuePosition: .front, bannerPosition: .top, cornerRadius: 15)
    }
}
