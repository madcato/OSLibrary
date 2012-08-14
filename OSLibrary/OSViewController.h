//
//  OSViewController.h
//  OSLibrary
//
//  Created by Daniel Vela on 14/08/12.
//
//

#import <UIKit/UIKit.h>
#import "OSLoadingViewController.h"

@class OSLoadingViewController;

@interface OSViewController : UIViewController {
    OSLoadingViewController* loadingViewController;
}
- (void)initLoadingView:(UIView*)view andColor:(UIColor*)c;
- (void)showLoadingView;
- (void)hideLoadingView;
@end
