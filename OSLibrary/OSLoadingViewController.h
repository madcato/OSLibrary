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
}

- (void)showLoadingView;
- (void)hideLoadingView;

@property (nonatomic, assign) IBOutlet UIView* parentView;
@property (nonatomic, assign) IBOutlet UIColor* color;

@end
