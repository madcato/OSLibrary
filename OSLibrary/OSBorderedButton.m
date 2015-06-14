//
//  OSBorderedButton.m
//  OSLibrary
//
//  Created by Daniel Vela on 14/06/15.
//  Copyright (c) 2015 veladan. All rights reserved.
//

#import "OSBorderedButton.h"

@implementation OSBorderedButton

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[OSBorderedButton imageFromColor:backgroundColor] forState:state];
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        UIColor* color = [UIWindow appearance].tintColor;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [color CGColor];
        self.layer.cornerRadius = 8.0f;
        
        [super setTitleColor:color forState:UIControlStateNormal];
        [super setTitleColor:[UIColor blackColor]
                    forState:UIControlStateHighlighted];
        [self setBackgroundColor:color forState:UIControlStateHighlighted];        
    }
    return self;
}

@end
