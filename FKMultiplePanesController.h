//
//  FKMultiplePanesController.h
//  FKKit
//
//  Created by Eric on 31/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKMultiplePanesController : NSWindowController
{
	NSMutableArray *		paneViewsArray;
	NSMutableArray *		paneIdentifiersArray;
	
	NSString *				identifier;
		
	id						delegate;
	
	BOOL					needsReload;
	float					maxWidth;
}

- (id)initWithIdentifier:(NSString *)anIdentifier;

- (int)numberOfPanes;
- (NSView *)viewForPaneAtIndex:(int)paneIndex;
- (NSString *)identifierForPaneAtIndex:(int)paneIndex;
- (BOOL)showsResizeIndicatorForPaneAtIndex:(int)paneIndex;
- (NSSize)contentMinSizeForPaneAtIndex:(int)paneIndex;
- (NSSize)contentMaxSizeForPaneAtIndex:(int)paneIndex;

- (void)setPaneViewsArray:(NSMutableArray *)anArray;
- (void)setPaneIdentifiersArray:(NSMutableArray *)anArray;
- (void)setIdentifier:(NSString *)aString;

- (void)switchPane:(id)sender;

@property (retain) id						delegate;
@property BOOL					needsReload;
@property float					maxWidth;
@end