//
//  FKAlert.h
//  FKKit
//
//  Created by Eric on 27/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKAlert : NSAlert
{
	NSView *		accessoryView;
	NSString *		dontWarnMessage;
}

- (void)setAccessoryView:(NSView *)aView;
- (void)setDontWarnMessage:(NSString *)aString;

@end
