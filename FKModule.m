//
//  FKModule.m
//  FKKit
//
//  Created by Eric on 01/08/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import "FKModule.h"
#import "FKModule_MiniStyle.h"
#import "FKModuleFilterBar.h"
#import "FKNavigationToolbarItem.h"
#import "FKStackView.h"
#import "FKView.h"

NSString * FKModuleDoesHaveChangesPendingNotification = @"FKModuleDoesHaveChangesPendingNotification";
NSString * FKModuleDoesntHaveChangesPendingNotification = @"FKModuleDoesntHaveChangesPendingNotification";
NSString * FKModuleDisplayModeOneColumnIdentifier = @"FKModuleDisplayModeOneColumn";
NSString * FKModuleDisplayModeTwoColumnsIdentifier = @"FKModuleDisplayModeTwoColumns";

#define multipleObjectsLeftMinWidth 400.0
#define multipleObjectsRightMinWidth 400.0

@interface FKModule (Private)

- (void)loadNibFile;

- (void)setupMultipleObjectsSearchField;
- (void)updateMultipleObjectsFilterPredicate;

- (void)setupLayoutUsingModuleStyle:(FKModuleStyle)style;
- (void)setupLayoutUsingFullStyle;
- (void)setupLayoutUsingMiniStyle;
- (void)setupLayoutUsingBrowserStyle;

- (void)computeFilterPredicate;

@end

@implementation FKModule

@synthesize mainSearchField;

@synthesize firstResponder;
@synthesize objectsArrayController;
@synthesize objectsArrayControllerSortDescriptors;
@synthesize objectsCount;
@synthesize managedObjectContext;
@synthesize delegate;
@synthesize needsLayout;

@synthesize moduleView;
@synthesize miniModuleView;
@synthesize browserModuleView;
@synthesize browserWindow;

@synthesize moduleMode;
@synthesize moduleStyle;
@synthesize modulePredicate;
@synthesize filterBarPredicate;
@synthesize searchFieldPredicate;
@synthesize filterPredicate;
@synthesize mainToolbar;
@synthesize printDialogWindow;

@synthesize multipleObjectsView;
@synthesize multipleObjectsFilterBar;
@synthesize multipleObjectsFooterBar;
@synthesize multipleObjectsToolbar;
@synthesize multipleObjectsFilterBarIsVisible;
@synthesize multipleObjectsSplitView;
@synthesize multipleObjectsLeftPlaceholderView;
@synthesize multipleObjectsLeftTableView;
@synthesize multipleObjectsLeftScrollView;
//@synthesize multipleObjectsLeftMinWidth;
@synthesize multipleObjectsRightPlaceholderView;
@synthesize multipleObjectsRightStackView;
@synthesize multipleObjectsRightScrollView;
//@synthesize multipleObjectsRightMinWidth;

@synthesize singleObjectView;
@synthesize singleObjectFooterBar;
@synthesize singleObjectToolbar;
@synthesize singleObjectSplitView;

@synthesize singleObjectLeftPlaceholderView;
@synthesize singleObjectLeftView;
@synthesize singleObjectLeftTabView;
@synthesize singleObjectLeftScrollView;
@synthesize singleObjectLeftMinWidth;

@synthesize singleObjectRightPlaceholderView;
@synthesize singleObjectRightTabView;
@synthesize singleObjectRightMinWidth;

@synthesize browserWindowBorderedView;
@synthesize browserWindowBottomBar;
@synthesize browserWindowCancelButton;
@synthesize browserWindowSubmitButton;

@synthesize miniStyleInformationsView;
@synthesize miniStyleSearchField;

@synthesize exportAccessoryView;

@synthesize currentObject;

+ (NSSet *)keyPathsForValuesAffectingStatusString {
	return [NSSet setWithObjects:@"objectsCount", nil];
}

+ (NSSet *)keyPathsForValuesAffectingFilterPredicate {		
	return [NSSet setWithObjects:@"modulePredicate", @"filterBarPredicate", @"searchFieldPredicate", nil];
}

+ (id)moduleWithContext:(NSManagedObjectContext *)aContext {
	return [[[[self class] alloc] initWithContext:aContext userInfo:nil] autorelease];
}

+ (id)moduleWithContext:(NSManagedObjectContext *)aContext userInfo:(NSDictionary *)aDictionary {
	return [[[[self class] alloc] initWithContext:aContext userInfo:aDictionary] autorelease];
}

- (id)initWithContext:(NSManagedObjectContext *)aContext userInfo:(NSDictionary *)aDictionary {
	self = [super init];
	
	NSLog(@"initWithContext - moduleClass = %@", [self className]);
	
	if (nil != self)
	{
		[self loadNibFile];	
		
		[objectsArrayController addObserver:self forKeyPath:@"selectedObject" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];		
		[objectsArrayController addObserver:self forKeyPath:@"filterPredicate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];		
		
		// ********************
		// managedObjectContext
		// ********************
		
		self.managedObjectContext = aContext;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextUpdated:) name:NSManagedObjectContextObjectsDidChangeNotification object:managedObjectContext];
		
		// **********************
		// objectsArrayController
		// **********************
		
		[objectsArrayController setManagedObjectContext:self.managedObjectContext];
		[objectsArrayController setEntityName:self.entityName];
		//[objectsArrayController fetchWithRequest:nil merge:NO error:nil];
		
		[self bind:@"objectsCount" toObject:objectsArrayController withKeyPath:@"arrangedObjects.@count" options:nil];
		[self bind:@"currentObject" toObject:objectsArrayController withKeyPath:@"selectedObject" options:nil];
		[objectsArrayController bind:@"filterPredicate" toObject:self withKeyPath:@"filterPredicate" options:nil];
		[objectsArrayController bind:@"sortDescriptors" toObject:self withKeyPath:@"objectsArrayControllerSortDescriptors" options:nil];
		
		// miniStyleSearchField	
			
		self.miniStyleSearchField = [[[NSSearchField alloc] initWithFrame:NSZeroRect] autorelease];
		
		[[miniStyleSearchField cell] setSendsSearchStringImmediately:YES];
		
		[self bindSearchField:miniStyleSearchField];	
		
		// browserWindow

		self.browserWindow = [[[FKWindow alloc] initWithContentRect:NSMakeRect(0.0, 0.0, 400.0, 500.0)
														  styleMask:NSResizableWindowMask
															backing:NSBackingStoreBuffered
															  defer:NO] autorelease];
		
		[browserWindow setPostsFirstResponderChangedNotifications:YES];
		[browserWindow setMinSize:NSMakeSize(300.0, 400.0)];
		[browserWindow setMaxSize:NSMakeSize(500.0, 600.0)];
		[browserWindow setTitle:NSLocalizedString(self.name, @"")];	
		[browserWindow setDelegate:self];
		
		// *******************
		// multipleObjectsView
		// *******************
		
		self.multipleObjectsView = [[[FKView alloc] initWithFrame:NSZeroRect] autorelease];	
		self.multipleObjectsFilterBar = [[[FKModuleFilterBar alloc] initWithFrame:NSZeroRect] autorelease];
		
		[multipleObjectsFilterBar setDelegate:self];
		[multipleObjectsFilterBar bind:@"predicate" toObject:self withKeyPath:@"filterBarPredicate" options:nil];	
		
		// multipleObjectsFooterBar
		
		self.multipleObjectsFooterBar = [[[FKView alloc] initWithFrame:NSZeroRect] autorelease];	
		
		multipleObjectsFooterBar.borderColor = [NSColor strongBorderColor];
		multipleObjectsFooterBar.borderMask = FKTopBorder;
		
		// multipleObjectsToolbar
		
		self.multipleObjectsToolbar = [[[FKModuleToolbar alloc] initWithFrame:NSZeroRect] autorelease];
		
		[multipleObjectsToolbar setIdentifier:[NSString stringWithFormat:@"%@MultipleObjectsToolbar", self.name]];
		[multipleObjectsToolbar setDelegate:self];
		
		// multipleObjectsSplitView
		
		self.multipleObjectsSplitView = [[[FKSplitView alloc] initWithFrame:NSZeroRect] autorelease];
		
		[multipleObjectsSplitView setVertical:YES];
		[multipleObjectsSplitView setDividerStyle:NSSplitViewDividerStyleThin];
		[multipleObjectsSplitView setDelegate:self];
		
		self.multipleObjectsLeftPlaceholderView = [[[FKView alloc] initWithFrame:NSZeroRect] autorelease];
		
		// multipleObjectsLeftScrollView
		
		self.multipleObjectsLeftScrollView = [[[NSScrollView alloc] initWithFrame:NSBigRect()] autorelease];
		
		[multipleObjectsLeftScrollView setBorderType:NSBezelBorder];
		[multipleObjectsLeftScrollView setHasHorizontalScroller:YES];
		[multipleObjectsLeftScrollView setHasVerticalScroller:YES];
		[multipleObjectsLeftScrollView setAutohidesScrollers:YES];
		
		// multipleObjectsLeftTableView
		
		[multipleObjectsLeftTableView setFrame:NSBigRect()];
		[multipleObjectsLeftTableView setDelegate:self];
		[multipleObjectsLeftTableView setDataSource:self]; // DRAG'N'DROP
		[multipleObjectsLeftTableView setTarget:self];
		[multipleObjectsLeftTableView setDoubleAction:@selector(listViewTableViewDoubleAction:)];
		[multipleObjectsLeftTableView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
		[multipleObjectsLeftTableView setAutosaveTableColumns:YES];
		
		[multipleObjectsLeftScrollView setDocumentView:multipleObjectsLeftTableView];	
		
		// multipleObjectsRightPlaceholderView
		
		self.multipleObjectsRightPlaceholderView = [[[FKView alloc] initWithFrame:NSZeroRect] autorelease];
		
		// multipleObjectsRightScrollView
		
		self.multipleObjectsRightScrollView = [[[NSScrollView alloc] initWithFrame:NSBigRect()] autorelease];
		
		[multipleObjectsRightScrollView setBorderType:NSBezelBorder];
		[multipleObjectsRightScrollView setHasHorizontalScroller:YES];
		[multipleObjectsRightScrollView setHasVerticalScroller:YES];
		[multipleObjectsRightScrollView setAutohidesScrollers:YES];	
		[multipleObjectsRightScrollView setBorderType:NSNoBorder];
		
		// multipleObjectsRightStackView
		
		self.multipleObjectsRightStackView = [[[FKStackView alloc] initWithFrame:NSBigRect()] autorelease];
	
		[multipleObjectsRightStackView setBackgroundColor:[NSColor colorWithDeviceRed:234.0/255.0 green:240.0/255.0 blue:249.0/255.0 alpha:1.0]];	
		[multipleObjectsRightStackView setDelegate:self];
		
		[multipleObjectsRightScrollView setDocumentView:multipleObjectsRightStackView];
		
		//self.multipleObjectsLeftMinWidth = 350.0;
		//self.multipleObjectsRightMinWidth = 350.0;
			
		// ****************
		// singleObjectView
		// ****************
		
		self.singleObjectView = [[[FKView alloc] initWithFrame:NSZeroRect] autorelease];
		self.singleObjectFooterBar = [[[FKModuleBottomBar alloc] initWithFrame:NSZeroRect] autorelease];	
		
		[singleObjectFooterBar setAutoresizingMask:(NSViewWidthSizable | NSViewMaxYMargin)];		
		
		self.singleObjectToolbar = [[[FKModuleToolbar alloc] initWithFrame:NSZeroRect] autorelease];
		
		[singleObjectToolbar setIdentifier:[NSString stringWithFormat:@"%@SingleObjectToolbar", self.name]];
		[singleObjectToolbar setDelegate:self];
		[singleObjectToolbar setAutoresizingMask:NSViewWidthSizable];
		
		// singleObjectSplitView
		
		self.singleObjectSplitView = [[[FKSplitView alloc] initWithFrame:NSZeroRect] autorelease];
		
		[singleObjectSplitView setVertical:YES];
		[singleObjectSplitView setDividerStyle:NSSplitViewDividerStyleThin];
		//[singleObjectSplitView setDelegate:self];
		
		// singleObjectLeftPlaceholderView
		
		self.singleObjectLeftPlaceholderView = [[[FKView alloc] initWithFrame:NSZeroRect] autorelease];
		self.singleObjectLeftTabView = [[[FKTabView alloc] initWithFrame:NSZeroRect] autorelease];
				
		// singleObjectRightPlaceholderView
		
		self.singleObjectRightPlaceholderView = [[[FKView alloc] initWithFrame:NSZeroRect] autorelease];
		self.singleObjectRightTabView = [[[FKTabView alloc] initWithFrame:NSZeroRect] autorelease];
		
		// singleObjectView widths
		
		self.singleObjectLeftMinWidth = 350.0;
		self.singleObjectRightMinWidth = 350.0;
		
		// Notifications
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextUpdated:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
				
		// Predicates
		
		self.modulePredicate = [NSPredicate predicateWithValue:TRUE];		
		self.filterBarPredicate = [NSPredicate predicateWithValue:TRUE];
		self.searchFieldPredicate = nil;
		
		[self addObserver:self forKeyPath:@"modulePredicate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
		[self addObserver:self forKeyPath:@"filterBarPredicate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
		[self addObserver:self forKeyPath:@"searchFieldPredicate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
		[self addObserver:self forKeyPath:@"filterPredicate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
		
		// Sort descriptors
		
		NSSortDescriptor * sortDescriptor = nil;
		
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:self.mainSortKey ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
		
		self.objectsArrayControllerSortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
		
		// ...
				
		self.moduleStyle = FKModuleNoStyle;
	}
	
	return self;
}

- (void)loadNibFile {
	NSString * nibName = NSStringFromClass([self class]);
	
	if ( ![NSBundle loadNibNamed:nibName owner:self] ) {
		NSLog (@"Un probleme est survenu pendant le chargement du nib %@", nibName);
	}
}

- (void)dealloc {	
	self.managedObjectContext = nil;
	
	[super dealloc];
}

- (void)awakeFromNib {	

}

#pragma mark -
#pragma mark GETTERS

- (FKView *)moduleView {
	if (moduleStyle != FKModuleFullStyle) {
		[self setupLayoutUsingModuleStyle:FKModuleFullStyle];
	}
	
	return moduleView;
}

- (FKView *)miniModuleView {
	if (moduleStyle != FKModuleMiniStyle) {
		[self setupLayoutUsingModuleStyle:FKModuleMiniStyle];
	}
	
//	for (NSView * sub in [miniModuleView subviews]) {
//		NSLog(@"sub = %@", sub);
//		NSLog(@" frame = %@", NSStringFromRect([sub frame]));
//	}
	
	return miniModuleView;
}

- (FKView *)browserModuleView {
	if (moduleStyle != FKModuleBrowserStyle) {
		[self setupLayoutUsingModuleStyle:FKModuleBrowserStyle];
	}
	
	return browserModuleView;
}

- (NSWindow *)window {
	switch (moduleStyle) {
		case FKModuleFullStyle:
			return [moduleView window];
			break;
		case FKModuleMiniStyle:
			return [miniModuleView window];
			break;
		case FKModuleBrowserStyle:
			return browserWindow;
			break;
		default:
			break;
	}
	
	return nil;
}

#pragma mark READONLY

- (NSString *)name {
	return nil;
}

- (NSString *)entityName {
	return nil;
}

- (NSArray *)detailsViewTabViewItems {
	return nil;
}

- (NSArray *)searchFieldDisplayNames {
	return nil;
}

- (NSArray *)searchFieldPredicateFormats {
	return nil;
}

- (NSString *)mainSortKey {
	return @"name";
}

- (NSString *)statusString {
	NSMutableString * result = [NSMutableString string];
	NSString * elString = (objectsCount > 1 ? @"elements" : @"element");
	
	[result appendFormat:@"%d %@", objectsCount, NSLocalizedString(elString, nil)];
		
	return [NSString stringWithString:result];
}

- (BOOL)moduleViewFilterBarIsVisible {
	return TRUE;
}

#pragma mark -
#pragma mark SETTERS

#pragma mark -
#pragma mark LAYOUT

- (void)setupLayoutUsingModuleStyle:(FKModuleStyle)style {
	switch (style)
	{
		case FKModuleFullStyle : {[self setupLayoutUsingFullStyle]; break;}
		case FKModuleBrowserStyle : {[self setupLayoutUsingBrowserStyle]; break;}
		case FKModuleMiniStyle : {[self setupLayoutUsingMiniStyle]; break;}
	}
	
	self.needsLayout = NO;
}

#pragma mark -
#pragma mark NSSearchField SUPPORT

- (NSArray *)searchFieldPredicateIdentifiers {
	return nil;
}

- (NSString *)predicateFormatForSearchFieldPredicateIdentifier:(NSString *)predicateIdentifier {
	return nil;
}

- (NSString *)predicateFormatForSearchFieldPredicateIdentifier:(NSString *)predicateIdentifier singleCriteriaFiltering:(BOOL)singleCriteriaFiltering {
	return [self predicateFormatForSearchFieldPredicateIdentifier:predicateIdentifier];
}

- (NSString *)displayNameForSearchFieldPredicateIdentifier:(NSString *)predicateIdentifier {
	return NSLocalizedString(predicateIdentifier, @"");
}

- (void)bindSearchField:(NSSearchField *)searchField {
	self.mainSearchField = searchField;
	
	NSMutableArray * predicateIdentifiers = [NSMutableArray arrayWithArray:[self searchFieldPredicateIdentifiers]];
	NSMutableArray * predicateDisplayNames = [NSMutableArray array];
	NSMutableArray * sortedDisplayNames = nil;
	
	NSString * predicateIdentifier = nil;
	NSString * displayName = nil;
	
	int i = 0;
	
	// ...
	
	for (i = 0; i < [predicateIdentifiers count]; i++) {
		predicateIdentifier = [predicateIdentifiers objectAtIndex:i];
		displayName = [self displayNameForSearchFieldPredicateIdentifier:predicateIdentifier];
		
		[predicateDisplayNames addObject:displayName];
	}
	
	// ...
	
	sortedDisplayNames = [NSMutableArray arrayWithArray:predicateDisplayNames];
	
	[sortedDisplayNames sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
	// ...
	
	NSString * bindingName = nil;
	NSString * predicateFormat = nil;
	NSString * currentPredicateFormat = nil;
	
	NSUInteger displayNameIndex = NSNotFound;
	
	if ( [predicateIdentifiers count] )
	{
		// All
		
		for (i = 0; i < [predicateIdentifiers count]; i++) {	
			predicateIdentifier = [predicateIdentifiers objectAtIndex:i];
			currentPredicateFormat = [self predicateFormatForSearchFieldPredicateIdentifier:predicateIdentifier singleCriteriaFiltering:false];
			
			if (nil != currentPredicateFormat) {
				if (i > 0) {
					predicateFormat = [predicateFormat stringByAppendingFormat:@" or %@", currentPredicateFormat];
				}
				else {
					predicateFormat = currentPredicateFormat;
				}
			}
		}
		
		[searchField bind:@"predicate" toObject:self withKeyPath:@"searchFieldPredicate"
				  options:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"AllFields", @""), NSDisplayNameBindingOption, predicateFormat, NSPredicateFormatBindingOption, nil]];
		
		// ...
		
		for (i = 0; i < [sortedDisplayNames count]; i++) {
			displayName = [sortedDisplayNames objectAtIndex:i];
			
			// ...
			
			displayNameIndex = [predicateDisplayNames indexOfObject:displayName];
			
			// ...
			predicateIdentifier = [predicateIdentifiers objectAtIndex:displayNameIndex];
			currentPredicateFormat = [self predicateFormatForSearchFieldPredicateIdentifier:predicateIdentifier singleCriteriaFiltering:true];
			
			bindingName = [@"predicate" stringByAppendingFormat:@"%d", (i + 2)];
			
			[searchField bind:bindingName toObject:self withKeyPath:@"searchFieldPredicate"
					  options:[NSDictionary dictionaryWithObjectsAndKeys:displayName, NSDisplayNameBindingOption, currentPredicateFormat, NSPredicateFormatBindingOption, nil]];
		}
	}
}

- (void)unbindSearchField:(NSSearchField *)searchField {
	NSMutableArray * predicateIdentifiers = [NSMutableArray arrayWithArray:[self searchFieldPredicateIdentifiers]];
	NSString * bindingName = nil;
	
	NSUInteger i = 0;
	
	[searchField unbind:@"predicate"];	
	
	for (i = 0; i < [predicateIdentifiers count]; i++) {
		bindingName = [@"predicate" stringByAppendingFormat:@"%d", (i + 2)];
		
		[searchField unbind:bindingName];
	}
}

#pragma mark -
#pragma mark MODULE SUPPORT

- (void)willSelect {}

- (void)didSelect {
	[mainSearchField setEnabled:([self moduleMode] == FKModuleMultipleObjectsMode)];
}

- (void)willUnselect {
}

- (void)didUnselect {
}

- (FKModuleHasChangesPendingResult)hasChangesPending {
	return FKModuleHasChangesPendingNO;
}

- (void)replyToHasChangesPending:(BOOL)flag {
	if ( flag )
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:FKModuleDoesHaveChangesPendingNotification object:self];
	}
	else
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:FKModuleDoesntHaveChangesPendingNotification object:self];		
	}
}

- (void)updateUI {
}

- (void)switchToSingleObjectMode {
	[self setModuleMode:FKModuleSingleObjectMode];
	
	[moduleView setContentView:singleObjectView];
	
	//[[moduleView window] makeFirstResponder:[editViewStackView firstResponder]];
	
	[mainSearchField setEnabled:NO];
}

- (void)switchToMultipleObjectsMode {
	[self setModuleMode:FKModuleMultipleObjectsMode];
	
	[moduleView setContentView:multipleObjectsView];
	
	[mainSearchField setEnabled:YES];
}

#pragma mark -
#pragma mark ACTIONS

- (IBAction)export:(id)sender {
	[self.window makeKeyAndOrderFront:sender];
	
	NSSavePanel * savePanel = [NSSavePanel savePanel];
	
	[savePanel setRequiredFileType:@"csv"];
	[savePanel setAccessoryView:exportAccessoryView];
	[savePanel beginSheetForDirectory:nil
								 file:NSLocalizedString(self.name, @"")
					   modalForWindow:[NSApp mainWindow]
						modalDelegate:self
					   didEndSelector:@selector(exportPanelDidEnd:returnCode:contextInfo:)
						  contextInfo:nil];
}

- (void)exportPanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo {
	NSException * ex = [NSException exceptionWithName:@"TEST" reason:@"TEST" userInfo:nil];
	
	@throw (ex);
}

- (NSString *)csvStringForValue:(id)object {
	return [self csvStringForValue:object formatter:nil];
}

- (NSString *)csvStringForValue:(id)object formatter:(NSFormatter *)formatter {
	NSString * result = nil;
	NSString * tmpStr = nil;
	
	tmpStr = (object != nil ? object : ([object isKindOfClass:[NSDecimalNumber class]] ? [NSDecimalNumber zero] : [NSString string]));
	
	if (nil != formatter) {
		tmpStr = [formatter stringForObjectValue:tmpStr];
	}
	
	result = [NSString stringWithFormat:@"\"%@\"", tmpStr];
	
	return result;
}

- (IBAction)print:(id)sender {
	[NSApp beginSheet:printDialogWindow modalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(printDialogSheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)closePrintDialogSheet:(id)sender {
	[NSApp endSheet:printDialogWindow returnCode:[sender tag]];
}

- (void)printDialogSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[sheet orderOut:self];
}

#pragma mark -
#pragma mark MANAGED OBJECTS SUPPORT

- (void)addObject {
	[objectsArrayController add:nil];
}

- (void)addObjects:(NSArray *)objects {
	[objectsArrayController addObjects:objects];
}

- (void)deleteSelectedObjects {
	[objectsArrayController remove:nil];
}

- (void)selectObjects:(NSArray *)objects {
	[objectsArrayController setSelectedObjects:objects];
}

#pragma mark -
#pragma mark ERROR MANAGEMENT

- (void)presentError:(NSError *)error {
	[NSApp presentError:error modalForWindow:self.window delegate:self didPresentSelector:@selector(didPresentErrorWithRecovery:contextInfo:) contextInfo:nil];
}

- (void)presentError:(NSError *)error modalForWindow:(NSWindow *)aWindow delegate:(id)aDelegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo; {
	[NSApp presentError:error modalForWindow:aWindow delegate:aDelegate didPresentSelector:didPresentSelector contextInfo:contextInfo];
}

- (void)didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo {
}

#pragma mark -
#pragma mark NSTableView DATASOURCE

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {
	return YES;
}

#pragma mark -
#pragma mark NSTableView DELEGATE

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {	
	[aCell setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];
}

#pragma mark -
#pragma mark FKTabView DELEGATE

- (void)fkTabView:(FKTabView *)tabView didSelectTabViewItem:(FKTabViewItem *)tabViewItem {
	//[[NSUserDefaults standardUserDefaults] setObject:[tabViewItem identifier] forKey:[self lastSelectedDetailsViewIdentifierKey]];
}

- (NSUInteger)fkTabViewNumberOfItems:(FKTabView *)aTabView {
	return 0;
}

- (NSView *)fkTabView:(FKTabView *)aTabView viewForItemAtIndex:(NSUInteger)itemIndex {
	return nil;
}

- (NSString *)fkTabView:(FKTabView *)aTabView labelForItemAtIndex:(NSUInteger)itemIndex {
	return nil;
}

#pragma mark -
#pragma mark NSSplitView DELEGATE

- (float)splitView:(NSSplitView *)sender constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)offset {
	if ( sender == multipleObjectsSplitView )
	{
		if ( offset == 0 )
		{
			return multipleObjectsLeftMinWidth;
		}
	}
	else if ( sender == singleObjectSplitView )
	{
		if ( offset == 0 )
		{
			return singleObjectLeftMinWidth;
		}
	}
	
	
	return proposedMin;
}

- (float)splitView:(NSSplitView *)sender constrainMaxCoordinate:(float)proposedMin ofSubviewAt:(int)offset {
	if ( sender == multipleObjectsSplitView )
	{
		if ( offset == 0 )
		{
			return NSWidth([multipleObjectsSplitView frame]) - (multipleObjectsRightMinWidth + [multipleObjectsSplitView dividerThickness]);
		}
	}
	else if ( sender == singleObjectSplitView )
	{
		if ( offset == 0 )
		{
			return NSWidth([singleObjectSplitView frame]) - (singleObjectRightMinWidth + [singleObjectSplitView dividerThickness]);
		}
	}
	
	return proposedMin;
}

- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize {
	NSRect splitFrame = NSZeroRect;
	NSRect leftFrame = NSZeroRect;
	NSRect rightFrame = NSZeroRect;
	
	if (sender == multipleObjectsSplitView) {		
		splitFrame = [multipleObjectsSplitView frame];
		leftFrame = [multipleObjectsLeftPlaceholderView frame];
		rightFrame = [multipleObjectsRightPlaceholderView frame];
		
		float dividerThickness = [multipleObjectsSplitView dividerThickness];
		float newWidth = NSWidth(splitFrame);
		
		leftFrame.size.width = newWidth - (NSWidth(rightFrame) + dividerThickness);
		leftFrame.size.height = NSHeight(splitFrame);
		
		rightFrame.size.height = NSHeight(leftFrame);
		
		if (leftFrame.size.width < multipleObjectsLeftMinWidth) {
			leftFrame.size.width = multipleObjectsLeftMinWidth;
			
			rightFrame.size.width = newWidth - (NSWidth(leftFrame) + dividerThickness);
		}
		
		rightFrame.origin.x = leftFrame.size.width + dividerThickness;
		
		[multipleObjectsLeftPlaceholderView setFrame:leftFrame];
		[multipleObjectsRightPlaceholderView setFrame:rightFrame];
	}
	else if (sender == singleObjectSplitView) {
		splitFrame = [singleObjectSplitView frame];
		leftFrame = [singleObjectLeftPlaceholderView frame];
		rightFrame = [singleObjectRightPlaceholderView frame];
		
		float dividerThickness = [singleObjectSplitView dividerThickness];
		float newWidth = NSWidth(splitFrame);
		
		leftFrame.size.width = newWidth - (NSWidth(rightFrame) + dividerThickness);
		leftFrame.size.height = NSHeight(splitFrame);
		
		rightFrame.size.height = NSHeight(leftFrame);
		
		if (leftFrame.size.width < singleObjectLeftMinWidth) {
			leftFrame.size.width = singleObjectLeftMinWidth;
			
			rightFrame.size.width = newWidth - (NSWidth(leftFrame) + dividerThickness);
		}
		
		rightFrame.origin.x = leftFrame.size.width + dividerThickness;
		
		[singleObjectLeftPlaceholderView setFrame:leftFrame];
		[singleObjectRightPlaceholderView setFrame:rightFrame];		
	}
}

#pragma mark -
#pragma mark FKModuleToolbar DELEGATE

- (int)moduleToolbarNumberOfAreas:(FKModuleToolbar *)aToolbar {
	return 0;
}

- (NSArray *)moduleToolbarItemIdentifiers:(FKModuleToolbar *)aToolbar forAreaAtIndex:(int)areaIndex {	
	return nil;
}

- (FKModuleToolbarItem *)moduleToolbar:(FKModuleToolbar *)aToolbar itemForItemIdentifier:(NSString *)anItemIdentifier forAreaAtIndex:(int)areaIndex {
	FKModuleToolbarItem * anItem = [[[FKModuleToolbarItem alloc] initWithItemIdentifier:anItemIdentifier] autorelease];
	
	[anItem setLabel:NSLocalizedString(anItemIdentifier, nil)];
	[anItem setTarget:self];	
	
	if ((aToolbar == multipleObjectsToolbar) || (aToolbar == singleObjectToolbar)) {
		NSString * firstCharacter = [[anItemIdentifier substringToIndex:1] lowercaseString];
		NSString * remString = [anItemIdentifier substringFromIndex:1];
		NSString * selectorString = [NSString stringWithFormat:@"%@%@Action:", firstCharacter, remString];
		
		[anItem setImage:[NSImage imageNamed:[NSString stringWithFormat:@"TB_%@", anItemIdentifier]]];
		[anItem setAction:NSSelectorFromString(selectorString)];
	}
	
	return anItem;
}

- (NSArray *)moduleToolbarSelectableItemIdentifiers:(FKModuleToolbar *)aToolbar forAreaAtIndex:(int)areaIndex {	
	return nil;
}

- (BOOL)validateModuleToolbarItem:(FKModuleToolbarItem *)theItem {
	return YES;
}

#pragma mark -
#pragma mark NSToolbar DELEGATE

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	return nil;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	return nil;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	return nil;
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	id oldValue = [change valueForKey:NSKeyValueChangeOldKey];
	id newValue = [change valueForKey:NSKeyValueChangeNewKey];
	
	if ([keyPath isEqualToString:@"filterPredicate"]) {
		if (object == objectsArrayController) {
			[objectsArrayController setSelectionIndex:0];
		}
	}	
	
	if ([keyPath isEqualToString:@"selectedObject"]) {
		NSLog(@"%@", currentObject);
		
		[self performSelector:@selector(scrollMultipleObjectsLeftTableViewToCurrentObject) withObject:nil afterDelay:0.0];
	}
	
	if ([keyPath isEqualToString:@"modulePredicate"] ||
		[keyPath isEqualToString:@"filterBarPredicate"] ||
		[keyPath isEqualToString:@"searchFieldPredicate"]) {
		if (![newValue isEqual:oldValue]) {
			[self computeFilterPredicate];
		}
	}
}

- (void)scrollMultipleObjectsLeftTableViewToCurrentObject {
	[multipleObjectsLeftTableView scrollRowToVisible:[objectsArrayController selectionIndex]];
}

- (void)computeFilterPredicate {
	NSMutableArray * subpredicates = [NSMutableArray array];
	
	if ( nil != modulePredicate ) {[subpredicates addObject:modulePredicate];}
	if ( nil != filterBarPredicate ) {[subpredicates addObject:filterBarPredicate];}	
	if ( nil != searchFieldPredicate ) {[subpredicates addObject:searchFieldPredicate];}
	
	self.filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
}

#pragma mark -
#pragma mark NOTIFICATIONS

- (void)contextUpdated:(NSNotification *)aNotification {}
- (void)windowDidUpdate:(NSNotification *)aNotification {[self updateUI];}

@end
