//
//  NSString+encodeString.m
//  OSLibrary
//
//  Created by Daniel Vela on 21/08/12.
//
//

#import "NSString+encodeString.h"

@implementation NSString (encodeString)

-(NSString*)encodeStringForHTTPParam {
    NSString * encodedString = (__bridge NSString* )
    CFURLCreateStringByAddingPercentEscapes(
                              NULL,
                              (__bridge CFStringRef)self,
                              NULL,
                              (CFStringRef)@"!'();:@&=+$,/?%#[]",
                              kCFStringEncodingUTF8 );
    return encodedString;
}

@end
