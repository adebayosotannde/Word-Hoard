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
        setupFeed()
        registerNotificationCenter()
        loadCategorieFromUserDefault()
        
    }
    
    
    //IBACTIONS
    @IBAction func purchasePremiumButton(_ sender: Any)
    {
        if let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseViewController") as? PurchaseViewController
        {
            popupViewController.modalPresentationStyle = .formSheet
            popupViewController.modalTransitionStyle = .coverVertical
            present(popupViewController, animated: true)
        }
    }
    
}

//MARK: - SETUP
extension HomeViewController
{
    /**
     Loads the reqired categorie to be populated to the user.
     */
    fileprivate func loadCategorieFromUserDefault()
    {
        do
        {
            //Refrence to the User default.
            let defaults = UserDefaults.standard
            
            if let catergoryName = defaults.string(forKey: UserDefualtManager.pinnedCategorie)
            {
                if let retrivedCategory = CoreDataManager.sharedManager.retriveCategoriefromString(categoryName: catergoryName)
                {
                    //Populate the itemlist
                    itemList = CoreDataManager.sharedManager.loadItems(selectedCategory: retrivedCategory).shuffled()
 
                    if itemList.count == 0
                    {
                        print("There are zero items in the this categorie")
                        //NOTE: Table View Datasource function will display the dummy data.
                        
                    }else
                    {
                        tableView.setContentOffset(.zero, animated: true) //Scroll to the top of the table view.
                        tableView.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    /**
     Give the View a TIK-TOK style scroll effect.
     */
    fileprivate func setupFeed()
    {
        tableView.isPagingEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
}

//MARK: -  UITABLE VIEW DELGATE AND DATA-SOURCE FUNCTIONS
extension HomeViewController:  UITableViewDataSource, UITableViewDelegate
{
    //DATA-SOURCE
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
            cell.configureWithItem(item: itemList[indexPath.row])
        }
        
        return cell
    }
    
    //DELGATE
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UIScreen.main.bounds.size.height
    }
    
    
    
    //
    
    
    
#warning("Implement this function")
    
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
//    {
//        print("Cell Currently Displayed is \(indexPath.row) with word \(itemList[indexPath.row].word!)")
//
//        numberOFItemsLeft(currentIndex: indexPath.row)
//        }
//
//    func numberOFItemsLeft(currentIndex: Int)->Int
//    {
//        var numberOFItems = itemList.count - 1
//        var itemsLeft =  numberOFItems - currentIndex
//
//        if itemsLeft < 10
//        {
//
//        itemList = itemList + itemList
//            tableView.reloadData()
//            print("Fetching more words and appending them to the array")
//        }
//
//
//        print("There are \(itemsLeft) words Left to display ")
//        return itemsLeft
//    }
}

//MARK: - NOTIFICATION CENTER
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
    
    
    
}

//MARK: - DICTIONARY USER INTERFACE
extension HomeViewController
{
    fileprivate func showDictionaryUI(wordToShow: String)
    {
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: wordToShow)
        {
            
            let ref: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: wordToShow)
            self.present(ref, animated: true, completion: nil)
        }
        else
        {
            
        }
        
    }
}


