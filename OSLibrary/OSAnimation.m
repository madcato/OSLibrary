//
//  OSAnimation.m
//  OSLibrary
//
//  Created by Dani Vela on 8/6/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "OSAnimation.h"

@implementation OSAnimation

- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  return self;
}

+(void)blinkObject:(UIView*)object duringSeconds:(double)seconds {
  CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animation.duration=seconds;
  animation.repeatCount=HUGE_VALF;
  animation.autoreverses=YES;
  animation.fromValue=@1.0f;
  animation.toValue=@0.0f;
  [object.layer addAnimation:animation forKey:@"animateOpacity"];
}
@end
