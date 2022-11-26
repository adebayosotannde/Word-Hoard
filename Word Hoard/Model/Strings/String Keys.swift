//
//  StringValues.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/29/22.
//

import UIKit


struct SirenString
{
    static let appname = Bundle.main.infoDictionary!["CFBundleName"] as! String
    static let alertTitle = "A New Version is Available"
    
    static let alertMessage = "A new version of the app is available. Please update as soon as possible. Thank you"
}
struct TestTypeCode
{
    static let multipleChoiceTest = "multipleChoiceTest"
    static let truefalseTest = "truefalseTest"
    static let mixedTest = "mixedTest"
    
    static let testCodeRecived = "testCodeRecived"
    static let needMoreWordsError = "needMoreWordsError"
    
    static let endTest = "endTest"
    
    static let numberOfWordsReqiredForTest = 20
    
    
    
   
    
    
    
    
}
struct NotificationString
{
    static let notificationKey = "com.Learner.notificationKey"
    
        //Managed by the core data manager
    static let updateCollectionVC = "com.Learner.updateCollectionVC"
    static let updateWordVC = "com.Learner.updateWordVC"
    
    //Managed by the Home VC
   static let updateMainUIList = "com.Learner.updateMainUIList"
}
struct userDefaultString
{
 
}

struct TableViewCellValues
{
    static let heightForTableViewCells:CGFloat = 80
  
}


struct UserInterfaceNotfications
{
    static let notificationKey = "com.Learner.notificationKey"
  
   static let showWebDefinition = "com.Learner.showWebDefinition"
    
  
}
struct ViewNames
{
    static let popupViewStoryboard = "CustomView"
}
struct DummyData
{
    
    
    static let defaultList =
    [
       
        WordAlternative(name: "People", pronounciation: "pi-ple", synonyms: ["a person", "human" + "you", "SRTS"], partOfSpeech: "verb", defineition: "an himan being or entity", example: "I saw the person running down the street!"), 
        
        WordAlternative(name: "People", pronounciation: "pi-ple", synonyms: ["abcd"], partOfSpeech: "verb", defineition: "an himan being or entity", example: "")


    ].shuffled()

    
    
    
}


