//
//  TableViewCell.swift
//  TikTokFeed
//
//  Created by Adebayo Sotannde on 10/25/22.
//

import UIKit
import AVFoundation
import Foundation
class HomeTableViewCell: UITableViewCell, AVSpeechSynthesizerDelegate
{
    static let identifier = "homeTableViewCell"
    var synthesizer = AVSpeechSynthesizer()
    var partOfSpeech:String? = ""
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var defenition: UILabel!
    @IBOutlet weak var example: UILabel!
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        setupTapGesture() //Setup Tap Gesture
        //Disable Highleted Cell Selection Animation
        self.selectionStyle = .none
    }
    
    public func configureWithDafaultList(with wordToConfigureWith: WordAlternative)
    {
        partOfSpeech = wordToConfigureWith.type.rawValue
        word.text = wordToConfigureWith.name.uppercased()
        let secondLine  = wordToConfigureWith.type.rawValue + " " +   wordToConfigureWith.defineition
        defenition.text = secondLine
        example.text = wordToConfigureWith.example
    }
    
    public func configureWithUserList(with wordToConfigureWith: Item)
    {
        word.text = wordToConfigureWith.word?.uppercased()
        if let partOfSpeech = wordToConfigureWith.partofspeech, let def = wordToConfigureWith.defenition
        {
            self.partOfSpeech = partOfSpeech
            let secondLine  = partOfSpeech + " " +   def
            defenition.text = secondLine
        }
        example.text = wordToConfigureWith.example
    }
   func setupTapGesture()
    {
        let singleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.handleSingleTap(sender:)))
        singleTap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTap)
        
        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
    }
    
    @objc func handleSingleTap(sender: AnyObject?)
    {
        print("Single Tap")
    }
    
    @objc func handleDoubleTap()
    {
        print("Double Tap!")
    }
    
    
    @IBAction func speakerButtonPressed(_ sender: Any)
    {
        speakToUser()
    }
    
    @IBAction func browserButtonPressed(_ sender: Any)
    {
        if let wordtopass = word.text
        {
            postBarcodeNotification(code: UserInterfaceNotfications.showWebDefinition,nameOfWord: wordtopass)
        }
        
    }
}

//MARK: - Notification Center
extension HomeTableViewCell{
    private func postBarcodeNotification(code: String, nameOfWord: String)
    {
        var info = [String: String]()
        info[code.description] = nameOfWord //post the notification with the key.
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationString.notificationKey), object: nil, userInfo: info)
    }
}

//MARK: - AVSpeechSynthesizer
extension HomeTableViewCell
{
    func speakToUser()
    {
#warning("Fix this speeach error. Consider siri voice and stop the old voice from spoeaking when the button is pressed")
        var utteranceArray: [AVSpeechUtterance] = []
       
        
        //Word
        if let wordToPronounce = word.text
        {
                let utterance = AVSpeechUtterance(string: wordToPronounce)
                //Mans voice if eremoved defualts to a womens voice
                utterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
            utterance.postUtteranceDelay = 0.1
                utterance.rate = 0.5
            utteranceArray.append(utterance)
        }
        
        //Part of speach
        if let wordToPronounce = partOfSpeech
        {
                let utterance = AVSpeechUtterance(string: wordToPronounce)
                //Mans voice if eremoved defualts to a womens voice
                utterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
            utterance.postUtteranceDelay = 0.1
                utterance.rate = 0.5
            utteranceArray.append(utterance)
        }
        
        
        //Definition
        
        if let wordToPronounce = defenition.text
        {
                let utterance = AVSpeechUtterance(string: wordToPronounce)
                //Mans voice if eremoved defualts to a womens voice
                utterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
            utterance.postUtteranceDelay = 1
                utterance.rate = 0.5
            utteranceArray.append(utterance)
        }
        //Example
        if let wordToPronounce = example.text
        {
            if wordToPronounce != "no example"
            {
                let utterance = AVSpeechUtterance(string: wordToPronounce)
                //Mans voice if eremoved defualts to a womens voice
                utterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
            utterance.postUtteranceDelay = 0.1
                utterance.rate = 0.5
            utteranceArray.append(utterance)
            }
        }
        
        
        for utterance in utteranceArray
        {
            
            synthesizer.speak(utterance)
        }

       
    }
}
