//
//  OSLocation.m
//  OSLibrary
//
//  Created by Dani Vela on 8/6/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "OSLocation.h"


@implementation OSLocation

- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  return self;
}

+ (BOOL)locationServiceEnabled {
	BOOL result = NO;
	if([CLLocationManager respondsToSelector:@selector(authorizationStatus)]) {
		result = ([CLLocationManager authorizationStatus] ==
          kCLAuthorizationStatusAuthorizedAlways);
	} else {
		result = [CLLocationManager locationServicesEnabled];
	}
	return result;
}

@end
