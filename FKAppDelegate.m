//
//  FKAppDelegate.m
//  FKKit
//
//  Created by alt on 23/09/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKAppDelegate.h"
#import "FKSourceListItem.h"

NSString * FKFirstExecutionCompletedKey = @"FirstExecutionCompleted";
NSString * FKMainSplitViewPositionAutosaveName = @"MainSplitView";

#define COLUMNID_NAME				@"SourceListColumn"
#define MAINTOOLBARID				@"MainToolbar"
#define MAINTOOLBARSEARCHID			@"MainToolbarSearch"

@interface FKAppDelegate (Private)

- (void)setMainView:(FKView *)aView;

- (void)setupLayout;

- (NSString *)lastSelectedInformationsDetailViewKey;
- (NSString *)splitViewPositionAutosaveName;

- (void)setupFooterViewInRect:(NSRect)rect;
- (void)setupSplitViewInRect:(NSRect)rect;
- (void)setupModuleContentViewInRect:(NSRect)rect;
- (void)setupMenuViewInRect:(NSRect)rect;

@end

@implementation FKAppDelegate

@synthesize mainToolbar;
@synthesize mainToolbarSearchField;
@synthesize footerView;
@synthesize statusLabel;

@synthesize sourceList;
@synthesize sourceListTreeController;
@synthesize sourceListNodes;

@synthesize modulesArray;
@synthesize currentModule;
@synthesize nextModule;

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		// ...
		
		[self launchFirstExecution];
	
		menuViewMinWidth = 250.0;
		moduleViewMinWidth = 200.0;
		
		self.mainToolbar = [[[NSToolbar alloc] initWithIdentifier:MAINTOOLBARID] autorelease];
		
		[mainToolbar setDelegate:self];
		[mainToolbar setAllowsUserCustomization:YES];
		[mainToolbar setAutosavesConfiguration:YES];
		
		NSRect searchFieldFrame = NSMakeRect(0.0, 0.0, 225.0, 22.0);
				
		self.mainToolbarSearchField = [[[NSSearchField alloc] initWithFrame:searchFieldFrame] autorelease];
		
		[[mainToolbarSearchField cell] setSendsSearchStringImmediately:YES];
		[[mainToolbarSearchField cell] setLineBreakMode:NSLineBreakByTruncatingTail];

		// modulesArray
		
		self.modulesArray = [NSMutableArray array];
		
		// mainView
		
		[self setMainView:[[[FKView alloc] initWithFrame:NSZeroRect] autorelease]];	
				
		// footerView
		
		self.footerView = [[[FKView alloc] initWithFrame:NSZeroRect] autorelease];
		self.statusLabel = [[[NSTextField alloc] initWithFrame:NSZeroRect] autorelease];
		
		// splitView
		
		[self setSplitView:[[[FKSplitView alloc] initWithFrame:NSZeroRect] autorelease]];
		
		[splitView setVertical:YES];
		[splitView setDelegate:self];	
		
		// menuView
		
		[self setMenuView:[[[FKView alloc] initWithFrame:NSZeroRect] autorelease]];
		
		self.sourceList = [[[NSOutlineView alloc] initWithFrame:NSZeroRect] autorelease];
		self.sourceListTreeController = [[[NSTreeController alloc] init] autorelease];
		
		[self setMenuViewBottomBar:[[[FKModuleBottomBar alloc] initWithFrame:NSZeroRect] autorelease]];
		[self setMenuViewAddButton:[[[FKButton alloc] initWithFrame:NSZeroRect] autorelease]];
		
		[menuViewAddButton setImage:[NSImage imageNamed:@"Plus"]];
		[menuViewAddButton setFkBezelStyle:FKRoundedGradientStyle];
		
		[self setMenuViewActionButton:[[[FKButton alloc] initWithFrame:NSZeroRect] autorelease]];
		
		[menuViewActionButton setImage:[NSImage imageNamed:@"Action"]];		
		[menuViewActionButton setFkBezelStyle:FKRoundedGradientStyle];
		
		// moduleView
		
		[self setModuleContentView:[[[FKView alloc] initWithFrame:NSZeroRect] autorelease]];
	
		// ...
		
		[NSNumberFormatter setDefaultFormatterBehavior:NSNumberFormatterBehavior10_4];
		
		// ...
		
		[[FKBarcodeScannersManager defaultManager] startMonitoring];
	}
	
	return self;
}

- (void)dealloc
{
    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
	
    [super dealloc];
}

#pragma mark -

- (void)awakeFromNib
{
	[self setWindowFrameAutosaveName:@"MainWindow"];	
	
	FKWindow * window = (FKWindow *)[self window];
	
	[window setDelegate:self];
	[window setPostsFirstResponderChangedNotifications:YES];
	[window setToolbar:mainToolbar];	
	
	// ******
	// Layout
	// ******
	
	[self setupLayout];
}

- (IBAction)print:(id)sender {
	//[currentModule print:sender];
}

- (void)setupLayout {
	NSLog(@"DEBUT - setupLayout");
	
	NSRect viewFrame = NSZeroRect;
	NSRect contentFrame = NSZeroRect;
	NSRect mainViewFrame = NSZeroRect;
	NSRect footerViewFrame = NSZeroRect;
	
	NSView * contentView = [[self window] contentView];
	
	[contentView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[contentView setAutoresizesSubviews:YES];	
	
	// ********
	// mainView
	// ********
	
	contentFrame = [contentView frame];
		
	NSDivideRect(contentFrame, &footerViewFrame, &mainViewFrame, 32.0, NSMinYEdge);	
	
	[self setupMainViewInRect:mainViewFrame];
	
	// **********
	// footerView
	// **********
	
	footerViewFrame.size.height -= 1.0;
	
	[self setupFooterViewInRect:footerViewFrame];
	
	// *********
	// splitView
	// *********
	
	mainViewFrame = [mainView contentFrame];
	
	[self setupSplitViewInRect:mainViewFrame];
		
	// ********
	// menuView
	// ********
	
	viewFrame.origin.x = 0.0;	
	viewFrame.origin.y = 0.0;
	viewFrame.size.width = menuViewMinWidth;
	viewFrame.size.height = [splitView frame].size.height;
	
	[self setupMenuViewInRect:viewFrame];
		
	// *****************
	// moduleContentView
	// *****************
	
	viewFrame.origin.x = 0.0;	
	viewFrame.origin.y = 0.0;
	viewFrame.size.width = 10000.0;
	viewFrame.size.height = [splitView frame].size.height;	
	
	[self setupModuleContentViewInRect:viewFrame];
	
	// *******
	// Boutons
	// *******
	
	NSRect buttonFrame = contentFrame;
	
	buttonFrame.size.width = 31.0;
	buttonFrame.size.height = 21.0;
	buttonFrame.origin.y += ceil((NSHeight(contentFrame) - NSHeight(buttonFrame)) / 2.0);
	buttonFrame.origin.x += buttonFrame.origin.y;	
	
	// menuViewAddButton
	
	[menuViewAddButton setFrame:buttonFrame];
	
	[contentView addSubview:menuViewAddButton];
	
	NSLog(@"FIN - setupLayout");
}

- (void)setupMainViewInRect:(NSRect)rect {	
	NSView * contentView = [[self window] contentView];
	
	[mainView setFrame:rect];
	[mainView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	[contentView addSubview:mainView];
}

- (void)setupFooterViewInRect:(NSRect)rect {
	NSView * contentView = [[self window] contentView];	
	
	footerView.borderColor = [NSColor colorWithDeviceRed:(230.0 / 255.0) green:(230.0 / 255.0) blue:(230.0 / 255.0) alpha:1.0];
	[footerView setBorderMask:FKTopBorder];
	[footerView setFrame:rect];
	[footerView setAutoresizingMask:(NSViewWidthSizable | NSViewMaxYMargin)];
	
	[contentView addSubview:footerView];
	
	NSRect statusLabelFrame = NSInsetRect(rect, 20.0, 0.0);
	
	statusLabelFrame.size.height = 17.0;
	statusLabelFrame.origin.y = 6.0; //floor((rect.size.height - statusLabelFrame.size.height) / 2.0);
	
	[statusLabel setFrame:statusLabelFrame];
	[statusLabel setAutoresizingMask:(NSViewWidthSizable | NSViewMaxYMargin)];
	[statusLabel setAlignment:NSCenterTextAlignment];
	[statusLabel setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];
	[statusLabel setDrawsBackground:NO];
	[statusLabel setEditable:NO];
	[statusLabel setSelectable:NO];
	[statusLabel setBordered:NO];
	[statusLabel setBezeled:NO];
	[statusLabel bind:@"value" toObject:self withKeyPath:@"currentModule.statusString" options:nil];
	[[statusLabel cell] setBackgroundStyle:NSBackgroundStyleRaised];
	
	[footerView addSubview:statusLabel];
}

- (void)setupSplitViewInRect:(NSRect)rect
{
	[splitView setFrame:rect];
	[splitView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[splitView setAutosaveName:FKMainSplitViewPositionAutosaveName];
	[splitView setDividerStyle:NSSplitViewDividerStyleThin];
	
	[mainView addSubview:splitView];
}

- (void)setupMenuViewInRect:(NSRect)rect
{
	[menuView setFrame:rect];
		
	// scrollView
	
	NSRect scrollViewRect = [menuView frame];
	
	NSScrollView * scrollView = [[NSScrollView alloc] initWithFrame:scrollViewRect];
	
	[scrollView setHasVerticalScroller:YES];
	[scrollView setAutohidesScrollers:YES];
	[scrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	[menuView addSubview:scrollView];
	
	// sourceList
	
	NSMutableArray * tmpArr = [NSMutableArray array];
		
	for (id item in [self defaultSourceListItems]) {
		[tmpArr addObject:[item treeNodeRepresentation]];
	}	
	
	
	self.sourceListNodes = [NSArray arrayWithArray:tmpArr];		
	
	[sourceListTreeController setChildrenKeyPath:@"childNodes"];	
	[sourceListTreeController setLeafKeyPath:@"isLeaf"];	
	[sourceListTreeController setObjectClass:[NSTreeNode class]];
	[sourceListTreeController bind:@"content" toObject:self withKeyPath:@"sourceListNodes" options:nil];
	
	FKImageAndTextCell * aCell = [[[FKImageAndTextCell alloc] init] autorelease];
	
	[aCell setLineBreakMode:NSLineBreakByTruncatingTail];	
	
	NSTableColumn * aColumn = [[[NSTableColumn alloc] initWithIdentifier:COLUMNID_NAME] autorelease];
	
	[aColumn setDataCell:aCell];	
	[aColumn setWidth:[[scrollView contentView] frame].size.width];	
	[aColumn setIdentifier:COLUMNID_NAME];
	[aColumn setWidth:[[scrollView contentView] frame].size.width];
	[aColumn bind:@"value" toObject:sourceListTreeController withKeyPath:@"arrangedObjects.title" options:nil];
	
	[sourceList addTableColumn:aColumn];
	[sourceList setOutlineTableColumn:aColumn];
	[sourceList setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
	[sourceList setHeaderView:nil];
	[sourceList setFocusRingType:NSFocusRingTypeNone];
	[sourceList setDelegate:self];
	[sourceList bind:@"content" toObject:sourceListTreeController withKeyPath:@"arrangedObjects" options:nil];
	
	[scrollView setDocumentView:sourceList];
	
	// ...
	
	[splitView addSubview:menuView];
}

- (void)setupModuleContentViewInRect:(NSRect)rect
{
	[moduleContentView setFrame:rect];
	
	[splitView addSubview:moduleContentView];
}

- (void)launchFirstExecution
{
	// Premiere execution : on verifie qu'elle n'ait pas deja ete executee
	
	BOOL firstExecutionCompleted = NO;
	
	firstExecutionCompleted = [[[persistentStoreCoordinator metadataForPersistentStore:persistentStore] objectForKey:FKFirstExecutionCompletedKey] boolValue];
	
	if ( !firstExecutionCompleted )
	{
		[self updateDefaultObjects];
		
		[persistentStoreCoordinator setMetadata:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], FKFirstExecutionCompletedKey, nil] forPersistentStore:persistentStore];
	}
}

- (void)updateDefaultObjects {}

#pragma mark -
#pragma mark GETTERS

- (Class)treeNodeClass {return [FKSourceListItemNode class];}
- (int)numberOfDefaultSmartGroupNodes {return 0;}

- (FKSourceListSmartGroupNode *)defaultSystemSmartGroupNodeAtIndex:(int)index
{
	return nil;
}

#pragma mark -
#pragma mark MODULES MANAGEMENT

- (FKModule *)moduleNamed:(NSString *)moduleName {
	FKModule * moduleNamed = nil;	
	
	FKModule * aModule = nil;
	Class moduleClass = nil;
	
	moduleClass = NSClassFromString([NSString stringWithFormat:@"%@Module", moduleName]);
	
	for (aModule in modulesArray) {
		if ([aModule isMemberOfClass:moduleClass]) {
			moduleNamed = aModule;
			
			break;
		}
	}
	
	if (nil == moduleNamed) {
		// Le module n'existe pas encore dans le tableau des modules :
		// on l'initialise, on l'ajoute et on le retourne
		
		moduleNamed = [moduleClass moduleWithContext:[self managedObjectContext]];
				
		if (moduleNamed) {
			[moduleNamed setDelegate:self];
			
			[modulesArray addObject:moduleNamed];
		}
		else {
			NSLog (@"Erreur : Le module '%@' n'a pas pu etre initialise !", moduleName);
		}
	}
	else {
		NSLog(@"Le module %@ existe deja dans le tableau !", moduleName);
	}
	
	return moduleNamed;
}

- (BOOL)shouldSelectModule:(FKModule *)newModule
{
	FKModuleHasChangesPendingResult hasChangesPending = [currentModule hasChangesPending];
	
	if ( ( currentModule == nil ) || ( hasChangesPending != FKModuleHasChangesPendingYES ) )
	{
		[self setNextModule:newModule];	
		
		if ( ( currentModule == nil ) || ( hasChangesPending == FKModuleHasChangesPendingNO ) )
		{
			return YES;
		}
		else // FreakModuleHasChangesPendingMAYBE
		{
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moduleDoUnselect:) name:FKModuleDoesntHaveChangesPendingNotification object:currentModule];							
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moduleCancelUnselect:) name:FKModuleDoesHaveChangesPendingNotification object:currentModule];
			
			return NO;
		}
	}
	else
	{
		return NO;
	}
	
	return YES;
}

- (void)_selectModule:(FKModule *)newModule userInfo:(NSDictionary *)userInfo
{
	if ( newModule )
	{
		[self currentModuleHasAcceptedToUnselect];
	}
}

- (void)selectModule:(FKModule *)module {
	if ([self shouldSelectModule:module]) {
		[self _selectModule:module userInfo:nil];
	}
}

- (void)selectModuleNamed:(NSString *)moduleName userInfo:(NSDictionary *)userInfo { // FIXFIXFIX !!!	
	FKModule * module = nil;
	
	module = [self moduleNamed:moduleName];
		
	[self selectModule:module];
}

- (void)unselectCurrentModule
{
	[currentModule willUnselect];
	
	[currentModule unbindSearchField:mainToolbarSearchField];
	[currentModule.moduleView removeFromSuperviewWithoutNeedingDisplay];
	
	[[NSNotificationCenter defaultCenter] removeObserver:currentModule name:NSWindowDidUpdateNotification object:self.window];	

	[currentModule didUnselect];	
	[self setCurrentModule:nil];
}

- (void)selectNextModule
{	
	[nextModule willSelect];
	
	[self setCurrentModule:nextModule];
		
	[[NSNotificationCenter defaultCenter] addObserver:currentModule selector:@selector(windowDidUpdate:) name:NSWindowDidUpdateNotification object:self.window];	
	
	[self setNextModule:nil];
	
	[currentModule bindSearchField:mainToolbarSearchField];
	[moduleContentView setContentView:currentModule.moduleView];
	
	// didSelect
	
	[currentModule didSelect];
}

- (void)currentModuleHasAcceptedToUnselect
{
	[self unselectCurrentModule];
	[self selectNextModule];
}

- (void)setMainView:(FKView *)aView
{
	if ( aView != mainView )
	{
		[mainView release];
		mainView = [aView retain];
	}
}

#pragma mark splitView

- (void)setSplitView:(NSSplitView *)aView
{
	if ( aView != splitView )
	{
		[splitView release];
		splitView = [aView retain];
	}
}

#pragma mark menuView

- (void)setMenuView:(FKView *)aView
{
	if ( aView != menuView )
	{
		[menuView release];
		menuView = [aView retain];
	}
}

- (void)setMenuViewBottomBar:(FKModuleBottomBar *)aView;
{
	if ( aView != menuViewBottomBar )
	{
		[menuViewBottomBar release];
		menuViewBottomBar = [aView retain];
	}
}

- (void)setMenuViewAddButton:(FKButton *)aButton
{
	if ( aButton != menuViewAddButton )
	{
		[menuViewAddButton release];
		menuViewAddButton = [aButton retain];
	}
}

- (void)setMenuViewActionButton:(FKButton *)aButton
{
	if ( aButton != menuViewActionButton )
	{
		[menuViewActionButton release];
		menuViewActionButton = [aButton retain];
	}
}

#pragma mark moduleView

- (void)setModuleContentView:(FKView *)aView
{
	if ( aView != moduleContentView )
	{
		[moduleContentView release];
		moduleContentView = [aView retain];
	}
}

#pragma mark -
#pragma mark MODULES NOTIFICATIONS

- (void)moduleDoUnselect:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKModuleDoesHaveChangesPendingNotification object:currentModule];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKModuleDoesntHaveChangesPendingNotification object:currentModule];
	
	[self currentModuleHasAcceptedToUnselect];
}

- (void)moduleCancelUnselect:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKModuleDoesHaveChangesPendingNotification object:currentModule];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKModuleDoesntHaveChangesPendingNotification object:currentModule];
	
	[self setNextModule:nil];
}

#pragma mark -
#pragma mark EVENTS

- (void)flagsChanged:(NSEvent *)theEvent
{
	if ( [theEvent modifierFlags] & NSAlternateKeyMask )
	{
		//[menuViewAddButton setNormalImage:[NSImage imageNamed:@"Smart" forClass:[FKAppDelegate class]]];
		[menuViewAddButton setAction:@selector(newSmartGroupAction:)];
	}
	else
	{
		//[menuViewAddButton setNormalImage:[NSImage imageNamed:@"Plus" forClass:[FKAppDelegate class]]];
		[menuViewAddButton setAction:@selector(newGroupAction:)];
		[menuViewAddButton setAction:@selector(newSmartGroupAction:)];
	}
	
	[menuViewAddButton setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark ACTIONS

- (IBAction)newGroupAction:(id)sender
{
	//FKGroup * newGroup = [FKGroup groupInContext:[self managedObjectContext]];
}

- (IBAction)newSmartGroupAction:(id)sender {
}

- (IBAction)beginSearch:(id)sender {
	[[self window] makeFirstResponder:mainToolbarSearchField];
}

#pragma mark -
#pragma mark NSTableView DATASOURCE

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return 3;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	return @"Test";
}

#pragma mark -
#pragma mark NSOutlineView DELEGATE

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {	
	if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME]) {
		if ([cell isKindOfClass:[FKImageAndTextCell class]]) {
			item = [item representedObject];
			
			if (nil != item) {
				if ([item isLeaf]) {
//					NSString *urlStr = [item urlString];
//					if (urlStr)
//					{
//						if ([item isLeaf])
//						{
//							NSImage *iconImage;
//							if ([[item urlString] hasPrefix:HTTP_PREFIX])
//								iconImage = urlImage;
//							else
//								iconImage = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
//							[item setNodeIcon:iconImage];
//						}
//						else
//						{
//							NSImage* iconImage = [[NSWorkspace sharedWorkspace] iconForFile:urlStr];
//							[item setNodeIcon:iconImage];
//						}
//					}
//					else
//					{
//						// it's a separator, don't bother with the icon
//					}
//				}
//				else
//				{
//					// check if it's a special folder (DEVICES or PLACES), we don't want it to have an icon
//					if ([self isSpecialGroup:item])
//					{
//						[item setNodeIcon:nil];
//					}
//					else
//					{
//						// it's a folder, use the folderImage as its icon
//						[item setNodeIcon:folderImage];
//					}
				}
			}
			
			[(FKImageAndTextCell*)cell setImage:[item icon]];
		}
	}	
}

- (void)outlineViewSelectionDidChange:(NSNotification *)aNotification
{	
	id item = [sourceList itemAtRow:[sourceList selectedRow]];
		
	FKSourceListItemNode * selectedNode = [item representedObject];
	
	FKModule * module = [self moduleNamed:[[selectedNode representedObject] moduleName]];
	
	module.modulePredicate = [[selectedNode representedObject] predicate];
		
	[self selectModule:module];
}

- (BOOL)isSpecialGroup:(FKSourceListItemNode *)listItemNode { 
	return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item; {
	if (outlineView == sourceList) {
		return ![self isSpecialGroup:[item representedObject]];
	}
	
	return YES;
}

-(BOOL)outlineView:(NSOutlineView*)outlineView isGroupItem:(id)item {
	if (outlineView == sourceList) {
		return [self isSpecialGroup:[item representedObject]];
	}
	
	return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
	if (outlineView == sourceList) {
		return ![self isSpecialGroup:[item representedObject]];
	}	
	
	return YES;
}

#pragma mark -
#pragma mark NSSplitView DELEGATE

- (float)splitView:(NSSplitView *)sender constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)offset {
	if (sender == splitView) {
		if (offset == 0) {
			return menuViewMinWidth;
		}
	}
	
	return proposedMin;
}

- (float)splitView:(NSSplitView *)sender constrainMaxCoordinate:(float)proposedMin ofSubviewAt:(int)offset
{
	if ( sender == splitView )
	{
		if ( offset == 0 )
		{
			return 350.0; //NSWidth([splitView frame]) - (moduleViewMinWidth + [splitView dividerThickness]);
		}
	}
	
	return proposedMin;
}

- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
	NSRect leftFrame = NSZeroRect;
	NSRect rightFrame = NSZeroRect;	
	
	if ( sender == splitView )
	{		
		float dividerThickness = [splitView dividerThickness];
		
		leftFrame = [menuView frame];
		rightFrame = [moduleContentView frame];
		
		leftFrame.origin = NSZeroPoint;
		leftFrame.size.height = [splitView frame].size.height;
		
		rightFrame.origin.x = leftFrame.size.width + dividerThickness;
		rightFrame.origin.y = leftFrame.origin.y;
		rightFrame.size.width = [splitView frame].size.width - rightFrame.origin.x;
		rightFrame.size.height = leftFrame.size.height;
		
		[menuView setFrame:leftFrame];
		[moduleContentView setFrame:rightFrame];
	}
}

#pragma mark -
#pragma mark NSToolbar DELEGATE

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	NSToolbarItem * aToolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];	
	NSString * key = [NSString stringWithFormat:@"%@Label", itemIdentifier];

	[aToolbarItem setTarget:self];
	[aToolbarItem setLabel:NSLocalizedString(key, @"")];
	[aToolbarItem setPaletteLabel:[aToolbarItem label]];
	
	if ([itemIdentifier isEqualToString:MAINTOOLBARSEARCHID]) {
		[aToolbarItem setView:mainToolbarSearchField];
	}
	
	return aToolbarItem;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObjects:
			MAINTOOLBARSEARCHID,
			NSToolbarSeparatorItemIdentifier,
			NSToolbarFlexibleSpaceItemIdentifier,
			nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObjects:
			NSToolbarFlexibleSpaceItemIdentifier,
			MAINTOOLBARSEARCHID,
			nil];
}

//- (void)presentError:(NSError *)error modalForWindow:(NSWindow *)aWindow delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo
//{
//	[currentModule presentError:error modalForWindow:aWindow delegate:delegate didPresentSelector:didPresentSelector contextInfo:contextInfo];
//}

- (NSError *)willPresentError:(NSError *)inError {
    // The error is a Core Data validation error if its domain is
    // NSCocoaErrorDomain and it is between the minimum and maximum
    // for Core Data validation error codes.
	
    if (!([[inError domain] isEqualToString:NSCocoaErrorDomain])) {
        return inError;
    }
	
    NSInteger errorCode = [inError code];
    if ((errorCode < NSValidationErrorMinimum) ||
		(errorCode > NSValidationErrorMaximum)) {
        return inError;
    }
	
    // If there are multiple validation errors, inError is an
    // NSValidationMultipleErrorsError. If it's not, return it
	
    if (errorCode != NSValidationMultipleErrorsError) {
        return inError;
    }
	
    // For an NSValidationMultipleErrorsError, the original errors
    // are in an array in the userInfo dictionary for key NSDetailedErrorsKey
	
    NSArray *detailedErrors = [[inError userInfo] objectForKey:NSDetailedErrorsKey];
    unsigned numErrors = [detailedErrors count];
    NSMutableString *errorString = [NSMutableString stringWithFormat:@"%u validation errors have occurred", numErrors];
    NSUInteger i = 0;
 
	[errorString appendFormat:@":\n"];

	for (i = 0; i < numErrors; i++) {
        [errorString appendFormat:@"%@\n", [[detailedErrors objectAtIndex:i] localizedDescription]];
    }
	
	NSLog(@"**** ERREUR DE VALIDATION : %@", errorString);
	
    // Create a new error with the new userInfo
	
    NSMutableDictionary *newUserInfo = [NSMutableDictionary dictionaryWithDictionary:[inError userInfo]];
	
    [newUserInfo setObject:errorString forKey:NSLocalizedDescriptionKey];
	
    NSError *newError = [NSError errorWithDomain:[inError domain] code:[inError code] userInfo:newUserInfo];
	
    return newError;
}

#pragma mark -
#pragma mark CoreData Support

- (NSString *)bundleName
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

/*
 Returns the support folder for the application, used to store the Core Data
 store file.  This code uses a folder named "Hito" for
 the content, either in the NSApplicationSupportDirectory location or (if the
																	   former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportFolder
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString * basePath = ( [paths count] > 0 ) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    
	return [basePath stringByAppendingPathComponent:[self bundleName]];
}

/*
 Creates, retains, and returns the managed object model for the application 
 by merging all of the models found in the application bundle and all of the 
 framework bundles.
*/

- (NSManagedObjectModel *)managedObjectModel {	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"ShoppingBag_DataModel" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
	
	NSLog(@"%@", momURL);
	
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
	
    return managedObjectModel;
}

/*
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it. (The folder for the store is created, 
								   if necessary.)
 */

- (NSURL *)persistentStoreURL
{
	return [NSURL fileURLWithPath:[[self applicationSupportFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", [self bundleName]]]];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if ( persistentStoreCoordinator != nil )
	{
        return persistentStoreCoordinator;
    }
	
    NSFileManager * fileManager = nil;
    NSString * applicationSupportFolder = nil;
    NSURL * url = nil;
    NSError * error = nil;
    
    fileManager = [NSFileManager defaultManager];
    applicationSupportFolder = [self applicationSupportFolder];
	
    if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] )
	{
        [fileManager createDirectoryAtPath:applicationSupportFolder attributes:nil];
    }
    
    url = [NSURL fileURLWithPath:[applicationSupportFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", [self bundleName]]]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
																  forKey:NSMigratePersistentStoresAutomaticallyOption];
	
	persistentStore = [[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
																configuration:nil
																		  URL:url
																	  options:optionsDictionary
																		error:&error] retain];
	
    if (!persistentStore) {
        [[NSApplication sharedApplication] presentError:error];
		
		NSLog(@"error = %@", error.userInfo);
    }
	
    return persistentStoreCoordinator;
}

/*
 Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
*/

- (NSManagedObjectContext *)managedObjectContext {	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator * coordinator = [self persistentStoreCoordinator];
    
	if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
		
		//[[FKMOCIndexesManager defaultManager] setManagedObjectContext:managedObjectContext];
    }
	
    return managedObjectContext;
}

/*
 Returns the NSUndoManager for the application.  In this case, the manager
 returned is that of the managed object context for the application.
 */

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

/*
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.  Any encountered errors
 are presented to the user.
 */

- (IBAction)saveAction:(id)sender
{
    NSError * error = nil;
	
    if ( ![[self managedObjectContext] save:&error] )
	{
        [[NSApplication sharedApplication] presentError:error];
    }
}

/*
 Implementation of the applicationShouldTerminate: method, used here to
 handle the saving of changes in the application managed object context
 before the application terminates.
 */

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    NSError * error = nil;
    int reply = NSTerminateNow;
    
    if ( managedObjectContext != nil )
	{
        if ( [managedObjectContext commitEditing] )
		{
            if ( [managedObjectContext hasChanges] && ![managedObjectContext save:&error] )
			{
                // This error handling simply presents error information in a panel with an 
                // "Ok" button, which does not include any attempt at error recovery (meaning, 
                // attempting to fix the error.)  As a result, this implementation will 
                // present the information to the user and then follow up with a panel asking 
                // if the user wishes to "Quit Anyway", without saving the changes.
				
                // Typically, this process should be altered to include application-specific 
                // recovery steps.  
				
                BOOL errorResult = [self presentError:error];
				
                if ( errorResult == YES )
				{
                    reply = NSTerminateCancel;
                } 
				else
				{
                    int alertReturn = NSRunAlertPanel(nil, @"Could not save changes while quitting. Quit anyway?" , @"Quit anyway", @"Cancel", nil);
					
                    if ( alertReturn == NSAlertAlternateReturn )
					{
                        reply = NSTerminateCancel;	
                    }
                }
            }
        } 
        else
		{
            reply = NSTerminateCancel;
        }
    }
    
    return reply;
}

@synthesize persistentStore;
@synthesize draggedItem;
@synthesize dragOperation;
@synthesize menuViewMinWidth;
@synthesize moduleViewMinWidth;
@end