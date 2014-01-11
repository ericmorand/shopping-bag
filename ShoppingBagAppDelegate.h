//
//  Shopping_Bag_AppDelegate.h
//  ShoppingBag
//
//  Created by alt on 04/11/06.
//  Copyright Eric Morand 2006. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class PreferencesController;

@interface ShoppingBagAppDelegate : FKAppDelegate
{
	PreferencesController *		preferencesController;
		
	NSWindow *					progressWindow;
	NSProgressIndicator *		progressIndicator;
	NSTextField *				progressMessageTextField;
}

@property (nonatomic, retain) PreferencesController *			preferencesController;
@property (nonatomic, retain) IBOutlet NSWindow *				progressWindow;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *	progressIndicator;
@property (nonatomic, retain) IBOutlet NSTextField *			progressMessageTextField;

- (IBAction)import:(id)sender;
- (IBAction)importSales:(id)sender;
- (IBAction)export:(id)sender;
- (IBAction)openPreferences:(id)sender;

- (IBAction)printDailyZ:(id)sender;
- (IBAction)printStockValue:(id)sender;
- (IBAction)recalculateStock:(id)sender;
- (IBAction)exportDailyZ:(id)sender;

@end
