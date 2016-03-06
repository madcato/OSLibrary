//
//  OSXMLDataParser.m
//  OSLibrary
//
//  Created by Daniel Vela on 02/08/15.
//  Copyright (c) 2015 veladan. All rights reserved.
//

#import "OSXMLDataParser.h"

@implementation OSXMLDataParser

- (id)parse:(NSData*)data {
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self.delegate;
    [parser parse];
    
    return self.delegate;
}

@end
