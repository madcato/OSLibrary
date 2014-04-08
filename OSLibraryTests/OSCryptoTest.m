//
//  OSCryptoTest.m
//  OSLibrary
//
//  Created by Daniel Vela on 28/02/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "OSCrypto.h"

@interface OSCryptoTest : SenTestCase

@end

@implementation OSCryptoTest

- (void)testMD5 {
  NSString *str = @"Hola Pepe";
  NSString *md5 = @"02EA79D86254A86CB20FD1CFDF259FC5";
  NSString *result = [OSCrypto md5:str];
  STAssertTrue([result isEqualToString:md5], @"MD5 test failing");
}
@end
