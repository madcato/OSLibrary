//
//  NSStirng+encodeStringTest.m
//  OSLibrary
//
//  Created by Daniel Vela on 19/11/12.
//
//

#import "NSStirng+encodeStringTest.h"
#import "NSString+encodeString.h"

@implementation NSStirng_encodeStringTest

-(void)testFormatNoChange
{
    NSString* data = @"Hola";
    NSLog(@"%@",[data encodeStringForHTTPParam]);
    STAssertEqualObjects(@"Hola", [data encodeStringForHTTPParam], @"String encode for string 'hola' must be 'hola'");
}

@end
