//
//  NSData+Base64Test.m
//  OSLibrary
//
//  Created by Daniel Vela on 28/02/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSData+Base64.h"

@interface NSData_Base64Test : SenTestCase

@end

@implementation NSData_Base64Test

- (void)testFromBase4 {
  NSString *base64str = @"SG9sYSBwZXBl";
  NSString *str = @"Hola pepe";
  NSData *base64 = [str dataUsingEncoding:NSUTF8StringEncoding];
  NSData* base64result = [NSData dataFromBase64String:base64str];
  STAssertEqualObjects(base64, base64result, @"dataFromBase64String failing");
}

- (void)testBase4Encoding {
  NSString *base64str = @"SG9sYSBwZXBl";
  NSString *str = @"Hola pepe";
  NSData *base64 = [str dataUsingEncoding:NSUTF8StringEncoding];
  NSString* base64result = [base64 base64EncodedString];
  STAssertEqualObjects(base64str, base64result, @"dataFromBase64String failing");
}

@end
