//
//  ImageDataSource.m
//  PhotoGallery
//
//  Created by Daniel Vela on 11/09/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import "ImageDataSource.h"

@implementation ImageDataSource

-(instancetype)init {
    if (self) {
        _imageList = [OSSystem loadArrayFromResource:@"ImageList"];
    }
    return self;
}

-(NSInteger)count {
    return [self.imageList count];
}

-(UIImage*)imageForIndex:(NSInteger)index {
    NSString* imageName = self.imageList[index];
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}

@end
