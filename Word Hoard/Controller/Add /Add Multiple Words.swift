//
//  Multiple Add.swift
//  Pods
//
//  Created by Adebayo Sotannde on 10/30/22.
//

import UIKit

class AddMultipleItemsViewController: UIViewController
{
    static let identifier = "AddMultipleItemsViewController"
    
    var selectedCategory : Category?
    
    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textViewForClass: UITextView!
    
    var stringArray:[String] = []
    @IBAction func okButtonPressed(_ sender: Any)
    {
        retriveTextForData()
    }
    
    private func retriveTextForData()
    {
        let text = textViewForClass.text
        
        textViewForClass.layoutManager.enumerateLineFragments(forGlyphRange: NSRange(location: 0, length: text!.count))
        { [self] (rect, usedRect, textContainer, glyphRange, stop) in
            
            let characterRange = textViewForClass.layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            let line = (textViewForClass.text as NSString).substring(with: characterRange)
            stringArray.append(line)
            
        }
        
        let unique = Array(Set(stringArray).sorted()) //Remove extra words added to the string array from the uitextview
        stringArray = unique
        
        AddWordstoDictionary()
        
    }
    
    @discardableResult
    private func AddWordstoDictionary()->Bool
    {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        okButton.isHidden = true
        
        var newArray:[String] = []
        for item in stringArray
        {
            let wordToAddToDictionary = item.trimmingCharacters(in: ["\n"])
            newArray.append(wordToAddToDictionary)
        }
        newArray = Array(Set(newArray)) //remove posibility of duplicate words in the array 
        if let category = selectedCategory
        {
            CoreDataManager.sharedManager.requestDataforSingleWord(nameOfWord: newArray, category: category)
            
            
            self.dismiss(animated: true)
            return true
        }
        
        self.dismiss(animated: true)
        return false
    }
    
    
    //MARK:- Display this Pop up
    static func showView(parentVC: UIViewController, selectedCategory: Category)
    {
        //creating a reference for the dialogView controller
        if let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AddMultipleItemsViewController.identifier) as? AddMultipleItemsViewController
        {
            popupViewController.selectedCategory = selectedCategory
            popupViewController.modalPresentationStyle = .pageSheet
            popupViewController.modalTransitionStyle = .crossDissolve
            parentVC.present(popupViewController, animated: true)
            
            
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
    
}
