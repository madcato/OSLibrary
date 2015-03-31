//
//  OSOperation.h
//  OSLibrary
//
//  Created by Daniel Vela on 16/08/12.
//
//

#import <Foundation/Foundation.h>
#import "OSWebRequest.h"

typedef void (^OSCompletionBlock) (void);

@interface OSOperation : NSOperation {
  BOOL    executing;
  BOOL    finished;
}

- (void)completeOperation;

@end
