//
//  WordTableViewCell.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/29/22.
//

import UIKit

class WordTableViewCell: UITableViewCell
{

    static let identifer = "WordTableViewCell"
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        //Disable Highleted Cell Selection Animation
        self.selectionStyle = .none
    }
    
    public func configure(with item: Item)
    {
        name.text = item.word
    }

}
