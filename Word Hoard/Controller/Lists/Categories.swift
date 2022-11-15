import UIKit
import Lottie


class CollectionViewController: UIViewController
{
    var categories = [Category]()
    @IBOutlet var animationView: AnimationView?
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addNewCollection(_ sender: Any)
    {
        AddCollectionViewController.showPopup(parentVC: self)
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
    }
    
    fileprivate func startLottieAnimation()
    {
        animationView?.play()
        animationView?.backgroundColor = .clear
        animationView?.loopMode = .loop
    }
    
    private func loadAllCollections()
    {
        categories = CoreDataManager.sharedManager.getAllCategories()
        determineIfTableViewShouldbeHidden()
        self.tableView.reloadData()
    }
    
    fileprivate func determineIfTableViewShouldbeHidden()
    {
        if categories.isEmpty
        {
            tableView.isHidden = true
        }
        else
        {
            self.tableView.isHidden = false
        }
    }
    
    
}
 
//MARK: - UITABLE View Delgate Functions
extension CollectionViewController: UITableViewDelegate
{
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

//MARK: - UITABLE View Datasource Functions
extension CollectionViewController: UITableViewDataSource
{
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
}


//MARK: - Notification Canter
extension CollectionViewController
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
                
            }
            
        }
    }
   
}
