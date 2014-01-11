//
//  FKModule_MiniStyle.m
//  FKKit
//
//  Created by Eric on 19/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModule_MiniStyle.h"

NSString * FKModuleMiniStyleMultipleObjectsFilterBarIdentifier = @"MiniStyleMultipleObjectsFilterBar";
NSString * FKModuleMiniStyleMultipleObjectsLeftTableViewName = @"MiniStyleMultipleObjectsLeftTableView";

NSString * FKModuleMiniStyleMultipleObjectsLeftTableViewDoubleActionNotification = @"FKModuleMiniStyleMultipleObjectsLeftTableViewDoubleAction";

@implementation FKModule (MiniStyle)

- (void)setupLayoutUsingMiniStyle {
	NSRect bounds = NSBigRect();

	self.miniModuleView = [[[FKView alloc] initWithFrame:bounds] autorelease];
	
	[miniModuleView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[miniModuleView setBackgroundColor:[NSColor colorWithDeviceRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0]];
	
	// multipleObjectsView
	
	NSRect searchFieldFrame = NSZeroRect;
	NSRect filterBarFrame = NSZeroRect;
	NSRect scrollViewFrame = NSZeroRect;
	NSRect tableViewFrame = NSZeroRect;
	NSRect informationsViewFrame = [miniStyleInformationsView frame];
	
	NSDivideRect(bounds, &filterBarFrame, &bounds, 30.0, NSMaxYEdge);
	NSDivideRect(bounds, &searchFieldFrame, &bounds, 48.0, NSMaxYEdge);
	
	// multipleObjectsFilterBar	
		
	[multipleObjectsFilterBar setFrame:filterBarFrame];
	[multipleObjectsFilterBar setAutoresizingMask:(NSViewWidthSizable | NSViewMinYMargin)];
	[multipleObjectsFilterBar setIdentifier:[NSString stringWithFormat:@"%@%@", self.name, FKModuleMiniStyleMultipleObjectsFilterBarIdentifier]];
	
	[miniModuleView addSubview:multipleObjectsFilterBar];	
	
	// multipleObjectsSearchField	
	
	searchFieldFrame.origin.x += 10.0;
	searchFieldFrame.size.width -= 20.0;
	
	[miniStyleSearchField setFrame:searchFieldFrame];
	[miniStyleSearchField setAutoresizingMask:(NSViewWidthSizable | NSViewMinYMargin)];
	
	[miniModuleView addSubview:miniStyleSearchField];
	
	NSDivideRect(bounds, &informationsViewFrame, &tableViewFrame, NSHeight(informationsViewFrame), NSMinYEdge);
	
	// miniInformationsView
	
	[miniStyleInformationsView setFrame:informationsViewFrame];
	[miniStyleInformationsView setAutoresizingMask:NSViewWidthSizable];
	
	[miniModuleView addSubview:miniStyleInformationsView];	
	
	// multipleObjectsLeftScrollView
	
	scrollViewFrame = NSInsetRect(tableViewFrame, -1.0, -1.0);
	
	//scrollViewFrame.origin.x -= 1.0;
	//scrollViewFrame.size.width += 2.0;
	
	[multipleObjectsLeftScrollView setFrame:scrollViewFrame];
	[multipleObjectsLeftScrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	[miniModuleView addSubview:multipleObjectsLeftScrollView];
	
	// multipleObjectsLeftTableView
	
	[multipleObjectsLeftTableView setFrame:tableViewFrame];
	[multipleObjectsLeftTableView setDoubleAction:@selector(multipleObjectsLeftTableViewMiniStyleDoubleAction:)];	
	[multipleObjectsLeftTableView setAutosaveName:[NSString stringWithFormat:@"%@%@", self.name, FKModuleMiniStyleMultipleObjectsLeftTableViewName]];
	
	[self finalizeSetupModuleViewUsingMiniStyle];
	
	self.moduleStyle = FKModuleMiniStyle;
}

- (void)finalizeSetupModuleViewUsingMiniStyle {
	[multipleObjectsLeftTableView sizeLastColumnToFit];
}

#pragma mark -
#pragma mark ACTIONS

- (void)multipleObjectsLeftTableViewMiniStyleDoubleAction:(id)sender {
	NSPoint mouseLocation = [[[multipleObjectsLeftTableView window] currentEvent] locationInWindow];
	
	mouseLocation = [multipleObjectsLeftTableView convertPoint:mouseLocation fromView:nil];
	
	NSUInteger clickedRow = [multipleObjectsLeftTableView rowAtPoint:mouseLocation];
	
	if (clickedRow >= 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:FKModuleMiniStyleMultipleObjectsLeftTableViewDoubleActionNotification
															object:self
														  userInfo:[NSDictionary dictionaryWithObject:[objectsArrayController selectedObjects] forKey:@"objects"]];
	}
}

@end
