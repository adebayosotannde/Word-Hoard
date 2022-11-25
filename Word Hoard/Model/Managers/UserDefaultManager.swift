//
//  UserDefaultManager.swift
//  Word Hoard
//
//  Created by Adebayo Sotannde on 11/15/22.
//

import Foundation

class UserDefualtManager
{
    
    static let sharedManager = UserDefualtManager() //Create Instance of Persistance Contaner
    private init() {} // Prevent clients from creating another instance.
    
    
    static let pinnedCategorie = "selectedCategory"
    
    
    
    func retirveWords()
    {
        //Refrence to the User default.
        let defaults = UserDefaults.standard
        let catergoryName = defaults.string(forKey: UserDefualtManager.pinnedCategorie)
        
        var wordList: [Item]  = []
        do
        {
           
         
            //Loop through all categories and find the category with the caregorie name from user defaules
            for category in CoreDataManager.sharedManager.getAllCategories()
            {
                if category.name == catergoryName
                {

                    //Category has been found
                   
                    wordList = CoreDataManager.sharedManager.loadItems(selectedCategory: category).shuffled()
                    
                    if wordList.count == 0
                    {
                        print("There are zero items in the this categorie")
                    }else
                    {
                       
                       return
                    }
                    
                }
            }

            

        }
        
        //Category was not found in the user defaults. Table view will handle the
        print("Categorie was not found in user default")
        #warning("Dont forget to switch up the defulat list given to the user. if no list is seelected")
      
       
    }
}
