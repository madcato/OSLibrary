//
//  OSLoadingViewController.m
//  OSLibrary
//
//  Created by Daniel Vela on 14/08/12.
//
//

#import "OSLoadingViewController.h"

const CGFloat waitingViewSize = 60.0;

@implementation OSLoadingViewController

-(id)init {
    self = [super init];
    _color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    return self;
}

-(void)showLoadingView {
    
    if(loadingView != nil) {
        [self hideLoadingView];
    }
    CGRect parentFrame = self.parentView.frame;
    loadingView = [[UIView alloc]initWithFrame:CGRectMake((parentFrame.size.width / 2) - (waitingViewSize / 2), (parentFrame.size.height / 2) - (waitingViewSize /2), waitingViewSize, waitingViewSize)];
    
    loadingView.opaque = NO;
    loadingView.layer.opacity = 0.5;
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.layer.cornerRadius = 15;
    
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    CGRect frame = activity.frame;
    frame.origin.x = 11;
    frame.origin.y = 11;
    activity.frame = frame;
    [activity startAnimating];
    [loadingView addSubview:activity];
    
    [self.parentView addSubview:loadingView];
    
}

-(void)hideLoadingView {
    [loadingView removeFromSuperview];
    
    loadingView = nil;
}

@end
