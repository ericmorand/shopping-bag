//
//  FKImageAndText.h
//  ShoppingBag
//
//  Created by Eric on 15/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FKImageAndTextCell : NSTextFieldCell
{
@private
	NSImage *image;
}

@property (nonatomic, retain) NSImage * image;

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView*)controlView;
- (NSSize)cellSize;

@end
