//
//  OSDNIValidator.m
//  OSLibrary
//
//  Created by Daniel Vela on 25/03/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import "OSDNIValidator.h"

@implementation OSDNIValidator

+ (BOOL)validateSpanishNationalIdentifier:(NSString*)nationalID {
    if (nationalID.length != 9)
        return NO;
    
    NSString* buffer = nationalID.uppercaseString;
    NSStringCompareOptions opts = 0;
    NSRange rng = NSMakeRange(0, 1);
    buffer = [buffer stringByReplacingOccurrencesOfString:@"X" withString:@"0"options:opts range:rng];
    buffer = [buffer stringByReplacingOccurrencesOfString:@"Y" withString:@"1"options:opts range:rng];
    buffer = [buffer stringByReplacingOccurrencesOfString:@"Z" withString:@"2"options:opts range:rng];
    
    NSInteger baseNumber = [buffer substringWithRange:NSMakeRange(0, 8)].integerValue;
    NSString* letterMap = @"TRWAGMYFPDXBNJZSQVHLCKET";
    NSInteger letterIds = baseNumber % 23;
    NSString* expectedLetter = [letterMap substringWithRange:NSMakeRange(letterIds, 1)];
    NSString* providedLetter = [buffer substringWithRange:NSMakeRange(8, 1)];
    return [expectedLetter isEqualToString:providedLetter];
}

@end
