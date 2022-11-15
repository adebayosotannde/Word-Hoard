//
//  Words.swift
//  Learner
//
//  Created by Adebayo Sotannde on 11/5/22.
//

import UIKit

class WordReviewTableViewCell: UITableViewCell
{

    static let identifer = "WordReviewTableViewCell"
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var strength: UILabel!
    
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
