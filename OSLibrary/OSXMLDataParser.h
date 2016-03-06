//
//  OSXMLDataParser.h
//  OSLibrary
//
//  Created by Daniel Vela on 02/08/15.
//  Copyright (c) 2015 veladan. All rights reserved.
//

#import "OSDataParser.h"

@interface OSXMLDataParser : OSDataParser

@property (nonatomic, strong) id<NSXMLParserDelegate> delegate;

@end
