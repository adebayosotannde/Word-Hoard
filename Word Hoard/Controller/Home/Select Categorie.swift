//
//  Select Categorie.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/29/22.
//

import UIKit
import Lottie

@MainActor
class SelectCategorieViewController: UIViewController
{
    var categories = [Category]()
    
    
    @IBOutlet var animationView: AnimationView?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadAllCollections()
        determineIfTableViewShouldbeHidden()
        startLottieAnimation()
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
    
    fileprivate func startLottieAnimation()
    {
        animationView?.play()
        animationView?.backgroundColor = .clear
        animationView?.loopMode = .loop
    }

}

//MARK: - UITABLE View Datasource Functions
extension SelectCategorieViewController: UITableViewDataSource
{
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
}

//MARK: - UITABLE View Delgate Functions
extension SelectCategorieViewController: UITableViewDelegate
{
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let defaults = UserDefaults.standard
        defaults.set(categories[indexPath.row].name, forKey: UserDefualtManager.selectedCategoryToDisplay)
        
        postBarcodeNotification(code: NotificationString.updateMainUIList)
        dismiss(animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return TableViewCellValues.heightForTableViewCells
    }
}

//MARK: - Notification Canter
extension SelectCategorieViewController
{
    private func postBarcodeNotification(code: String)
    {
        var info = [String: String]()
        info[code.description] = code.description //post the notification with the key.
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationString.notificationKey), object: nil, userInfo: info)
    }
}
