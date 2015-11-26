//
//  ImageDataSource.h
//  PhotoGallery
//
//  Created by Daniel Vela on 11/09/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDataSource : NSObject

@property (nonatomic, strong) NSArray* imageList;

-(NSInteger)count;
-(UIImage*)imageForIndex:(NSInteger)index;

@end
