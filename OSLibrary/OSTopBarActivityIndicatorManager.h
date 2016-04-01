//
//  OSTopBarActivityIndicatorManager.h
//  OSLibrary
//
//  Created by Daniel Vela on 01/04/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSTopBarActivityIndicator
;
@interface OSTopBarActivityIndicatorManager : NSObject

- (instancetype)initWithActivityIndicator:(OSTopBarActivityIndicator*)indicator;
+ (void)startActivity;
+ (void)stopActivity;

@end
