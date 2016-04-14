//
//  Person.m
//  OSLibrary
//
//  Created by Daniel Vela on 13/04/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSDictionary *)JSONToCreateObjectOnServer {
//    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
//                          @"Date", @"__type",
//                          [[OSCoreDataSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];

    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.birthDate, @"birthDate",
                                    self.height, @"height",
                                    self.programmer, @"programmer",
                                    self.salary, @"salary",
                                    self.updated_at, @"updated_at",
                                    self.created_at, @"created_at",
                                    self.syncStatus, @"syncStatus",
                                    self.objectId, @"objectId",
                                    nil];
    return jsonDictionary;
}

@end
