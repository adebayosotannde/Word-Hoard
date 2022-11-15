//
//  Add Word.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/29/22.
//

import UIKit
import NotificationBannerSwift
import CoreData

class AddWordViewControler: UIViewController
{
    static let identifier = "AddWordViewControler"
    
    var selectedCategory : Category?
    
    @IBOutlet weak var dialogBoxView: UIView!
    @IBOutlet weak var OkButton: UIButton!
    @IBOutlet weak var textFiled: UITextField!
    
    @IBAction func okButtonPressed(_ sender: Any)
    {
        validateData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
    }
    
    //MARK:- Display this Pop up
    static func showPopup(parentVC: UIViewController, selectedCategory: Category)
    {

        if let popupViewController = UIStoryboard(name: "CustomView", bundle: nil).instantiateViewController(withIdentifier: AddWordViewControler.identifier) as? AddWordViewControler
        {
            popupViewController.selectedCategory = selectedCategory
            popupViewController.modalPresentationStyle = .custom
            popupViewController.modalTransitionStyle = .crossDissolve
            parentVC.present(popupViewController, animated: true)
        }

    }
    
    //Tap the backround to dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if touch?.view != self.dialogBoxView// Dismiss if a touch is detected outside the dialog box
        { self.dismissView()}
    }
    
}

extension AddWordViewControler: UITextFieldDelegate
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
    
    
    private func dismissView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UITextViewDelegate
extension AddWordViewControler: UITextViewDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        validateData()
        return true
    }
}

//MARK: - Data entry and validation
extension AddWordViewControler
{
    private func validateData()
    {
        if let wordfromTextfiled = textFiled.text
        {
            
            if wordfromTextfiled.count != 0 && wordfromTextfiled.count < 31
            {
                createnewWordEntry(wordName: wordfromTextfiled)
                dismissView()
                return
            }
            if wordfromTextfiled.count == 0
            {
                showZeroCountBanner()
                dismissView()
                return
                
            }
            if wordfromTextfiled.count > 20
            {
                showErrorBanner()
                dismissView()
                return
                
            }
        }
        
    }
    
    private func createnewWordEntry(wordName: String)
    {
        
        if let category = selectedCategory
        {
            CoreDataManager.sharedManager.requestDataforSingleWord(nameOfWord: [wordName], category: self.selectedCategory!)
        }
    }
}

//MARK: - Banner Messages
extension AddWordViewControler{
    
    //MARK: - Banner Messages
    private func  showZeroCountBanner()
    {
        let banner = FloatingNotificationBanner(title: "Invlaid", subtitle: "Word name cannot be empty!", style: .danger)
        banner.show(queuePosition: .front, bannerPosition: .top, cornerRadius: 15)
    }
    
  
    private func showErrorBanner()
    {
        let banner = FloatingNotificationBanner(title: "Error", subtitle: "Text cannot excced 30 characters", style: .danger)
        
        banner.show(queuePosition: .front, bannerPosition: .top, cornerRadius: 15)
    }
    
    private func showDuplicateBanner()
    {
        let banner = FloatingNotificationBanner(title: "Duplicate", subtitle: "This word already exist", style: .danger)
        banner.show(queuePosition: .front, bannerPosition: .top, cornerRadius: 15)
    }
    
   
}
