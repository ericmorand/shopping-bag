//
//  FKManagedObjectsManager.h
//  ShoppingBag
//
//  Created by Eric on 06/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FKStackableView.h"
#import "FKStackView.h"
#import "FKWindow.h"

@class FKButton;
@class FKTableView;
@class FKView;

@interface FKManagedObjectsManager : NSObject
{
	IBOutlet NSArrayController *	objectsArrayController;
	
	NSManagedObjectContext *		managedObjectContext; // Not retained
	NSArray *						sortDescriptors;
	
	float							listViewMinWidth;
	float							informationsViewMinWidth;
	
	// ***********
	// browserView
	// ***********
	
	FKView *						browserView;
	
	FKView *						browserViewBorderedView;
	NSSplitView *					browserViewSplitView;
	FKModuleBottomBar *				browserViewBottomBar;
	FKButton *						browserViewPlusButton;
	FKButton *						browserViewMinusButton;
	NSSearchField *					browserViewSearchField;
	
	// listView
	
	FKView *						listView;

	NSScrollView *					listViewScrollView;
	IBOutlet FKTableView *			listViewTableView;
	
	// informationsView
	
	FKView *						informationsView;
	
	NSScrollView *					informationsViewScrollView;
	FKStackView *					informationsViewStackView;
	
	// ***************
	// miniBrowserView
	// ***************
	
	FKView *						miniBrowserView;

	NSScrollView *					miniBrowserTableScrollView;
	IBOutlet FKTableView *			miniBrowserTableView;
	IBOutlet NSView *				miniBrowserInformationsView;
	
	// *************
	// browserWindow
	// *************
	
	FKWindow *						browserWindow;
	
	FKView *						browserWindowBorderedView;
	FKModuleBottomBar *				browserWindowBottomBar;
	FKPlateGradientButton *			browserWindowCancelButton;
	FKPlateGradientButton *			browserWindowSubmitButton;
}

+ (id)defaultManagerWithManagedObjectContext:(NSManagedObjectContext *)aContext;

+ (NSString *)entityName;
- (FKView *)browserView;
- (FKView *)miniBrowserView;
- (FKWindow *)browserWindow;
- (NSArray *)sortDescriptors;
- (NSArray *)selectedObjects;

- (void)setManagedObjectContext:(NSManagedObjectContext *)aContext;
- (void)setSortDescriptors:(NSArray *)anArray;

- (void)browserWindowCancelButtonAction:(id)sender;
- (void)browserWindowSubmitButtonAction:(id)sender;

- (id)managedObjectWithValue:(id)value forKey:(NSString *)key;
- (void)showBrowserSheetModalForWindow:(NSWindow *)aWindow selectedObjects:(NSArray **)selectedObjects;
- (int)showInexistantObjectAlertSheetWithName:(NSString *)objectName modalForWindow:(NSWindow *)aWindow;

- (void)addObjects:(NSArray *)objects;
- (void)selectObjects:(NSArray *)objects;

@property (retain) NSArrayController *	objectsArrayController;
@property float							listViewMinWidth;
@property float							informationsViewMinWidth;
@property (retain) FKView *						browserViewBorderedView;
@property (retain) NSSplitView *					browserViewSplitView;
@property (retain) FKModuleBottomBar *				browserViewBottomBar;
@property (retain) FKButton *						browserViewPlusButton;
@property (retain) FKButton *						browserViewMinusButton;
@property (retain) NSSearchField *					browserViewSearchField;
@property (retain) FKView *						listView;
@property (retain) NSScrollView *					listViewScrollView;
@property (retain) FKTableView *			listViewTableView;
@property (retain) FKView *						informationsView;
@property (retain) NSScrollView *					informationsViewScrollView;
@property (retain) FKStackView *					informationsViewStackView;
@property (retain) NSScrollView *					miniBrowserTableScrollView;
@property (retain) FKTableView *			miniBrowserTableView;
@property (retain) NSView *				miniBrowserInformationsView;
@property (retain) FKView *						browserWindowBorderedView;
@property (retain) FKModuleBottomBar *				browserWindowBottomBar;
@property (retain) FKPlateGradientButton *			browserWindowCancelButton;
@property (retain) FKPlateGradientButton *			browserWindowSubmitButton;
@end
