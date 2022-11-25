//
//  Premium Word Definition.swift
//  Word Hoard
//
//  Created by Adebayo Sotannde on 11/23/22.
//



// MARK: - PremiumWordDefinition
struct PremiumWordDefinition: Codable {
    let word: String
    let results: [Result]
    let syllables: Syllables
    let pronunciation: Pronunciation
    let frequency: Double
}

// MARK: - Pronunciation
struct Pronunciation: Codable {
    let all: String
}

// MARK: - Result
struct Result: Codable {
    let definition, partOfSpeech: String
    let synonyms, typeOf, hasTypes: [String]
    let partOf, examples, hasParts: [String]?
}

// MARK: - Syllables
struct Syllables: Codable {
    let count: Int
    let list: [String]
}
