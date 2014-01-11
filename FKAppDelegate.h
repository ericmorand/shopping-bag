//
//  FKAppDelegate.h
//  FKKit
//
//  Created by alt on 23/09/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FKButton;
@class FKModule;
@class FKModuleBottomBar;
@class NSSplitView;
@class NSTextField;
@class FKSourceListItem;
@class FKView;

@interface FKAppDelegate : NSWindowController
{
	id									persistentStore;
    NSPersistentStoreCoordinator *		persistentStoreCoordinator;
    NSManagedObjectModel *				managedObjectModel;
    NSManagedObjectContext *			managedObjectContext;
		
	FKSourceListItem *					draggedItem;
	NSDragOperation						dragOperation;
	
	NSToolbar *							mainToolbar;
	NSSearchField *						mainToolbarSearchField;

	// ******
	// Layout
	// ******
	
	FKView *							mainView;
	NSSplitView *						splitView;

	// footerView
	
	FKView *							footerView;
	NSTextField *						statusLabel;
	
	// menuView
	
	FKView *							menuView;
	
	NSOutlineView *						sourceList;
	NSTreeController *					sourceListTreeController;
	NSArray *							sourceListNodes;
	
	FKModuleBottomBar *					menuViewBottomBar;
	FKButton *							menuViewAddButton;
	FKButton *							menuViewActionButton;
	
	// moduleContentView	
	
	FKView *							moduleContentView;
	
	// ...
	
	float								menuViewMinWidth;
	float								moduleViewMinWidth;
	
	// ...
	
	NSMutableArray *					modulesArray;
	FKModule *							currentModule;
	FKModule *							nextModule;
}

@property (nonatomic, retain) NSToolbar *			mainToolbar;
@property (nonatomic, retain) NSSearchField *		mainToolbarSearchField;

@property (nonatomic, retain) FKView *				footerView;
@property (nonatomic, retain) NSTextField *			statusLabel;

@property (nonatomic, retain) NSOutlineView *		sourceList;
@property (nonatomic, retain) NSTreeController *	sourceListTreeController;
@property (nonatomic, retain) NSArray *				sourceListNodes;

@property (retain) id							persistentStore;
@property (retain) FKSourceListItem *			draggedItem;
@property NSDragOperation						dragOperation;
@property float									menuViewMinWidth;
@property float									moduleViewMinWidth;

@property (nonatomic, retain) NSMutableArray *	modulesArray;
@property (nonatomic, assign) FKModule *		currentModule;
@property (nonatomic, assign) FKModule *		nextModule;

- (void)launchFirstExecution;
- (void)updateDefaultObjects;

// Layout

- (void)setSplitView:(NSSplitView *)aView;

- (void)setMenuView:(FKView *)aView;
- (void)setMenuViewBottomBar:(FKModuleBottomBar *)aView;
- (void)setMenuViewAddButton:(FKButton *)aButton;
- (void)setMenuViewActionButton:(FKButton *)aButton;

- (void)setModuleContentView:(FKView *)aView;
- (void)setModuleInformationsDetailView:(NSView *)aView;

- (void)setupMainViewInRect:(NSRect)rect;

- (FKModule *)moduleNamed:(NSString *)moduleName;

// Core Data support

- (NSURL *)persistentStoreURL;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (void)insertDefaultSmartGroupNodes;

- (IBAction)print:(id)sender;
- (IBAction)saveAction:sender;
- (IBAction)openPreferences:(id)sender;
- (IBAction)beginSearch:(id)sender;

// ...

- (void)currentModuleHasAcceptedToUnselect;

@end
