//
//  UIView+Snapshot.m
//  OSLibrary
//
//  Created by Daniel Vela on 26/07/12.
//  Copyright (c) 2012 Inycom. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)


- (UIImage*)takeSnapshot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    // Center the context around the window's anchor point
    CGContextTranslateCTM(context, [self center].x, [self center].y);
    // Apply the window's transform about the anchor point
    CGContextConcatCTM(context, [self transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[self bounds].size.width * [[self layer] anchorPoint].x,
                          -[self bounds].size.height * [[self layer] anchorPoint].y);
    
    // Render the layer hierarchy to the current context
    [[self layer] renderInContext:context];
    
    // Restore the context
    CGContextRestoreGState(context);

    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
