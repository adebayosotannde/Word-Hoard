import UIKit
import Lottie


class CategorieViewController: UIViewController
{
    var categories = [Category]()
    
    @IBOutlet var animationView: AnimationView?
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addNewCollection(_ sender: Any)
    {
        AddCategorieViewController.showPopup(parentVC: self)
    }
    
    @IBAction func dismissViewButton(_ sender: Any)
    {
       
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        registerNotificationCenter()
        startLottieAnimation()
        loadAllCollections()
        determineIfTableViewShouldbeHidden()
    }

}

//MARK: - SETUP
extension CategorieViewController
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
 
//MARK: - UITABLE VIEW DELGATE AND DATA-SOURCE FUNCTIONS
extension CategorieViewController: UITableViewDataSource, UITableViewDelegate
{
    //DATA-SOURCE
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  tableView.dequeueReusableCell(withIdentifier: CategorieTableViewCell.identifer, for: indexPath) as! CategorieTableViewCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    //DELGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let wordlistvc = storyBoard.instantiateViewController(withIdentifier: "WordsViewControler") as! WordsViewControler
        wordlistvc.selectedCategory = categories[indexPath.row]
        wordlistvc.modalPresentationStyle = .popover
        navigationController?.pushViewController(wordlistvc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return TableViewCellValues.heightForTableViewCells
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            CoreDataManager.sharedManager.requestToDeleteCategory(category: categories[indexPath.row])
           loadAllCollections()
        }
    }
}



//MARK: - NOTIFICATION CENTER
extension CategorieViewController
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
            if (dict[NotificationString.updateCollectionVC] as? String) != nil
            {
                loadAllCollections()
                determineIfTableViewShouldbeHidden()

            }
            
        }
    }
   
}
