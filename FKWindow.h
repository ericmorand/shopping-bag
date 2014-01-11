//
//  FKWindow.h
//  ShoppingBag
//
//  Created by Eric on 26/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * FKWindowFirstResponderDidChange;
extern NSString * FKViewFirstResponderDidChange;

@interface FKWindow : NSWindow {
	BOOL		postsFirstResponderChangedNotifications;
}

@property (assign) BOOL	postsFirstResponderChangedNotifications;

- (float)toolbarHeight;
- (void)setPostsFirstResponderChangedNotifications:(BOOL)flag;
- (BOOL)makeFirstResponder:(NSResponder *)aResponder notify:(BOOL)flag;

@end
