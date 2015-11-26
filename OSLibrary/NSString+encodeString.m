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
  CFStringRef encodedStringRef =
  CFURLCreateStringByAddingPercentEscapes(
                NULL,
                (__bridge CFStringRef)self,
                NULL,
                (CFStringRef)@"!'();:@&=+$,/?%#[]",
                kCFStringEncodingUTF8 );
    
    NSString * encodedString = [NSString stringWithFormat:@"%@",encodedStringRef];
    CFRelease(encodedStringRef);
  return encodedString;
}

@end
