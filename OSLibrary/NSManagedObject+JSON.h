//
//  NSManagedObject+JSON.h
//  EasyTablet
//
//  Created by Daniel Vela on 17/04/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//
//
// In each NSManagedObjectModel implement
//
//- (NSDictionary *)JSONToCreateObjectOnServer {
//    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
//                          @"Date", @"__type",
//                          [[OSCoreDataSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
//
//    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    self.name, @"name",
//                                    self.details, @"details",
//                                    self.wikipediaLink, @"wikipediaLink",
//                                    date, @"date", nil];
//    return jsonDictionary;
//}

#import <CoreData/CoreData.h>

@interface NSManagedObject (JSON)

- (NSDictionary *)JSONToCreateObjectOnServer;

@end


//// OSCoreDataSync fields
//  @property (nonatomic, retain) NSDate * updated_at;
//  @property (nonatomic, retain) NSDate * created_at;
//  @property (nonatomic, retain) NSNumber * syncStatus;
//  @property (nonatomic, retain) NSString * objectId;
//
