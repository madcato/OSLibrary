//
//  OSLoadingViewController.m
//  OSLibrary
//
//  Created by Daniel Vela on 14/08/12.
//
//

#import "OSLoadingViewController.h"

const CGFloat spinningWheelSize = 38.0;

@implementation OSLoadingViewController

-(id)init {
    self = [super init];
    color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    return self;
}

- (void)initLoadingView:(UIView*)view andColor:(UIColor*)c {
    color = c;
    parentView = view;
}

- (void)showLoadingView {
    if (loadingView == nil)
    {
        CGRect frame = parentView.bounds;
        loadingView = [[UIView alloc] initWithFrame:frame];
        loadingView.opaque = NO;
        loadingView.backgroundColor = color;
        loadingView.alpha = 1;
        
        CGFloat posx = (frame.size.width / 2) - (spinningWheelSize / 2);
        CGFloat posy = (frame.size.height / 2) - (spinningWheelSize / 2);
        UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(posx, posy, spinningWheelSize, spinningWheelSize)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [loadingView addSubview:spinningWheel];
    }    
    [parentView addSubview:loadingView];
}

- (void)hideLoadingView {
    [loadingView removeFromSuperview];
}

@end
