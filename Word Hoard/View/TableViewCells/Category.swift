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
        if let countValue = item.items?.count
        {
            count.text = "\(countValue) words"
        }
    }

}
