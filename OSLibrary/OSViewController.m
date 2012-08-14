//
//  OSViewController.m
//  OSLibrary
//
//  Created by Daniel Vela on 14/08/12.
//
//

#import "OSViewController.h"
#import "OSLoadingViewController.h"

@interface OSViewController ()

@end

@implementation OSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        loadingViewController = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initLoadingView:(UIView*)view andColor:(UIColor*)c {
    if(loadingViewController == nil) {
        loadingViewController = [[OSLoadingViewController alloc] init];
    }
    [loadingViewController initLoadingView:view andColor:c];
}

- (void)showLoadingView {
    [loadingViewController showLoadingView];
}

- (void)hideLoadingView {
    [loadingViewController hideLoadingView];
}

@end
