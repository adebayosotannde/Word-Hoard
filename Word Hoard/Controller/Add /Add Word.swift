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
    
    @IBOutlet weak var textEditField: UITextView!
    
    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var userInputSwitch: UISwitch!
    
    @IBAction func switchButtoninitiated(_ sender: Any)
    {
        if userInputSwitch.isOn
        {
            textFieldHeight.constant = 200
            textFiled.autocorrectionType = .no //disable corrections to allow for custom words to be used
        }else
        {
            textFieldHeight.constant = 0
            textFiled.autocorrectionType = .yes
        }
    }
    
    @IBAction func okButtonPressed(_ sender: Any)
    {
        
        
        initiateAddWordSequence()
        print("Done")
       
    }
    
    func initiateAddWordSequence()
    {
        if isValidInput()
        {
            print("Valid input")
            
            if userInputSwitch.isOn
            {
                //validate text edit box for defenition
                if isValidDefenition()
                {
                    
                    
                    if let word = textFiled.text
                    {
                        if let defentition = textEditField.text
                        {
                          
                            print("Word \(word)")
                            print("Defention \(defentition)")
                            
                            //Create a new word in the category
                            
                            if CoreDataManager.sharedManager.wordAlreadyExistInCategory(name: word, selectedCategory: selectedCategory!)
                            {
                                print("error this word already exists")
                                showDuplicateBanner()
                            }
                            else
                            {
                                CoreDataManager.sharedManager.createWordEntry(word: word, partOfSpeech: "", wordExample: "", definition: defentition, category: selectedCategory!)
                            }
                            
                        }
                    }
                    
            
                    
                    
                }
            }
            else
            {
                
               
                if let wordfromTextfiled = textFiled.text
                {
                    createnewWordEntry(wordName: wordfromTextfiled)
                }
            }
        }
        else
        {
            print("invalid input")
        }
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
        if touch?.view != (self.dialogBoxView) // Dismiss if a touch is detected outside the dialog box
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
        textFieldHeight.constant = 0  //hide edittextbox
        
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
        initiateAddWordSequence()
        return true
    }
}

//MARK: - Data entry and validation
extension AddWordViewControler
{
    private func isValidInput()->Bool
    {
        if let wordfromTextfiled = textFiled.text
        {
            
            if wordfromTextfiled.count == 0
            {
                showZeroCountBanner()
                dismissView()
                return false
                
            }
            if wordfromTextfiled.count > 20
            {
                showErrorBanner()
                dismissView()
                return false
                
            }
            
            
            if wordfromTextfiled.count != 0 && wordfromTextfiled.count < 31
            {
                dismissView()
                return true
            }
        }
        return false
    }
    
    private func isValidDefenition()->Bool
    {
        if let wordfromTextfiled = textFiled.text
        {
            
            if wordfromTextfiled.count == 0
            {
                showZeroCountBanner()
                dismissView()
                return false
                
            }
            if wordfromTextfiled.count < 300
            {
                dismissView()
                return true
            }
        }
        return false
    }
    
    private func createnewWordEntry(wordName: String)
    {
        
        if selectedCategory != nil
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
