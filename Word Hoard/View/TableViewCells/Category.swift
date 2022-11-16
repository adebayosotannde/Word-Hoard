//
//  CollectionTableViewCell.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/27/22.
//

import UIKit

class CategorieTableViewCell: UITableViewCell
{
    static let identifer = "CollectionTableViewCell"
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var count: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    public func configure(with item: Category)
    {
        name.text = item.name
        let counter = (item.items?.count)!
        if counter == 1
        {
            self.count.text = "\(counter) word"
        }else
        {
            self.count.text = "\(counter) words"
        }
        
        
//        if let categoryName = item.name
//        {
//            //Set name
//            name.text = categoryName
//
//            if let category = CoreDataManager.sharedManager.reetriveCategoriefromString(categoryName: categoryName)
//            {
//                let allWords = CoreDataManager.sharedManager.loadItems(selectedCategory: category)
//                let count = allWords.count
//                self.count.text = "\(count) words"
//            }
//
//
//        }else
//        {
//            name.text = "ERROR"
//            name.textColor = .red
//            self.count.text = "ERROR"
//            self.count.textColor = .red
//
//        }
//
//
//
       
    }

}
