//
//  NSManagedObject+JSON.h
//  EasyTablet
//
//  Created by Daniel Vela on 17/04/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (JSON)

-(NSDate*)dateFromString:(NSString*)str;
-(NSString*)stringFromDate:(NSDate*)date;

- (id)initWithDictionary:(NSDictionary*)object;

- (NSMutableDictionary*)toJSON;

@end
