//
//  OSEmailValidator.h
//  OSLibrary
//
//  Created by Daniel Vela on 21/01/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSEmailValidator : NSObject

- (BOOL)isValid:(NSString*)email;

@end
