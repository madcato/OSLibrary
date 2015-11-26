//
//  Person.m
//  addressbook
//
//  Created by Daniel Vela on 6/12/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "Person.h"

@implementation Person

@dynamic birthDate;
@dynamic name;
@dynamic height;
@dynamic avatar;
@dynamic programmer;
@dynamic created_at;
@dynamic updated_at;
@dynamic syncStatus;
@dynamic objectId;

- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString* isProgrammer;
    if ([self.programmer boolValue] == YES) {
        isProgrammer = @"true";
    } else {
        isProgrammer = @"false";
    }
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.name, @"name",
                                    self.height, @"height",
//                                    self.avatar == nil ? [NSData data]: self.avatar, @"avatar",
                                    [[OSCoreDataSyncEngine sharedEngine] dateStringForAPIUsingDate:self.birthDate], @"birthDate",
                                    isProgrammer, @"programmer",
                                    nil];
    return jsonDictionary;
}

@end
