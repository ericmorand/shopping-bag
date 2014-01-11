//
//  InventoriesModule.h
//  ShoppingBag
//
//  Created by Eric on 01/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "SBModule.h"
#import "Inventory.h"

@interface InventoriesModule : SBModule
{
	IBOutlet NSView *		generalInformationsView;
	IBOutlet NSView *		beginStockView;
	IBOutlet NSView *		endStockView;	
	IBOutlet NSView *		stockVariationsView;
	
	int						selectedTag;
}

- (IBAction)runSelectedInventory:(id)sender;
- (IBAction)stopSelectedInventory:(id)sender;

@property (retain) NSView *		generalInformationsView;
@property (retain) NSView *		beginStockView;
@property (retain) NSView *		endStockView;
@property (retain) NSView *		stockVariationsView;
@property int						selectedTag;
@end
