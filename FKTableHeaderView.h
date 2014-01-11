//
//  FKTableHeaderView.h
//  FK
//
//  Created by Eric Morand on Thu Apr 08 2004.
//  Copyright (c) 2004 Eric Morand. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FKTableHeaderView : NSTableHeaderView
{
	NSMenu *	defaultMenu;
}

- (id)tableView;
- (NSMenu *)defaultMenu;

- (void)setDefaultMenu:(NSMenu *)aMenu;
- (void)createDefaultMenu;

- (void)toggleColumn:(NSMenuItem *)anItem;
- (void)setMenuItemState:(NSMenuItem *)anItem;

@property (retain,getter=defaultMenu,setter=setDefaultMenu:) NSMenu *	defaultMenu;
@end
