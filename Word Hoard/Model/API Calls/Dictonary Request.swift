//
//  Dictonary Request.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/29/22.
//
import Foundation
import NotificationBannerSwift

class DictionaryRequest
{
    var selectedCategory : Category?
    
    init(wordPassed: String, category: Category)
    {
        selectedCategory = category
        
        DispatchQueue.global().async
        {
            self.networkRequest(wordToDefine: wordPassed)
        }
        
    }
    
     func networkRequest(wordToDefine: String)
    {
        let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(wordToDefine.replacingOccurrences(of: " ", with: "%20"))")
        
        guard let requestUrl = url else
        {
            print("Dictionary: Error Parsing Data")
            
            
            return
        }
        
        var request = URLRequest(url: requestUrl) // Create URL Request
        request.httpMethod = "GET"  // Specify HTTP Method to use
        
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request)
        { [self] (data, response, error) in
            
            // Check if Error took place
            if let error = error
            {
                print("Error took place \(error)")
                return
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8)
            {
                guard (try? JSONDecoder().decode([Word].self, from: dataString.data(using: .utf8)!)) != nil else
                {
                    print("Failed. Cannot find word in the default dictionary!     \(wordToDefine)")
    
                    return
                }
                let blogPosts: [Word] = try! JSONDecoder().decode([Word].self, from: data)
                
                
                //Find the word and assigin its propery
                
                //Default Value
                var word = wordToDefine
                var partOfSpech = ""
                var wordExample = ""
                var wordDefenition = ""
                
                if let speech = blogPosts[0].meanings[0]?.partOfSpeech
                {
                    let finalPartOFSpeech = "(" + speech +  ")"
                    partOfSpech = finalPartOFSpeech
                }
                
                if let example =  blogPosts[0].meanings[0]?.definitions[0]?.example
                {
                    
                    wordExample = example
                }
                
                if let defenition = blogPosts[0].meanings[0]?.definitions[0]?.definition
                {
                    wordDefenition = defenition
                }
                
                if let unwrappedCategory = selectedCategory
                {
                    CoreDataManager.sharedManager.createWordEntry(word: word, partOfSpeech: partOfSpech, wordExample: wordExample, definition: wordDefenition, category: unwrappedCategory)
                    
                }
                else
                {
                    somethingwierdhappend()
                }
                
                
                
                
                
            }
            
            
        }
        task.resume()
        
    }
    
    private func postBarcodeNotification(code: String)
    {
        var info = [String: String]()
        info[code.description] = code.description //post the notification with the key.
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationString.notificationKey), object: nil, userInfo: info)
    }
}



//MARK: - Banner
extension DictionaryRequest
{
  
    
    @MainActor
    func somethingwierdhappend()
    {
        DispatchQueue.main.sync
        {
            let banner = FloatingNotificationBanner(title: "Fatal Error", subtitle: "Something really really strange happend.", style: .danger)
            banner.show(queuePosition: .front, bannerPosition: .top, cornerRadius: 15)
        }
    }
}


extension DictionaryRequest
{
    
}

