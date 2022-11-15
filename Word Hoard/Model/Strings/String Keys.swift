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
    static let showMultiListVC = "com.Learner.showMultiListVC"
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
        WordAlternative(name: "odontology", type: .verb, defineition: "a science dealing with the teeth, their structure and development, and their diseases", example: "Laundrie's remains were identified through dental record comparison, also known as odontology, on Oct. 21."),
        
        WordAlternative(name: "anti-Semitic", type: .ajdective, defineition: ": relating to or characterized by anti-Semitism : feeling or showing hostility toward or discrimination against Jews as a cultural, racial, or ethnic group", example: "Kanye West is anti-semetic"),
        
        WordAlternative(name: "viertel", type: .noun, defineition: "a science dealing with the teeth, their structure and development, and their diseases", example: "Laundrie's remains were sidentified through dental record comparison, also known as odontology, on Oct. 21."),
        
        WordAlternative(name: "bark", type: .verb, defineition: "to make the characteristic short loud cry of a dog", example: "The dog is barking really loud"),
        
        WordAlternative(name: "reservoir", type: .noun, defineition: "a science dealing with the teeth, their structure and development, and their diseases", example: "Laundrie's remains were identified through dental record comparison, also known as odontology, on Oct. 21."),
        
        
        WordAlternative(name: "throat", type: .noun, defineition: "the part of the neck in front of the spinal column", example: "Adam was arrested after slitting the girrafes throat."),
    
        WordAlternative(name: "kettle", type: .noun, defineition: "a metallic vessel usually used for boiling liquids", example: "Look for pumpkin painting; snacks including kettle corn, apples and hot apple cider; and four bluegrass bands, including the Kentucky Warblers and Danny Paisley and the Southern Grass."),
        
        WordAlternative(name: "observer", type: .noun, defineition: " a representative sent to observe but not participate officially in an activity (such as a meeting or war)", example: "According to one observer, the event was poorly organized."),
        
        WordAlternative(name: "kettle", type: .noun, defineition: "a metallic vessel usually used for boiling liquids", example: "Look for pumpkin painting; snacks including kettle corn, apples and hot apple cider; and four bluegrass bands, including the Kentucky Warblers and Danny Paisley and the Southern Grass.")
    
    
    ].shuffled()
    
    
    
}


