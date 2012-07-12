//
//  NSManagedObject+JSON.m
//  EasyTablet
//
//  Created by Daniel Vela on 17/04/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//

#import "NSManagedObject+JSON.h"
#import "NSData+Base64.h"

@implementation NSManagedObject (JSON)

-(NSDate*)dateFromString:(NSString*)str {
    
    static NSDateFormatter* dateFormatter = nil;
    
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = kCFDateFormatterNoStyle;
        dateFormatter.timeStyle = kCFDateFormatterNoStyle;
        
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.timeZone = timeZone;
    }
    return [dateFormatter dateFromString:str];
}

-(NSString*)stringFromDate:(NSDate*)date {
    
    if(date == nil) return @"";
    
    static NSDateFormatter* dateFormatter = nil;
    
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = kCFDateFormatterNoStyle;
        dateFormatter.timeStyle = kCFDateFormatterNoStyle;
        
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.timeZone = timeZone;
    }
    return [dateFormatter stringFromDate:date];
}


-(id)initWithDictionary:(NSDictionary*)object {
    
    
    NSArray* propertyArray = [[self entity] properties];
    
    for(NSAttributeDescription* description in propertyArray) {
        
        if([description isKindOfClass:[NSAttributeDescription class]]) {
            
            
            NSAttributeType type = description.attributeType;
            
            NSAssert(([object objectForKey:description.name] != nil),@"JSON: variable %@ does not exists",description.name);
            ;
            switch (type) {
                case NSInteger16AttributeType:
                case NSInteger32AttributeType:
                case NSInteger64AttributeType:
                    [self setValue:[NSNumber numberWithInt:[[object valueForKey:description.name] intValue]] forKey:description.name];
                    break;
                case NSDoubleAttributeType:
                    [self setValue:[NSNumber numberWithDouble:[[object valueForKey:description.name] doubleValue]] forKey:description.name];
                    break;
                case NSFloatAttributeType:
                    [self setValue:[NSNumber numberWithFloat:[[object valueForKey:description.name] floatValue]] forKey:description.name];
                case NSBooleanAttributeType:
                    //NSNumber;
                    
                    [self setValue:[NSNumber numberWithBool:[[object valueForKey:description.name] boolValue]] forKey:description.name];
                    break;
                    
                    
                case NSDecimalAttributeType:
                    //NSDecimalNumber;
                    [self setValue:[NSDecimalNumber decimalNumberWithDecimal:[[object valueForKey:description.name] decimalValue]] forKey:description.name];
                    break;
                    
                case NSStringAttributeType:
                    //NSString;
                    [self setValue:[object valueForKey:description.name] forKey:description.name];
                    break;
                    
                case NSDateAttributeType:
                    //NSDate;
                    
                    [self setValue:[self dateFromString:[object valueForKey:description.name]] forKey:description.name];
                    break;
                    
                case NSBinaryDataAttributeType:
                    //NSData;
                    
                    [self setValue:[NSData dataFromBase64String:[object valueForKey:description.name]] forKey:description.name];
                    break;
                    
            }
        }
    }
    

    
    
    
    return self;
}


-(NSMutableDictionary*)toJSON {
    
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    NSArray* propertyArray = [[self entity] properties];
    
    for(NSAttributeDescription* description in propertyArray) {
        
        if([description isKindOfClass:[NSAttributeDescription class]]) {

            NSAttributeType type = description.attributeType;
            
            switch (type) {
                case NSInteger16AttributeType:
                case NSInteger32AttributeType:
                case NSInteger64AttributeType:
                case NSDoubleAttributeType:
                case NSFloatAttributeType:
                case NSBooleanAttributeType:
                    //NSNumber;
                    [dictionary setObject:[self  valueForKey:description.name] forKey:description.name];
                    break;
                    
                    
                case NSDecimalAttributeType:
                    //NSDecimalNumber;
                    [dictionary setObject:[self  valueForKey:description.name] forKey:description.name];
                    
                    break;
                    
                case NSStringAttributeType:
                    //NSString;
                    [dictionary setObject:[self  valueForKey:description.name] forKey:description.name];
                    
                    break;
                    
                case NSDateAttributeType:
                    //NSDate;
                    
                    [dictionary setObject:[self stringFromDate:[self  valueForKey:description.name]] forKey:description.name];
                    break;
                    
                case NSBinaryDataAttributeType:
                    //NSData;
                    
                    [dictionary setObject:[[self  valueForKey:description.name] base64EncodedString] forKey:description.name];
                    break;
                    
            }
        }
    }
    
    
    return dictionary;
    
}
@end
