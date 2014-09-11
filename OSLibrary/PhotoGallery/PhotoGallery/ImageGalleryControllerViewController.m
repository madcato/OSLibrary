//
//  ImageGalleryControllerViewController.m
//  PhotoGallery
//
//  Created by Daniel Vela on 11/09/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import "ImageGalleryControllerViewController.h"
#import "ImageDataSource.h"

#define VIEW_TAG 1

@interface ImageGalleryControllerViewController ()

@end

@implementation ImageGalleryControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageDataSource = [ImageDataSource new];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [self.collectionView
                            dequeueReusableCellWithReuseIdentifier:@"ImageCell"
                                                      forIndexPath:indexPath];

    UIImage* image = [self.imageDataSource imageForIndex:indexPath.row];
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:VIEW_TAG];

    [imageView setImage:image];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.imageDataSource count];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
@end
