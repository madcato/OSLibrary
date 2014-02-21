//
//  UIView+Snapshot.h
//  OSLibrary
//
//  Created by Daniel Vela on 26/07/12.
//  Copyright (c) 2012 Inycom. All rights reserved.
//

#import <UIKit/UIKit.h>


/*!
 @class UIView (Snapshot)
 @abstract Take snapshot form a view
 @namespace OSLibrary
 @updated 2011-07-30
 @dependency none
 */
@interface UIView (Snapshot)

/*!
 @method takeSnapshot
 @result UIImage*
 @abstract This method return an snapshot of the current view. 
 */
- (UIImage*)takeSnapshot;

@end
