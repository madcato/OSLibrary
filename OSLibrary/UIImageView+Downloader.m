//
//  UIView+Downloader.m
//  netapp
//
//  Created by Daniel Vela on 13/07/12.
//  Copyright (c) 2012 Inycom. All rights reserved.
//

#import "UIImageView+Downloader.h"
#import "OSWebRequest.h"
#import <objc/runtime.h>


static NSMutableDictionary* imageCache = nil;

static char kOSWebRequestObjectKey = 's';

@implementation UIImageView (Downloader)
@dynamic osWebRequestObject;

- (OSWebRequest *)osWebRequestObject {
  return (OSWebRequest *)objc_getAssociatedObject(self,
                          &kOSWebRequestObjectKey);
}

- (void)setOsWebRequestObject:(OSWebRequest *)imageRequestOperation {
  objc_setAssociatedObject(self,
               &kOSWebRequestObjectKey,
               imageRequestOperation,
               OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setImageFrom:(NSString*)url withTag:(NSInteger)tag {
  UIImage* cachedImage = [self getCachedImage:url];
  if(cachedImage != nil) {
    [self setImage:cachedImage];
  } else {
    [self showLoadingView];
    UIImage* image = [UIImage imageNamed:@"Icon.png"];
    [self setImage:image];
    
    OSWebRequest* request = [[OSWebRequest alloc]init];
    [self setOsWebRequestObject:request];
    [request download:url withHandler:^(NSData* response,
                      NSHTTPURLResponse* urlResponse,
                      NSError* error) {
      [self hideLoadingView];
      if(error == nil) {
        UIImage* image;
        if([urlResponse statusCode] == 200) {
          image = [UIImage imageWithData:response];
          if(image != nil) {
            [self setCachedImage:image forKey:url];
            if(self.tag == tag) [self setImage:image];
            if(tag == -1) [self setImage:image];
          }
          else {
            NSLog(@"BAD IMAGE: %@",url);
          }          
        }
      } else {
        NSLog(@"ERROR %@", [error description]);
      }
      [self setOsWebRequestObject:nil];
    }];
  }
}

-(void)setCachedImage:(UIImage*)image forKey:(NSString*)key {
  if(imageCache == nil) {
    imageCache = [NSMutableDictionary dictionary];
  }
  imageCache[key] = image;
}

-(UIImage*)getCachedImage:(NSString*)key {
  if(imageCache == nil) {
    imageCache = [NSMutableDictionary dictionary];
  }
  return imageCache[key];
}

- (void)showLoadingView {
  UIActivityIndicatorView * v =
  (UIActivityIndicatorView *)[self viewWithTag:-12];
  if(v == nil) {
    CGRect frame = self.frame;
    UIActivityIndicatorView *spinningWheel =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinningWheel.tag = -12;
    CGRect sframe = spinningWheel.frame;
    int x = (frame.size.width / 2) - (sframe.size.width / 2);
    int y = (frame.size.height / 2) - (sframe.size.height / 2);
    spinningWheel.frame = CGRectMake(x,
                     y,
                     sframe.size.width,
                     sframe.size.height);
    CGRect blackFrame = CGRectMake(spinningWheel.frame.origin.x - 5,
                     spinningWheel.frame.origin.y - 5,
                     spinningWheel.frame.size.width + 10,
                     spinningWheel.frame.size.height + 10);
    UIView* blackView = [[UIView alloc] initWithFrame:blackFrame];
    [blackView setBackgroundColor:[UIColor colorWithRed:0.0
                            green:0.0
                             blue:0.0
                            alpha:0.3]];
    blackView.layer.cornerRadius = 7.0;
    blackView.tag = -13;
    [self addSubview:blackView];
    [self addSubview:spinningWheel];    
    [spinningWheel startAnimating];
  }
}

- (void)hideLoadingView2 {
}

- (void)hideLoadingView {
  UIActivityIndicatorView * v =
  (UIActivityIndicatorView *)[self viewWithTag:-12];
  [v stopAnimating];
  [v removeFromSuperview];
  UIView * w = [self viewWithTag:-13];
  [w removeFromSuperview];
}

@end
