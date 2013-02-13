//
//  OSNetworkTest.h
//  OSLibrary
//
//  Created by Daniel Vela on 14/02/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import "OSNetwork.h"

@interface OSNetworkTest : SenTestCase <OSNetworkDelegate>
{
  OSNetwork* network;
}
@end
