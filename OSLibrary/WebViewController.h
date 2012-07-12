//
//  WebViewController.h
//  OSLibrary
//
//  Created by Daniel Vela on 6/29/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class WebViewController
 @abstract View controller for web control.
 @discussion Use this class when you need to embed a web control inside an app. This class includes a more button to load the url in the Safari.
*/
@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	UIWebView* web;
	NSString* url;
}

/*! 
 @property web
 @abstract web outlet in WebViewController.xib
*/
@property (nonatomic, retain) IBOutlet UIWebView* web;

/*! 
 @property url
 @abstract Url to load
 */
@property (nonatomic,retain) NSString* url;
@end
