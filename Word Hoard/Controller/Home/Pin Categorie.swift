//
//  Select Categorie.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/29/22.
//

import UIKit
import Lottie

@MainActor
class PinCategorieViewController: UIViewController
{
    var categories = [Category]()
    
    @IBOutlet var animationView: AnimationView?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        startLottieAnimation()
        loadAllCollections()
        determineIfTableViewShouldbeHidden()
        
    }
  
    
    
   
    
  
}

//MARK: - SETUP
extension PinCategorieViewController
{
    fileprivate func startLottieAnimation()
    {
        animationView?.play()
        animationView?.backgroundColor = .clear
        animationView?.loopMode = .loop
    }

    private func loadAllCollections()
    {
        categories = CoreDataManager.sharedManager.getAllCategories()
       
        
    }
    
    fileprivate func determineIfTableViewShouldbeHidden()
    {
        if categories.isEmpty
        {
            //hide the table view becuase the collectionview is empty
            tableView.isHidden = true
        }
        else
        {
            tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
}

//MARK: -  UITABLE VIEW DELGATE AND DATA-SOURCE FUNCTIONS
extension PinCategorieViewController: UITableViewDataSource, UITableViewDelegate
{
    //DATA-SOURCE
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  tableView.dequeueReusableCell(withIdentifier: CategorieTableViewCell.identifer, for: indexPath) as! CategorieTableViewCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    //DELGATE FUNCTIONS
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let defaults = UserDefaults.standard
        defaults.set(categories[indexPath.row].name, forKey: UserDefualtManager.pinnedCategorie)
        
        postBarcodeNotification(code: NotificationString.updateMainUIList)
        dismiss(animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return TableViewCellValues.heightForTableViewCells
    }
}



//MARK: - Notification Canter
extension PinCategorieViewController
{
    private func postBarcodeNotification(code: String)
    {
        var info = [String: String]()
        info[code.description] = code.description //post the notification with the key.
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationString.notificationKey), object: nil, userInfo: info)
    }
}
