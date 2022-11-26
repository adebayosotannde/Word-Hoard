//
//  Word List.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/29/22.
//

import UIKit
import CoreData
import Lottie

class WordsViewControler: UIViewController
{
    static let identifier = "WordsViewControler"
    var itemArray = [Item]()
    
    var selectedCategory : Category?
    {
        didSet
        {
            itemArray = CoreDataManager.sharedManager.loadItems(selectedCategory: selectedCategory!)
        }
      
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var animationView: AnimationView?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        registerNotificationCenter()
        startLottieAnimation()
        determineIfTableViewShouldbeHidden()
    }

    @IBAction func mulilineRequest(_ sender: Any)
    {
        if let categoryToPass = selectedCategory
        {
            AddMultipleWordsViewController.showView(parentVC: self, selectedCategory: categoryToPass)
        }
    }
    
    @IBAction func addNewCollection(_ sender: Any)
    {
        if let caregoryToPass = selectedCategory
        {
            AddWordViewControler.showPopup(parentVC: self, selectedCategory: caregoryToPass)
        }
    }
    
   
}

//MARK: - SETUP
extension WordsViewControler
{
    fileprivate func startLottieAnimation()
    {
        animationView?.play()
        animationView?.backgroundColor = .clear
        animationView?.loopMode = .loop
    }
    
    fileprivate func reloadData()
    {
        itemArray = CoreDataManager.sharedManager.loadItems(selectedCategory: selectedCategory!)
        determineIfTableViewShouldbeHidden()
        tableView.reloadData()
    }
   
    fileprivate func determineIfTableViewShouldbeHidden()
    {
        if itemArray.isEmpty
        {
            //hide the table view becuase the collectionview is empty
            tableView.isHidden = true
        }
        else
        {
            tableView.isHidden = false
        }
    }
    
}

//MARK: -  UITABLE VIEW DELGATE AND DATA-SOURCE FUNCTIONS
extension WordsViewControler: UITableViewDataSource, UITableViewDelegate
{
    //DATA-SOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  tableView.dequeueReusableCell(withIdentifier: WordTableViewCell.identifer, for: indexPath) as! WordTableViewCell
        cell.configure(with: itemArray[indexPath.row])
        return cell
    }
    
    //DELGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return TableViewCellValues.heightForTableViewCells
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            CoreDataManager.sharedManager.requestToDeleteWord(specificWord: itemArray[indexPath.row])
            reloadData()
        }
    }
}



    


//MARK: - Notification Canter
extension WordsViewControler
{
    private func registerNotificationCenter()
    {
    //Obsereves the Notification
    NotificationCenter.default.addObserver(self, selector: #selector(doWhenNotified(_:)), name: Notification.Name(NotificationString.notificationKey), object: nil)
    }
    

    @objc func doWhenNotified(_ notiofication: NSNotification)
    {

        if let dict = notiofication.userInfo as NSDictionary?
        {
            if (dict[NotificationString.updateWordVC] as? String) != nil
            {
    
                reloadData()
            }
            
        }
    }
    
    
    
    
}
