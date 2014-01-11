//
//  FKNavigationToolbarItem.h
//  FK
//
//  Created by Eric on 07/03/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKToolbarItemButton.h"

@interface FKNavigationToolbarItem : NSToolbarItem
{
	FKToolbarItemButton *		previousButton;
	FKToolbarItemButton *		nextButton;
}

- (void)setPreviousAction:(SEL)aSelector;
- (void)setNextAction:(SEL)aSelector;

- (void)setPreviousEnabled:(BOOL)flag;
- (void)setNextEnabled:(BOOL)flag;

@property (retain) FKToolbarItemButton *		previousButton;
@property (retain) FKToolbarItemButton *		nextButton;
@end
