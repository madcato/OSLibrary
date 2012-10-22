//
//  NSData+Base64.h
//  base64
//
//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
	const char *inputBuffer,
	size_t length,
	size_t *outputLength);

char *NewBase64Encode(
	const void *inputBuffer,
	size_t length,
	bool separateLines,
	size_t *outputLength);

/*!
 @class NSData (Base64)
 @abstract NSDate extension to perform encoding from or to Base64
 @namespace OSLibrary
 @updated 2011-07-30
 */
@interface NSData (Base64)

/*!
 @method dataFromBase64String
 @param aString Data source. This string must be in base64 codification format.
 @abstract Creates a new NSData object and initialices it with the decoded base64 string.
 @return The created NSData object.
 */
+ (NSData *)dataFromBase64String:(NSString *)aString;

/*!
 @method base64EncodedString
 @abstract Encode the content of this NSData object and return it.
 @return The base64 encoded string.
 */
- (NSString *)base64EncodedString;

@end
