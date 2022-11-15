//
//  WordStructure.swift
//  TikTokFeed
//
//  Created by Adebayo Sotannde on 10/27/22.
//

import Foundation

struct Word: Codable
{
    let word: String?
    let phonetics: [Phonetics?]
    let meanings: [Meaning?]
    
    enum CodingKeys: String, CodingKey
    {
        case word = "word"
        case phonetics = "phonetics"
        case meanings = "meanings"
        
    }
}

struct Phonetics: Codable
{
    let audio: String?
    
    enum CodingKeys: String, CodingKey
    {
        case audio = "audio"
    }
}

struct Meaning: Codable
{
    let partOfSpeech: String?
    let definitions: [Definitions?]
    let synonyms: [String?]
    let antonyms: [String?]
    
    
    enum CodingKeys: String, CodingKey
    {
        case partOfSpeech = "partOfSpeech"
        case definitions = "definitions"
        case synonyms = "synonyms"
        case antonyms = "antonyms"
        
    }
}

struct Definitions: Codable
{
    let definition: String?
    let synonyms: [String?]
    let antonyms: [String?]
    let example: String?
    
    enum CodingKeys: String, CodingKey
    {
        case definition = "definition"
        case synonyms = "synonyms"
        case antonyms = "antonyms"
        case example = "example"
        
    }
}


