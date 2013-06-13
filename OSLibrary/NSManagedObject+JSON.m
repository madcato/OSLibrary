//
//  NSManagedObject+JSON.m
//  EasyTablet
//
//  Created by Daniel Vela on 17/04/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//

#import "NSManagedObject+JSON.h"
#import "NSData+Base64.h"
#import "OSCoreDataSyncEngine.h"

@implementation NSManagedObject (JSON)

- (NSDictionary *)JSONToCreateObjectOnServer {
    @throw [NSException exceptionWithName:@"JSONStringToCreateObjectOnServer Not Overridden" reason:@"Must override JSONStringToCreateObjectOnServer on NSManagedObject class" userInfo:nil];
    return nil;
}

-(id)formatValue:(id)value forKey:(NSString*)key {
    NSArray* propertyArray = [[self entity] properties];
    for(NSAttributeDescription* description in propertyArray) {
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
                    return value;
                    break;

            }
        }
    }
    return value;
}

@end
