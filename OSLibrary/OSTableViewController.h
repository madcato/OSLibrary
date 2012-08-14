//
//  OSTableViewController.h
//  OSLibrary
//
//  Created by Daniel Vela on 14/08/12.
//
//

#import <UIKit/UIKit.h>

@class OSLoadingViewController;

@interface OSTableViewController : UITableViewController {
    OSLoadingViewController* loadingViewController;
}
- (void)initLoadingView:(UIView*)view andColor:(UIColor*)c;
- (void)showLoadingView;
- (void)hideLoadingView;


@end
