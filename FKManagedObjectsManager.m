//
//  FKManagedObjectsManager.m
//  ShoppingBag
//
//  Created by Eric on 06/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKManagedObjectsManager.h"

#import "FKButton.h"
#import "FKModuleBottomBar.h"
#import "FKView.h"


static NSMutableDictionary * defaultManagersDictionary = nil;

@implementation FKManagedObjectsManager

+ (id)defaultManagerWithManagedObjectContext:(NSManagedObjectContext *)aContext
{
	NSLog (@" managedObjectContext = %@", aContext);
	
	id defaultManager = nil;
	
	NSString * entityName = [self entityName];	
	
	if ( nil == defaultManagersDictionary )
	{
		defaultManagersDictionary = [[NSMutableDictionary dictionary] retain];
	}
		
	defaultManager = [defaultManagersDictionary objectForKey:entityName];
	
	if ( nil == defaultManager )
	{
		defaultManager = [[[self alloc] init] autorelease];
		
		[defaultManagersDictionary setValue:defaultManager forKey:entityName];
	}
	
	[defaultManager setManagedObjectContext:aContext];
	
	return defaultManager;
}

@synthesize objectsArrayController;
@synthesize listViewMinWidth;
@synthesize informationsViewMinWidth;
@synthesize browserViewBorderedView;
@synthesize browserViewSplitView;
@synthesize browserViewBottomBar;
@synthesize browserViewPlusButton;
@synthesize browserViewMinusButton;
@synthesize browserViewSearchField;
@synthesize listView;
@synthesize listViewScrollView;
@synthesize listViewTableView;
@synthesize informationsView;
@synthesize informationsViewScrollView;
@synthesize informationsViewStackView;
@synthesize miniBrowserTableScrollView;
@synthesize miniBrowserTableView;
@synthesize miniBrowserInformationsView;
@synthesize browserWindowBorderedView;
@synthesize browserWindowBottomBar;
@synthesize browserWindowCancelButton;
@synthesize browserWindowSubmitButton;
@end
