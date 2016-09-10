//
//  Serializator.swift
//  TestPersistWebObject
//
//  Created by Daniel Vela on 04/07/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import Foundation


//    class SerializableWebQuery: NSObject, NSCoding {
//        var url: String
//        
//        init(url: String) {
//            self.url = url
//        }
//        
//        required init?(coder aDecoder: NSCoder) {
//            self.url = aDecoder.decodeObjectForKey("url") as! String
//        }
//        
//        func encodeWithCoder(aCoder: NSCoder) {
//            aCoder.encodeObject(self.url, forKey: "url")
//        }
//    }

//    func applicationWillResignActive(application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//        Serializator().saveObject(self.data, fileName: "testData")
//    }
//
//    func applicationDidBecomeActive(application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        
//        let restoredObjects = Serializator().restoreObject("testData")
//        if let restoredObjects = restoredObjects {
//            self.data = restoredObjects as! [SerializableWebQuery]
//        } 
//    }

class Serializator {
    
    func deleteSerial(fileName: String)  {
        let formFilePath = self.formFilePath(fileName)
        do {
            try NSFileManager.defaultManager().removeItemAtPath(formFilePath)
        } catch let error as NSError {
            print("Error deleting file", fileName, error)
        }
    }

    func restoreObject(fileName: String) -> AnyObject? {
        let formFilePath = self.formFilePath(fileName)
        let object = NSKeyedUnarchiver.unarchiveObjectWithFile(formFilePath)
        return object
    }
    
    func saveObject(object: AnyObject, fileName: String) {
        let formFilePath = self.formFilePath(fileName)
        NSKeyedArchiver.archiveRootObject(object, toFile: formFilePath)
    }
    
    func formFilePath(className: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0]
        let formFileName = "\(className).serial"
        let formFilePath = "\(documentsDirectory)/\(formFileName)"
        return formFilePath
    }
}