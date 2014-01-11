//
//  FKModule.h
//  FKKit
//
//  Created by Eric on 01/08/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKModuleToolbar.h"

@class FKButton;
@class FKModuleFilterBar;
@class FKModuleGradientTextField;
@class FKModulePlateToolbar;
@class FKSplitView;
@class FKStackView;
@class FKTableView;
@class FKTabView;
@class FKView;

extern NSString * FKModuleSearchBarIdentifier;
extern NSString * FKModuleInformationsHeaderViewIdentifier;

typedef enum _FKModuleMode {
	FKModuleMultipleObjectsMode = 0,
	FKModuleSingleObjectMode = 1
} FKModuleMode;

typedef enum _FKModuleStyle {
	FKModuleNoStyle = -1,
	FKModuleFullStyle = 0,
	FKModuleBrowserStyle = 1,
	FKModuleMiniStyle = 2
} FKModuleStyle;

extern NSString * FKModuleDisplayModeOneColumnIdentifier;
extern NSString * FKModuleDisplayModeTwoColumnsIdentifier;

typedef enum _FreakModuleHasChangesPendingResult {
	FKModuleHasChangesPendingNO = 0,
	FKModuleHasChangesPendingYES = 1,
	FKModuleHasChangesPendingMAYBE = 2
} FKModuleHasChangesPendingResult;

extern NSString * FKModuleDoesHaveChangesPendingNotification;
extern NSString * FKModuleDoesntHaveChangesPendingNotification;

@interface FKModule : NSObject
{
	NSManagedObjectContext *			managedObjectContext;	
	NSResponder *						firstResponder;
	FKManagedArrayController *			objectsArrayController;
	NSArray *							objectsArrayControllerSortDescriptors;
	NSUInteger							objectsCount;
	FKModuleMode						moduleMode;
	FKModuleStyle						moduleStyle;
	NSToolbar *							mainToolbar;
	NSWindow *							printDialogWindow;
	NSPredicate *						modulePredicate;	
	NSPredicate *						filterBarPredicate;
	NSPredicate *						searchFieldPredicate;
	NSPredicate *						filterPredicate;
	id									delegate;
	BOOL								needsLayout;
	
	NSSearchField *mainSearchField;
	
	// **********
	// moduleView
	// **********	
	
	FKView *							moduleView;
	FKView *							miniModuleView;
	FKView *							browserModuleView;
	FKWindow *							browserWindow;
	
	// *******************
	// multipleObjectsView
	// *******************
	
	FKView *							multipleObjectsView;		
	FKModuleFilterBar *					multipleObjectsFilterBar;
	FKView *							multipleObjectsFooterBar;
	FKModuleToolbar *					multipleObjectsToolbar;
	BOOL								multipleObjectsFilterBarIsVisible;
	FKSplitView *						multipleObjectsSplitView;
	
	FKView *							multipleObjectsLeftPlaceholderView;
	FKTableView *						multipleObjectsLeftTableView;
	NSScrollView *						multipleObjectsLeftScrollView;
	//float								multipleObjectsLeftMinWidth;
	
	FKView *							multipleObjectsRightPlaceholderView;
	FKStackView *						multipleObjectsRightStackView;
	NSScrollView *						multipleObjectsRightScrollView;
	//float								multipleObjectsRightMinWidth;
	
	// ****************
	// singleObjectView
	// ****************
	
	FKView *							singleObjectView;
	FKModuleBottomBar *					singleObjectFooterBar;
	FKModuleToolbar *					singleObjectToolbar;
	FKSplitView *						singleObjectSplitView;
	
	FKView *							singleObjectLeftPlaceholderView;
	NSView *							singleObjectLeftView;
	FKTabView *							singleObjectLeftTabView;
	NSScrollView *						singleObjectLeftScrollView;
	float								singleObjectLeftMinWidth;
	
	FKView *							singleObjectRightPlaceholderView;
	FKTabView *							singleObjectRightTabView;
	float								singleObjectRightMinWidth;

	// ************
	// browserStyle
	// ************
	
	FKView *							browserWindowBorderedView;
	FKModuleBottomBar *					browserWindowBottomBar;
	FKPlateGradientButton *				browserWindowCancelButton;
	FKPlateGradientButton *				browserWindowSubmitButton;
	
	// *********
	// miniStyle
	// *********
	
	NSView *							miniStyleInformationsView;
	NSSearchField *						miniStyleSearchField;
	
	id									currentObject;
	
	// *******************
	// exportAccessoryView
	// *******************
	
	NSView *							exportAccessoryView;
}

@property (nonatomic, retain) NSSearchField *mainSearchField;

@property (nonatomic, retain) IBOutlet NSResponder * firstResponder;
@property (nonatomic, retain) IBOutlet FKManagedArrayController * objectsArrayController;
@property (retain) NSArray * objectsArrayControllerSortDescriptors;
@property (assign) NSUInteger objectsCount;
@property (assign) NSManagedObjectContext * managedObjectContext;
@property (assign) id delegate;
@property (assign) BOOL needsLayout;

@property (retain) FKView * moduleView;
@property (retain) FKView * miniModuleView;
@property (retain) FKView * browserModuleView;
@property (retain) FKWindow * browserWindow;

@property (assign) FKModuleMode moduleMode;
@property (assign) FKModuleStyle moduleStyle;
@property (retain) NSPredicate * modulePredicate;
@property (retain) NSPredicate * filterBarPredicate;
@property (retain) NSPredicate * searchFieldPredicate;
@property (retain) NSPredicate * filterPredicate;
@property (retain) NSToolbar * mainToolbar;
@property (nonatomic, retain) IBOutlet NSWindow * printDialogWindow;

@property (retain) FKView * multipleObjectsView;
@property (retain) FKModuleFilterBar * multipleObjectsFilterBar;
@property (retain) FKView * multipleObjectsFooterBar;
@property (retain) FKModuleToolbar * multipleObjectsToolbar;
@property (assign) BOOL multipleObjectsFilterBarIsVisible;
@property (retain) FKSplitView * multipleObjectsSplitView;
@property (retain) FKView * multipleObjectsLeftPlaceholderView;
@property (nonatomic, retain) IBOutlet FKTableView * multipleObjectsLeftTableView;
@property (retain) NSScrollView * multipleObjectsLeftScrollView;
//@property (assign) float multipleObjectsLeftMinWidth;
@property (retain) FKView * multipleObjectsRightPlaceholderView;
@property (retain) FKStackView * multipleObjectsRightStackView;
@property (retain) NSScrollView * multipleObjectsRightScrollView;
//@property (assign) float multipleObjectsRightMinWidth;

@property (nonatomic, retain) FKView * singleObjectView;
@property (nonatomic, retain) FKModuleBottomBar * singleObjectFooterBar;
@property (nonatomic, retain) FKModuleToolbar * singleObjectToolbar;
@property (nonatomic, retain) NSSplitView * singleObjectSplitView;

@property (nonatomic, retain) FKView * singleObjectLeftPlaceholderView;
@property (nonatomic, retain) FKTabView * singleObjectLeftTabView;
@property (nonatomic, retain) NSView * singleObjectLeftView;
@property (nonatomic, retain) NSScrollView * singleObjectLeftScrollView;
@property (assign) float singleObjectLeftMinWidth;

@property (nonatomic, retain) FKView * singleObjectRightPlaceholderView;
@property (nonatomic, retain) FKTabView * singleObjectRightTabView;
@property (assign) float singleObjectRightMinWidth;

@property (retain) FKView * browserWindowBorderedView;
@property (retain) FKModuleBottomBar * browserWindowBottomBar;
@property (retain) FKPlateGradientButton * browserWindowCancelButton;
@property (retain) FKPlateGradientButton * browserWindowSubmitButton;

@property (nonatomic, retain) IBOutlet NSView * miniStyleInformationsView;
@property (nonatomic, retain) NSSearchField * miniStyleSearchField;

@property (nonatomic, assign) id currentObject;

@property (readonly) NSString * name;
@property (readonly) NSString * entityName;
@property (readonly) NSString * statusString;
@property (readonly) NSWindow * window;
@property (readonly) NSString * mainSortKey;

@property (nonatomic, retain) IBOutlet NSView * exportAccessoryView;

+ (id)moduleWithContext:(NSManagedObjectContext *)aContext;
+ (id)moduleWithContext:(NSManagedObjectContext *)aContext userInfo:(NSDictionary *)aDictionary;
- (id)initWithContext:(NSManagedObjectContext *)aContext userInfo:(NSDictionary *)aDictionary;

- (BOOL)moduleViewFilterBarIsVisible;

- (FKModuleHasChangesPendingResult)hasChangesPending;
- (void)replyToHasChangesPending:(BOOL)flag;
- (void)updateUI;

- (void)willSelect;
- (void)didSelect;
- (void)willUnselect;
- (void)didUnselect;

- (void)switchToSingleObjectMode;
- (void)switchToMultipleObjectsMode;

// Search field

- (NSArray *)searchFieldDisplayNames;
- (NSArray *)searchFieldPredicateFormats;
- (NSArray *)detailsViewTabViewItems;
- (void)unbindSearchField:(NSSearchField *)searchField;
- (void)bindSearchField:(NSSearchField *)searchField;

// Managed objects support

- (void)addObject;
- (void)addObjects:(NSArray *)objects;
- (void)deleteSelectedObjects;
- (void)selectObjects:(NSArray *)objects;

// Actions

- (IBAction)export:(id)sender;
- (IBAction)print:(id)sender;
- (IBAction)closePrintDialogSheet:(id)sender;

- (void)printDialogSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

- (void)presentError:(NSError *)error;
- (void)presentError:(NSError *)error modalForWindow:(NSWindow *)aWindow delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo;

- (NSString *)csvStringForValue:(id)object;
- (NSString *)csvStringForValue:(id)object formatter:(NSFormatter *)formatter;

@end
