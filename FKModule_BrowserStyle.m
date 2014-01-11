//
//  FKModule_BrowserStyle.m
//  FKKit
//
//  Created by Eric on 21/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModule_BrowserStyle.h"


@implementation FKModule (BrowserStyle)

#pragma mark A TRIER


- (NSArray *)sortDescriptors {return nil;} //sortDescriptors;}

- (NSArray *)selectedObjects {
	return [objectsArrayController selectedObjects];
}

#pragma mark -
#pragma mark GETTERS

- (id)managedObjectWithValue:(id)value forKey:(NSString *)key
{
	NSManagedObject * managedObjectWithValue = nil;
	
	if ( nil != value )
	{
		NSString * entityName = [self entityName];
		
		// ...
		
		NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", key, value];
		NSArray * results = nil;
		
		NSArray * selectedObjects = nil;
		
		[fetchRequest setEntity:entity];
		[fetchRequest setPredicate:predicate];
		
		results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
		
		if ( [results count] > 0 )
		{
			managedObjectWithValue = [results objectAtIndex:0];
		}
		else
		{
			int returnCode = [self showInexistantObjectAlertSheetWithValue:value modalForWindow:[NSApp mainWindow]];
			
			if ( ( returnCode == NSAlertFirstButtonReturn ) || ( returnCode == NSAlertThirdButtonReturn ) ) // Ajouter ou Ajouter et continuer
			{
				managedObjectWithValue = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
				
				[managedObjectWithValue setValue:value forKey:key];
				
				if ( returnCode == NSAlertFirstButtonReturn ) // Ajouter
				{
					[self addObjects:[NSArray arrayWithObjects:managedObjectWithValue, nil]];
					
					selectedObjects = [NSArray arrayWithObjects:managedObjectWithValue, nil];
					
					[self showBrowserSheetModalForWindow:[NSApp mainWindow] selectedObjects:&selectedObjects];
				}
			}
		}
	}
	
	return managedObjectWithValue;
}

- (void)setupLayoutUsingBrowserStyle {
	NSRect bounds = NSBigRect();
	
	self.browserModuleView = [[[FKView	alloc] initWithFrame:bounds] autorelease];
		
	NSRect miniViewRect = NSZeroRect;
	NSRect bottomBarRect = NSZeroRect;

	NSDivideRect(bounds, &bottomBarRect, &miniViewRect, 40.0, NSMinYEdge);

	// miniModuleView
		
	FKView * miniView = self.miniModuleView;
	
	[miniView setFrame:miniViewRect];
	[miniView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	[multipleObjectsLeftTableView setDoubleAction:@selector(multipleObjectsLeftTableViewBrowserStyleDoubleAction:)];	
	
	[browserModuleView addSubview:miniView];
		
	// browserWindowBottomBar
		
	browserWindowBottomBar = [[[FKView alloc] initWithFrame:bottomBarRect] autorelease];
		
	[browserWindowBottomBar setAutoresizingMask:(NSViewWidthSizable | NSViewMaxYMargin)];

	NSRect buttonFrame = NSZeroRect;

	buttonFrame.size.width = 80.0;
	buttonFrame.size.height = 25.0;
	buttonFrame.origin.x = NSWidth(bottomBarRect) - (NSWidth(buttonFrame) + 20.0);
	buttonFrame.origin.y = floor((NSHeight(bottomBarRect) - NSHeight(buttonFrame)) / 2.0);
	
	// browserWindowSubmitButton
	
	browserWindowSubmitButton = [[[NSButton alloc] initWithFrame:buttonFrame] autorelease];
		
	[browserWindowSubmitButton setTitle:@"OK"];
	[browserWindowSubmitButton setBezelStyle:NSTexturedRoundedBezelStyle];
	[browserWindowSubmitButton setAutoresizingMask:NSViewMinXMargin];
	[browserWindowSubmitButton setTarget:self];
	[browserWindowSubmitButton setAction:@selector(browserWindowOKButtonAction:)];
	
	[browserWindowBottomBar addSubview:browserWindowSubmitButton];	
	
	// browserWindowCancelButton
	
	buttonFrame.origin.x -= (NSWidth(buttonFrame) + 8.0);	
	
	browserWindowCancelButton = [[[NSButton alloc] initWithFrame:buttonFrame] autorelease];

	[browserWindowCancelButton setTitle:@"Annuler"];
	[browserWindowCancelButton setBezelStyle:NSTexturedRoundedBezelStyle];
	[browserWindowCancelButton setAutoresizingMask:NSViewMinXMargin];
	[browserWindowCancelButton setTarget:self];
	[browserWindowCancelButton setAction:@selector(browserWindowCancelButtonAction:)];
	
	[browserWindowBottomBar addSubview:browserWindowCancelButton];
	
	[browserModuleView addSubview:browserWindowBottomBar];	
	
	[browserWindow setContentBorderThickness:NSHeight(bottomBarRect) forEdge:NSMinYEdge];	
	
	self.moduleStyle = FKModuleBrowserStyle;
}

- (void)finalizeSetupModuleViewUsingBrowserStyle {
}

#pragma mark -
#pragma mark SHEETS MANAGEMENT

- (void)showBrowserSheetModalForWindow:(NSWindow *)aWindow selectedObjects:(NSArray **)selectedObjects {
	[self setupLayoutUsingFullStyle];
	[self setupLayoutUsingBrowserStyle];
	
	[browserWindow setContentView:self.browserModuleView];
	
	if (nil != selectedObjects) {
		[objectsArrayController setSelectedObjects:*selectedObjects];
	}
		
	NSWindow * browserSheet = [self browserWindow];
	int returnCode = NSCancelButton;
	
	[NSApp beginSheet:browserSheet modalForWindow:aWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	
	returnCode = [NSApp runModalForWindow:browserSheet];
	
	[browserSheet orderOut:self];
	
	if (returnCode) {
		*selectedObjects = [objectsArrayController selectedObjects];
	}	
}

- (void)showBrowserWindowModalForWindow:(NSWindow *)aWindow selectedObjects:(NSArray **)selectedObjects {	
	[browserWindow setContentView:self.browserModuleView];
	
	if (nil != selectedObjects) {
		[objectsArrayController setSelectedObjects:*selectedObjects];
	}
	
	int returnCode = NSCancelButton;
		
	returnCode = [NSApp runModalForWindow:browserWindow];
	
	[browserWindow orderOut:self];
	
	if (returnCode) {
		*selectedObjects = [objectsArrayController selectedObjects];
	}	
}

#pragma mark -
#pragma mark ALERTS

- (void)inexistantObjectAlertSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	[NSApp stopModalWithCode:returnCode];
}

- (int)showInexistantObjectAlertSheetWithValue:(NSString *)objectName modalForWindow:(NSWindow *)aWindow;
{
	NSAlert * alert = [[[NSAlert alloc] init] autorelease];
	
	[alert setMessageText:[NSString stringWithFormat:NSLocalizedString(@"InexistantBrandMessageText", @""), objectName]];
	[alert setInformativeText:[NSString stringWithFormat:NSLocalizedString(@"InexistantBrandInformativeText", @""), objectName]];
	[alert addButtonWithTitle:NSLocalizedString(@"Add", @"")];
	[alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
	[alert addButtonWithTitle:NSLocalizedString(@"AddAndContinue", @"")];
	//[alert _setDontWarnMessage:NSLocalizedString(@"DontWarn", @"")];
	
	[alert beginSheetModalForWindow:aWindow
					  modalDelegate:self
					 didEndSelector:@selector(inexistantObjectAlertSheetDidEnd:returnCode:contextInfo:)
						contextInfo:nil];
	
	return [NSApp runModalForWindow:[alert window]];
}

#pragma mark -
#pragma mark ACTIONS

- (void)multipleObjectsLeftTableViewBrowserStyleDoubleAction:(id)sender {
	NSPoint mouseLocation = [[[multipleObjectsLeftTableView window] currentEvent] locationInWindow];
	
	mouseLocation = [multipleObjectsLeftTableView convertPoint:mouseLocation fromView:nil];
	
	int clickedRow = [multipleObjectsLeftTableView rowAtPoint:mouseLocation];
	
	if (clickedRow > -1) {
		[self browserWindowOKButtonAction:nil];
	}
}

- (void)listViewPlusButtonAction:(id)sender
{	
	[objectsArrayController insert:self];
	
	[managedObjectContext processPendingChanges];
}

- (void)listViewMinusButtonAction:(id)sender
{
	[objectsArrayController remove:self];
	
	[managedObjectContext processPendingChanges];
}

- (void)browserWindowCancelButtonAction:(id)sender
{
	[NSApp endSheet:browserWindow];
	[NSApp stopModalWithCode:NSCancelButton];
}

- (void)browserWindowOKButtonAction:(id)sender
{
	//NSResponder * firstResponder = [[browserView window] firstResponder];
	
	BOOL isValid = TRUE; // [[moduleView window] makeFirstResponder:nil];
	
	if (isValid) {
		[NSApp endSheet:browserWindow];
		[NSApp stopModalWithCode:NSOKButton];
	}
}

@end
