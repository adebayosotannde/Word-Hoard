//
//  ViewController.swift
//  TikTokFeed
//
//  Created by Adebayo Sotannde on 10/25/22.
//

import UIKit
import Lottie

class HomeViewController: UIViewController
{
    var itemList: [Item] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadCategorieFromUserDefault()
        setupFeed()
        registerNotificationCenter()
        
        //
       
        let array = CoreDataManager.sharedManager.retriveAllItems()
        

        
    }
    
    @IBAction func chekMispelledWord(_ sender: Any)
    {
        
        
//        let word = "aquire"
//
//        let textChecker = UITextChecker()
//        let rande = NSRange(location: 0, length: word.count)
//    let guesses = textChecker.guesses(forWordRange: rande, in: word, language: "en_US")
//
//        print(guesses)
                       
        
        
    }
    
  private func loadCategorieFromUserDefault()
    {
        do
        {
            //Refrence to the User default.
            let defaults = UserDefaults.standard
            let catergryName = defaults.string(forKey: userDefaultString.selectedCategoryToDisplay)
            
         
            //Loop through all categories and find the category with the caregorie name from user defaules
            for category in CoreDataManager.sharedManager.getAllCategories()
            {
                if category.name == catergryName
                {

                    //Category has been found
                    itemList = CoreDataManager.sharedManager.loadItems(selectedCategory: category).shuffled()
                    tableView.setContentOffset(.zero, animated: true) //Scroll to the top of the table view.
                    tableView.reloadData()
                   return 
                }
            }

            

        }
        
        //Category was not found in the user defaults. Table view will handle the
        print("Categorie was not found in user default")
        #warning("Dont forget to switch up the defulat list given to the user. if no list is seelected")
      
       
    }
    
    private func setupFeed()
    {
        tableView.isPagingEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
 
    
}

//MARK: - Table View DataSource Function
extension HomeViewController:  UITableViewDataSource
{
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if itemList.count == 0
        {
            return  DummyData.defaultList.count
        }
        return itemList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
       
        if itemList.count == 0
        {
            cell.configureWithDafaultList(with: DummyData.defaultList[indexPath.row])
           
        }else
        {
            cell.word.text = itemList[indexPath.row].word!.uppercased()
            let secondLine  = itemList[indexPath.row].partofspeech! + " " +  itemList[indexPath.row].defenition!
            cell.defenition.text = secondLine
            cell.example.text = itemList[indexPath.row].example
        }
    
        return cell
    }
    
    
}

extension HomeViewController:  UITableViewDelegate
{
    //Height for the table view.
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UIScreen.main.bounds.size.height
    }
}

//MARK: - Notification Canter
extension HomeViewController
{
    
    fileprivate func registerNotificationCenter()
    {
        //Obsereves the Notification
        NotificationCenter.default.addObserver(self, selector: #selector(doWhenNotified(_:)), name: Notification.Name(NotificationString.notificationKey), object: nil)
    }
   

    @objc fileprivate func doWhenNotified(_ notiofication: NSNotification)
    {
        if let dict = notiofication.userInfo as NSDictionary?
        {
            if (dict[NotificationString.updateMainUIList] as? String) != nil
            {
                loadCategorieFromUserDefault()
            }
            
            if (dict[UserInterfaceNotfications.showWebDefinition] as? String) != nil
            {
                if let wordRecived = notiofication.userInfo?[UserInterfaceNotfications.showWebDefinition] as? String
                {
                    showDictionaryUI(wordToShow: wordRecived)
                }
                
            }
            
            
            
            
        }
    }
    
    fileprivate func showDictionaryUI(wordToShow: String)
    {
 
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: wordToShow)
        {
            let ref: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: wordToShow)
            self.present(ref, animated: true, completion: nil)
        }
        
    }
    
}

