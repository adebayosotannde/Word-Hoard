//
//  Multiple Add.swift
//  Pods
//
//  Created by Adebayo Sotannde on 10/30/22.
//

import UIKit

class AddMultipleWordsViewController: UIViewController
{
    static let identifier = "AddMultipleWordsViewController"
    
    var selectedCategory : Category?
    
    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var uiTextView: UITextView!

    @IBAction func okButtonPressed(_ sender: Any)
    {
        //Immediately display and animate the activity indicator
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        //Prevent the user from leaving the view
        okButton.isHidden = true
        
        //Proceed to process the data
        retriveTextForData() //Proceed to process the data from the textView
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
}

//MARK: -  DATA PROCESSING AND VALIDATION
extension   AddMultipleWordsViewController
{
    private func retriveTextForData()
    {
        var temporaryArray: [String] = []
        let text = uiTextView.text //Step 1: Retrive all the words from the text view
        
        //Step 2: This acts as a for loop and process each line
        uiTextView.layoutManager.enumerateLineFragments(forGlyphRange: NSRange(location: 0, length: text!.count))
        { [self] (rect, usedRect, textContainer, glyphRange, stop) in
            
            let characterRange = uiTextView.layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            let line = (uiTextView.text as NSString).substring(with: characterRange)
           
            let processedLine = line.trimmingCharacters(in: ["\n"]) //Step 3: Remove \n (new line) text from the line
        
            temporaryArray.append(processedLine) //Step 4: Append the line to the array
            
        }
        let temp  = Array(Set(temporaryArray.sorted())) //Step 5: Remove extra words added to the string array from the uitextview
        AddWordstoDictionary(array: temp)
    }
    
    @discardableResult
    private func AddWordstoDictionary(array: [String])->Bool
    {
        if let category = selectedCategory
        {
            CoreDataManager.sharedManager.requestDataforSingleWord(nameOfWord: array, category: category)
            self.dismiss(animated: true)
            return true
        }
        
        self.dismiss(animated: true)
        return false
    }
}


//MARK: - FUNCTION TO DISPLAY THE VIEW
extension AddMultipleWordsViewController
{
    static func showView(parentVC: UIViewController, selectedCategory: Category)
    {
        //creating a reference for the dialogView controller
        if let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AddMultipleWordsViewController.identifier) as? AddMultipleWordsViewController
        {
            popupViewController.selectedCategory = selectedCategory
            popupViewController.modalPresentationStyle = .pageSheet
            popupViewController.modalTransitionStyle = .crossDissolve
            parentVC.present(popupViewController, animated: true)
        }
    }
}
