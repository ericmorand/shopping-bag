//
//  FKModuleCenter.m
//  FKKit
//
//  Created by Eric on 16/10/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleCenter.h"


@implementation FKModuleCenter

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setModulesArray:[NSMutableArray array]];
		
		// Initialisation de tous les modules de l'application
		
		
	}

	return self;
}

- (void)dealloc
{
	[self setModulesArray:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark SETTERS

- (void)setModulesArray:(NSMutableArray *)anArray
{
	if ( anArray != modulesArray )
	{
		[modulesArray release];
		modulesArray = [anArray retain];
	}
}

- (void)setCurrentModule:(FKModule *)newModule
{
	if ( newModule != currentModule )
	{
		//NSWindow * window = [self window];
		
		//[[NSNotificationCenter defaultCenter] removeObserver:currentModule name:NSWindowDidUpdateNotification object:window];
		
		[currentModule release];
		currentModule = [newModule retain];
		
		//[[NSNotificationCenter defaultCenter] addObserver:currentModule selector:@selector(windowDidUpdate:) name:NSWindowDidUpdateNotification object:window];
	}
}

- (void)setNextModule:(FKModule *)newModule
{
	if ( newModule != nextModule )
	{
		[nextModule release];
		nextModule = [newModule retain];
	}
}

#pragma mark -
#pragma mark MODULES MANAGEMENT

- (FKModule *)moduleNamed:(NSString *)moduleName
{
	FKModule * moduleNamed = nil;	
	
	FKModule * aModule = nil;
	Class moduleClass = nil;
	
	moduleClass = NSClassFromString([NSString stringWithFormat:@"%@Module", moduleName]);
	
	for ( aModule in modulesArray )
	{
		if ( [aModule isMemberOfClass:moduleClass] )
		{
			moduleNamed = aModule;
			
			break;
		}
	}
	
	if ( nil == moduleNamed )
	{
		// Le module n'existe pas encore dans le tableau des modules :
		// on l'initialise, on l'ajoute et on le retourne
		
		moduleNamed = [moduleClass moduleWithContext:[self managedObjectContext]];
		
		if ( moduleNamed )
		{
			[moduleNamed setDelegate:self];
			
			[modulesArray addObject:moduleNamed];
		}
		else
		{
			NSLog (@"Erreur : Le module '%@' n'a pas pu etre initialise !", moduleName);
		}
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

- (void)selectModuleNamed:(NSString *)moduleName userInfo:(NSDictionary *)userInfo // FIXFIXFIX !!!
{
	FKModule * newModule = nil;
	
	newModule = [self moduleNamed:moduleName];
	
	if ( [self shouldSelectModule:newModule] )
	{
		[self _selectModule:newModule userInfo:userInfo];
	}
}

- (void)unselectCurrentModule
{
	[currentModule willUnselect];
	
	[self setCurrentModule:nil];
}

- (void)selectNextModule
{	
	[nextModule willSelect];
	
	[self setCurrentModule:nextModule];
	[self setNextModule:nil];
	
	NSView * moduleView = [currentModule moduleView];
	
	//[moduleView setFrame:[moduleContentView contentFrame]];
	//[moduleContentView setContentView:moduleView];
	
	[[self window] setToolbar:[currentModule mainToolbar]];
	
	// didSelect
	
	[currentModule didSelect];
}

- (void)currentModuleHasAcceptedToUnselect
{
	[self unselectCurrentModule];
	[self selectNextModule];
}

@end
