//
//  WordAlternative.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/31/22.
//

import UIKit

struct WordAlternative
{
    var name: String
    var type: WordType
    var defineition: String
    var example: String
}


enum WordType: String
{
    case ajdective = "(adjective)"
    case noun = "(noun)"
    case verb = "(verb)"
}


