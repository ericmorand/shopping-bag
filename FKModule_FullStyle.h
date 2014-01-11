//
//  FKModule_FullStyle.h
//  FKKit
//
//  Created by Eric on 12/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKModule (FullStyle)

- (NSRect)setupMultipleObjectsViewWithFrame:(NSRect)moduleViewFrame;
- (NSRect)setupMultipleObjectsFilterBarWithFrame:(NSRect)multipleObjectsViewFrame;
- (NSRect)setupMultipleObjectsFooterBarWithFrame:(NSRect)multipleObjectsViewFrame;
- (NSRect)setupMultipleObjectsSplitViewWithFrame:(NSRect)multipleObjectsViewFrame;
- (NSRect)setupMultipleObjectsLeftPlaceholderViewWithFrame:(NSRect)multipleObjectSplitViewFrame;
- (NSRect)setupMultipleObjectsRightPlaceholderViewWithFrame:(NSRect)multipleObjectsSplitViewFrame;
- (NSRect)setupMultipleObjectsRightStackViewWithFrame:(NSRect)multipleObjectsView_DetailsViewFrame;

- (NSRect)setupSingleObjectViewWithFrame:(NSRect)moduleViewFrame;
- (NSRect)setupSingleObjectFooterBarWithFrame:(NSRect)singleObjectViewFrame;
- (NSRect)setupSingleObjectSplitViewWithFrame:(NSRect)singleObjectViewFrame;
- (NSRect)setupSingleObjectLeftPlaceholderViewWithFrame:(NSRect)singleObjectSplitViewFrame;
- (NSRect)setupSingleObjectRightPlaceholderViewWithFrame:(NSRect)singleObjectSplitViewFrame;

- (void)finalizeSetupModuleViewUsingFullStyle;

@end
