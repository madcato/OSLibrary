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
                                    self.avatar == nil ? @"": self.avatar, @"avatar",
                                    [[OSCoreDataSyncEngine sharedEngine] dateStringForAPIUsingDate:self.birthDate], @"birthDate",
                                    isProgrammer, @"programmer",
                                    nil];
    return jsonDictionary;
}

-(id)formatValue:(id)value forKey:(NSString*)key {
    NSDictionary* properties = [[self entity] propertiesByName];
    NSAttributeDescription* description = properties[key];
    if([description isKindOfClass:[NSAttributeDescription class]]) {
        NSAttributeType type = description.attributeType;
        switch (type) {
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType:
                return value;
                break;
            case NSDoubleAttributeType:
                return value;
                break;
            case NSFloatAttributeType:
                return value;
                break;
            case NSBooleanAttributeType:
                //NSNumber;

                return value;
                break;
            case NSDecimalAttributeType:
                //NSDecimalNumber;
                return value;
                break;
            case NSStringAttributeType:
                //NSString;
                return value;
                break;
            case NSDateAttributeType:
                //NSDate;
                return [[OSCoreDataSyncEngine sharedEngine] dateUsingStringFromAPI:value];
                break;
            case NSBinaryDataAttributeType:
                //NSData;
                if ([value length] == 0) {
                    return [NSData data];
                }
                return value;
                break;

        }
    }

    return value;
}

@end
