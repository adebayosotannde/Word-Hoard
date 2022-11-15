//
//  AddCollectionViewController.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/28/22.
//

import UIKit
import NotificationBannerSwift
import UIKit
import CoreData

@MainActor
class AddCollectionViewController: UIViewController, UITextFieldDelegate
{
    static let identifier = "AddCollectionViewController"
    
    //IBOUTLETS
    @IBOutlet weak var dialogBoxView: UIView!
 
    @IBOutlet weak var textFiled: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
       
    }
    
    @IBAction func addCategory(_ sender: Any)
    {
        validateData()
    }
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if touch?.view != self.dialogBoxView
        { self.dismissView()}
    }
    
    //MARK:- Display this Pop up
    static func showPopup(parentVC: UIViewController)
    {

        //creating a reference for the dialogView controller
        if let popupViewController = UIStoryboard(name: "CustomView", bundle: nil).instantiateViewController(withIdentifier: AddCollectionViewController.identifier) as? AddCollectionViewController {
            popupViewController.modalPresentationStyle = .custom
            popupViewController.modalTransitionStyle = .crossDissolve

            //presenting the pop up viewController from the parent viewController
            parentVC.present(popupViewController, animated: true)
        }
    }
    
    private func validateData()
    {
        if let collectionText = textFiled.text
        {
            
            if collectionText.count != 0 && collectionText.count < 30
            {

                createNewCategoryEntry(categorieName: collectionText)
                dismissView()
                return
            }
            if collectionText.count == 0
            {
                showZeroCountBanner()
                dismissView()
                return()
            }
            
            if collectionText.count > 30
            {
                showErrorBanner()
                dismissView()
                return
                
            }
            
            
        }
        
    }
}


//MARK: - Setup Functions
extension AddCollectionViewController
{
    fileprivate func setup()
    {
        dimBackground()
        customizeDialogBox()
        registerTextFieldDelgate()
        setFirstResponder()
    }
    
    fileprivate func dimBackground()
    {
        //adding an overlay to the view to give focus to the dialog box
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    fileprivate func  customizeDialogBox()
    {
        dialogBoxView.layer.cornerRadius = 20
        dialogBoxView.layer.borderColor = UIColor.black.cgColor
    }
    
    fileprivate func registerTextFieldDelgate()
    {
        self.textFiled.delegate = self
    }
    
    fileprivate func setFirstResponder()
    {
        textFiled.becomeFirstResponder()
    }
    
}

//MARK: - UITextViewDelegate
extension AddCollectionViewController: UITextViewDelegate
{
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        validateData()
        return true
    }
}

//MARK: - Banner Messages
extension AddCollectionViewController
{
    
    private func  showZeroCountBanner()
    {
        let banner = FloatingNotificationBanner(title: "Invlaid", subtitle: "Collection name cannot be empty!", style: .danger)
        banner.show(bannerPosition: .bottom, cornerRadius: 15)
    }
    
    private func showErrorBanner()
    {
        let banner = FloatingNotificationBanner(title: "Error", subtitle: "Text cannot excced 30 characters", style: .danger)
        banner.show(bannerPosition: .bottom, cornerRadius: 15)
    }
    
   
    
    

}

class BannerClass
{
    
}

//MARK: - Other Functions
extension AddCollectionViewController
{
    private func dismissView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func createNewCategoryEntry(categorieName: String)
    {
       
            CoreDataManager.sharedManager.addnewCategory(categorieName: categorieName)
        
    }
}


