//
//  PreferencesController.m
//  FKKit
//
//  Created by Eric on 06/05/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController

- (id)init
{
	self = [super initWithIdentifier:@"Preferences"];
	
	if ( self )
	{
		defaultScannersManager = [FKBarcodeScannersManager defaultManager];
	}
	
	return self;
}

- (void)dealloc
{	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (int)numberOfPanes {return 5;}

- (NSView *)viewForPaneAtIndex:(int)paneIndex
{
	NSView * paneView = nil;
	
	switch (paneIndex)
	{
		//case 0 : {paneView = generalView; break;}
		case 0 : {paneView = barcodeReadersView; break;}
	}
	
	return paneView;
}

- (NSString *)identifierForPaneAtIndex:(int)paneIndex
{
	NSString * paneIdentifier = nil;
	
	switch (paneIndex)
	{
		//case 0 : {paneIdentifier = @"GeneralPreferences"; break;}
		//case 1 : {paneIdentifier = NSToolbarSeparatorItemIdentifier; break;}
		case 0 : {paneIdentifier = @"BarcodeReadersPreferences"; break;}
	}
		
	return paneIdentifier;
}

#pragma mark -
#pragma mark ACTIONS

#pragma mark -
#pragma mark NSWindows Delegate

- (void)windowWillClose:(NSNotification *)aNotification
{
	// Ecriture des modifications de preferences sur le disque
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize generalView;
@synthesize barcodeReadersView;
@synthesize defaultScannersManager;
@end
