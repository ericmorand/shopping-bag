//
//  FKTabViewItem.h
//  FKKit
//
//  Created by alt on 02/01/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKTabViewItem : NSTabViewItem {
	NSImage *	image;
	NSImage *	unselectedImage;
}

@property (nonatomic, readonly) NSImage *	image;
@property (nonatomic, readonly) NSImage *	unselectedImage;

@end
