//
//  OSOperation.h
//  OSLibrary
//
//  Created by Daniel Vela on 16/08/12.
//
//

#import <Foundation/Foundation.h>
#import "OSWebRequest.h"


@interface OSOperation : NSOperation {
  BOOL    executing;
  BOOL    finished;
}

- (void)completeOperation;

@end
