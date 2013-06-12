//
//  Person.h
//  addressbook
//
//  Created by Daniel Vela on 6/12/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSData * avatar;
@property (nonatomic, retain) NSNumber * programmer;

@end
