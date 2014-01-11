//
//  FKModule_FullStyle.m
//  FKKit
//
//  Created by Eric on 12/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "FKModule_FullStyle.h"

#define multipleObjectsLeftMinWidth 400.0
#define multipleObjectsRightMinWidth 400.0

NSString * FKModuleFullStyleMultipleObjectsSplitViewName = @"FullStyleMultipleObjectsSplitView";
NSString * FKModuleFullStyleMultipleObjectsFilterBarIdentifier = @"FullStyleMultipleObjectsFilterBar";
NSString * FKModuleFullStyleMultipleObjectsLeftTableViewName = @"FullStyleMultipleObjectsLeftTableView";

NSString * FKModuleFullStyleSingleObjectSplitViewName = @"FullStyleSingleObjecsSplitView";

@implementation FKModule (FullStyle)

- (void)setupLayoutUsingFullStyle {		
	NSRect moduleViewFrame = NSBigRect();
	
	self.moduleView = [[[FKView alloc] initWithFrame:moduleViewFrame] autorelease];
	
	[moduleView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];	
		
	// setupMultipleObjectsViewWithFrame
	
	[self setupMultipleObjectsViewWithFrame:moduleViewFrame];
	
	// setupSingleObjectViewWithFrame
	
	[self setupSingleObjectViewWithFrame:moduleViewFrame];
	
	[moduleView addSubview:multipleObjectsView];	
	
	[multipleObjectsSplitView setAutosaveName:[NSString stringWithFormat:@"%@%@", self.name, FKModuleFullStyleMultipleObjectsSplitViewName]];	
	[singleObjectSplitView setAutosaveName:[NSString stringWithFormat:@"%@%@", self.name, FKModuleFullStyleSingleObjectSplitViewName]];
	
	[self finalizeSetupModuleViewUsingFullStyle];
	
	self.moduleStyle = FKModuleFullStyle;
}

#pragma mark -
#pragma mark LAYOUT : multipleObjectsView

- (NSRect)setupMultipleObjectsViewWithFrame:(NSRect)moduleViewFrame {	
	NSRect multipleObjectsViewFrame = moduleViewFrame;
	
	[multipleObjectsView setFrame:multipleObjectsViewFrame];
	[multipleObjectsView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	multipleObjectsViewFrame = [self setupMultipleObjectsFilterBarWithFrame:multipleObjectsViewFrame];
	multipleObjectsViewFrame = [self setupMultipleObjectsFooterBarWithFrame:multipleObjectsViewFrame];
	multipleObjectsViewFrame = [self setupMultipleObjectsSplitViewWithFrame:multipleObjectsViewFrame];
	
	return multipleObjectsViewFrame;
}

- (NSRect)setupMultipleObjectsFilterBarWithFrame:(NSRect)multipleObjectsViewFrame {	
	NSRect filterBarFrame = multipleObjectsViewFrame;	
	
	NSDivideRect(multipleObjectsViewFrame, &filterBarFrame, &multipleObjectsViewFrame, 30.0, NSMaxYEdge);
	
	[multipleObjectsFilterBar setFrame:filterBarFrame];
	[multipleObjectsFilterBar setAutoresizingMask:(NSViewWidthSizable | NSViewMinYMargin)];		
	[multipleObjectsFilterBar setIdentifier:[NSString stringWithFormat:@"%@%@", self.name, FKModuleFullStyleMultipleObjectsFilterBarIdentifier]];

	[multipleObjectsView addSubview:multipleObjectsFilterBar];
	
	return multipleObjectsViewFrame;
}

- (NSRect)setupMultipleObjectsFooterBarWithFrame:(NSRect)multipleObjectsViewFrame {	
	NSRect footerBarFrame = multipleObjectsViewFrame;	
	
	NSDivideRect(multipleObjectsViewFrame, &footerBarFrame, &multipleObjectsViewFrame, 56.0, NSMinYEdge);		
	
	// multipleObjectsFooterBar
	
	[multipleObjectsFooterBar setFrame:footerBarFrame];
	[multipleObjectsFooterBar setAutoresizingMask:(NSViewWidthSizable | NSViewMaxYMargin)];		
		
	// multipleObjectsToolbar
	
	[multipleObjectsToolbar setFrame:footerBarFrame];	
	[multipleObjectsToolbar setAutoresizingMask:NSViewWidthSizable];
	
	// addSubview
	
	[multipleObjectsFooterBar addSubview:multipleObjectsToolbar];
	[multipleObjectsView addSubview:multipleObjectsFooterBar];	
	
	return multipleObjectsViewFrame;
}

- (NSRect)setupMultipleObjectsSplitViewWithFrame:(NSRect)multipleObjectsViewFrame {
	NSRect splitViewFrame = multipleObjectsViewFrame;
	NSRect splitViewBounds = NSZeroRect;
		
	[multipleObjectsSplitView setFrame:splitViewFrame];
	[multipleObjectsSplitView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	[multipleObjectsView addSubview:multipleObjectsSplitView];
	
	splitViewBounds = [multipleObjectsSplitView bounds];
	
	[self setupMultipleObjectsLeftPlaceholderViewWithFrame:splitViewBounds];
	[self setupMultipleObjectsRightPlaceholderViewWithFrame:splitViewBounds];
	
	return splitViewFrame;
}

- (NSRect)setupMultipleObjectsLeftPlaceholderViewWithFrame:(NSRect)multipleObjectSplitViewFrame {	
	NSRect listViewFrame = multipleObjectSplitViewFrame;
		
	[multipleObjectsLeftPlaceholderView setFrame:listViewFrame]; 
	
	// multipleObjectsLeftScrollView
	
	NSRect scrollViewRect = NSInsetRect(listViewFrame, -1.0, -1.0);
	
	[multipleObjectsLeftScrollView setFrame:scrollViewRect];
	[multipleObjectsLeftScrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	[multipleObjectsLeftTableView setFrame:listViewFrame];		
	[multipleObjectsLeftTableView setAutosaveName:[NSString stringWithFormat:@"%@%@", self.name, FKModuleFullStyleMultipleObjectsLeftTableViewName]];

	[multipleObjectsLeftPlaceholderView addSubview:multipleObjectsLeftScrollView];
	
	[multipleObjectsSplitView addSubview:multipleObjectsLeftPlaceholderView];
	
	return listViewFrame;
}

- (NSRect)setupMultipleObjectsRightPlaceholderViewWithFrame:(NSRect)multipleObjectsSplitViewFrame {
	NSRect rightPlaceholderViewFrame = multipleObjectsSplitViewFrame;
	
	rightPlaceholderViewFrame.size.width = multipleObjectsRightMinWidth;
	
	[multipleObjectsRightPlaceholderView setFrame:rightPlaceholderViewFrame]; 
	
	// multipleObjectsRightScrollView
	
	NSRect scrollViewRect = rightPlaceholderViewFrame;
	
	[multipleObjectsRightScrollView setFrame:scrollViewRect];
	[multipleObjectsRightScrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	[multipleObjectsRightStackView setFrame:rightPlaceholderViewFrame];
		
	[multipleObjectsRightPlaceholderView addSubview:multipleObjectsRightScrollView];
	[multipleObjectsSplitView addSubview:multipleObjectsRightPlaceholderView];	
	
	[self setupMultipleObjectsRightStackViewWithFrame:rightPlaceholderViewFrame];
	
	return rightPlaceholderViewFrame;
}

- (NSRect)setupMultipleObjectsRightStackViewWithFrame:(NSRect)multipleObjectsView_DetailsViewFrame {
	NSRect stackViewFrame = multipleObjectsView_DetailsViewFrame;
	
	[multipleObjectsRightStackView setFrame:stackViewFrame];
	[multipleObjectsRightStackView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		
	return stackViewFrame;
}

#pragma mark -
#pragma mark LAYOUT : singleObjectView

- (NSRect)setupSingleObjectViewWithFrame:(NSRect)moduleViewFrame {	
	NSRect singleObjectViewFrame = moduleViewFrame;
		
	[singleObjectView setFrame:singleObjectViewFrame];
	[singleObjectView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	// *********************
	// singleObjectFooterBar
	// *********************
	
	singleObjectViewFrame = [self setupSingleObjectFooterBarWithFrame:singleObjectViewFrame];
	
	// *********************
	// singleObjectSplitView
	// *********************
		
	singleObjectViewFrame = [self setupSingleObjectSplitViewWithFrame:singleObjectViewFrame];
	
	return singleObjectViewFrame;	
}

- (NSRect)setupSingleObjectSplitViewWithFrame:(NSRect)singleObjectViewFrame {
	NSRect splitViewFrame = singleObjectViewFrame;
	NSRect splitViewBounds = NSZeroRect;
	
	[singleObjectSplitView setFrame:splitViewFrame];
	[singleObjectSplitView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];	
	
	[singleObjectView addSubview:singleObjectSplitView];
		
	splitViewBounds = [singleObjectSplitView bounds];
	
	[self setupSingleObjectLeftPlaceholderViewWithFrame:splitViewBounds];
	[self setupSingleObjectRightPlaceholderViewWithFrame:splitViewBounds];
	
	return NSZeroRect;
}	

- (NSRect)setupSingleObjectLeftPlaceholderViewWithFrame:(NSRect)singleObjectSplitViewFrame {
	[singleObjectLeftPlaceholderView setFrame:singleObjectSplitViewFrame];
	
	// singleObjectLeftTabView	
	
	[singleObjectLeftTabView setFrame:singleObjectSplitViewFrame];
	[singleObjectLeftTabView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[singleObjectLeftTabView setDelegate:self];
	
	[singleObjectLeftPlaceholderView addSubview:singleObjectLeftTabView];
	[singleObjectSplitView addSubview:singleObjectLeftPlaceholderView];	

	return singleObjectSplitViewFrame;
}

- (NSRect)setupSingleObjectRightPlaceholderViewWithFrame:(NSRect)singleObjectSplitViewFrame {	
	[singleObjectRightPlaceholderView setFrame:singleObjectSplitViewFrame];
	
	// singleObjectRightTabView
	
	[singleObjectRightTabView setFrame:singleObjectSplitViewFrame];
	[singleObjectRightTabView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[singleObjectRightTabView setDelegate:self];
	
	[singleObjectRightPlaceholderView addSubview:singleObjectRightTabView];
	[singleObjectSplitView addSubview:singleObjectRightPlaceholderView];
	
	return singleObjectSplitViewFrame;
}

- (NSRect)setupSingleObjectFooterBarWithFrame:(NSRect)singleObjectViewFrame {	
	NSRect footerBarFrame = NSZeroRect;	
	NSRect toolbarFrame = NSZeroRect;
	
	NSDivideRect(singleObjectViewFrame, &footerBarFrame, &singleObjectViewFrame, 56.0, NSMinYEdge);		
	
	[singleObjectFooterBar setFrame:footerBarFrame];
	
	[singleObjectView addSubview:singleObjectFooterBar];	
	
	// singleObjectToolbar
	
	[singleObjectFooterBar addSubview:singleObjectToolbar];
	
	// ...
	
	toolbarFrame = footerBarFrame;
	
	[singleObjectToolbar setFrame:toolbarFrame];
	
	// ...
	
	return singleObjectViewFrame;
}

#pragma mark -
#pragma mark LAYOUT

- (void)finalizeSetupModuleViewUsingFullStyle {
	[multipleObjectsLeftTableView sizeLastColumnToFit];
}

@end
