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
class AddCategorieViewController: UIViewController, UITextFieldDelegate
{
    static let identifier = "AddCategorieViewController"
    
    //IBOUTLETS
    @IBOutlet weak var dialogBoxView: UIView!
    @IBOutlet weak var textFiled: UITextField!
    
    @IBAction func addCategory(_ sender: Any)
    {
        validateData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dimBackground()
        customizeDialogBox()
        registerTextFieldDelgate()
        setFirstResponder()
        
       
    }

}

//MARK: - TOUCH EVENTS FUNCTIO(S)
extension AddCategorieViewController
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if touch?.view != self.dialogBoxView
        { self.dismissView()}
    }
}
//MARK: - FUNCTIONS TO VALIDATE DATA AND ADD A NEW CATEGORIE
extension AddCategorieViewController
{
    private func createNewCategoryEntry(categorieName: String)
    {
            CoreDataManager.sharedManager.addnewCategory(categorieName: categorieName)
    }
    
    private func validateData()
    {
        if let collectionText = textFiled.text
        {
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
            
            if collectionText.count != 0 && collectionText.count < 30
            {
                createNewCategoryEntry(categorieName: collectionText)
                dismissView()
                return
            }
        }
    }
    
    
}


//MARK: - UITextViewDelegate and Functions
extension AddCategorieViewController: UITextViewDelegate
{
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        validateData()
        return true
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

//MARK: - Banner Messages
extension AddCategorieViewController
{
    private func  showZeroCountBanner()
    {
        let banner = FloatingNotificationBanner(title: "Invlaid", subtitle: "Collection name cannot be empty!", style: .danger)
        banner.show(bannerPosition: .bottom, cornerRadius: 15)
    }

    private func showErrorBanner()
    {
        let banner = FloatingNotificationBanner(title: "Error", subtitle: "Text cannot exceed 30 characters", style: .danger)
        banner.show(bannerPosition: .bottom, cornerRadius: 15)
    }
}

//MARK: - POP UP FUNCTIONS and UI FUNCTIONS
extension AddCategorieViewController
{
    static func showPopup(parentVC: UIViewController)
    {
        //creating a reference for the dialogView controller
        if let popupViewController = UIStoryboard(name: "CustomView", bundle: nil).instantiateViewController(withIdentifier: AddCategorieViewController.identifier) as? AddCategorieViewController {
            popupViewController.modalPresentationStyle = .custom
            popupViewController.modalTransitionStyle = .crossDissolve

            //presenting the pop up viewController from the parent viewController
            parentVC.present(popupViewController, animated: true)
        }
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
    
    
    private func dismissView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}


