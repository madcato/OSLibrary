//
//  ImageGalleryControllerViewController.h
//  PhotoGallery
//
//  Created by Daniel Vela on 11/09/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDataSource;

@interface ImageGalleryControllerViewController : UICollectionViewController

@property (nonatomic, strong) ImageDataSource* imageDataSource;

@end
