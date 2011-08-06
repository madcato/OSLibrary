//
//  OSImage.m
//  OSLibrary
//
//  Created by Dani Vela on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OSImage.h"

@implementation OSImage

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

/* Mac OS X
+(CIImage*)resizeImage:(NSString*)urlToImage withScale:(double)scale {
    // Resize the image
    CIImage *ciImage = [CIImage imageWithContentsOfURL:urlToImage];
    CIFilter *scaleFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [scaleFilter setValue:ciImage forKey:@"inputImage"];
    [scaleFilter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
    [scaleFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputAspectRatio"];
    CIImage *finalImage = [scaleFilter valueForKey:@"outputImage"];
    
    return ciImage;
}
*/
@end
