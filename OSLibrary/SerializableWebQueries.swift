//
//  SerializableWebQueries.swift
//  happic-ios
//
//  Created by Daniel Vela on 04/07/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import Foundation

class SerializableWebQueries {
    
    var fileName = "WebQueriesData"
    
    var data: [SerializableWebQuery] = []
    
    var running = false
    
    func append(url: String, parameters: [NSObject:AnyObject]) {
        self.data.append(SerializableWebQuery(url: url, parameters: parameters))
        
        startContinue()
    }
    
    func appBecomeActive() {
        let restoredObjects = Serializator().restoreObject(fileName)
        if let restoredObjects = restoredObjects {
            self.data = restoredObjects as! [SerializableWebQuery]
        }
        startContinue()
    }
    
    func appBecomeInactive() {
        Serializator().saveObject(self.data, fileName: fileName)
    }
    
    func startContinue() {
        if running == false {
            running = true
        }else {
            return
        }
        
        sendAQuery()
        
    }
    
    static let initialSecondsToWaitOnError: Double = 5.0
    var secondsToWaitOnError = {
        initialSecondsToWaitOnError
    }()
    
    func sendAQuery() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            if self.data.count > 0 {
                let webQuery = self.data.removeFirst()
                
                webQuery.start({ 
                        // Nothing. The query was ok
                        // Continue with next one
                        self.sendAQuery()
                        self.secondsToWaitOnError = SerializableWebQueries.initialSecondsToWaitOnError
                    }, onError: { 
                        // On error the query must be restored on the queue
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                            self.data.append(webQuery)
                            // and wait some seconds
                            NSThread.sleepForTimeInterval(self.secondsToWaitOnError)
                            self.secondsToWaitOnError *= 2
                            self.sendAQuery()
                        }
                })
            } else {
                self.running = false
            }
        }
    }
}