//
//  OSLoadingViewController.h
//  OSLibrary
//
//  Created by Daniel Vela on 14/08/12.
//
//

#import <Foundation/Foundation.h>

@interface OSLoadingViewController : NSObject {
    UIView* loadingView;
    UIView* parentView;
    UIColor* color;
}
- (void)initLoadingView:(UIView*)view andColor:(UIColor*)c;
- (void)showLoadingView;
- (void)hideLoadingView;
@end
