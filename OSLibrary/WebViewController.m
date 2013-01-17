//
//  WebViewController.m
//  OSLibrary
//
//  Created by Daniel Vela on 6/29/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController
@synthesize web;
@synthesize url;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	UIBarButtonItem* moreButton = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                              target:self
                                              action:@selector(moreTouched)];
	[self.navigationItem setRightBarButtonItem:moreButton];
    [super viewDidLoad];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	web.delegate = self;
	NSURLRequest* request = [NSURLRequest requestWithURL:
                                            [NSURL URLWithString:url]];
	[web loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ZgZmap"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
}

-(void)moreTouched {
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
                            initWithTitle:NSLocalizedString(@"",@"")
                                 delegate:self
                        cancelButtonTitle:NSLocalizedString(@"Cancelar",@"")
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Abrir en Safari",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
		//NSLog(@"ok");
	}
	else {
		//NSLog(@"cancel");
	}
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	web.delegate = nil;
	self.web = nil;
}

- (void)dealloc {
	web.delegate = nil;
}


@end
