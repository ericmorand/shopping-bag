//
//  FKFlatRoundedButton.m
//  FK
//
//  Created by Eric on 05/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKFlatRoundedButton.h"
#import "FKFlatRoundedButtonCell.h"


@implementation FKFlatRoundedButton

+ (Class)cellClass
{
	return [FKFlatRoundedButtonCell class];
}

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if ( self )
	{
		FKFlatRoundedButtonCell * currentCell = [self cell];
		
		[currentCell setBezelStyle:1]; // Voir ici : http://www.cocoabuilder.com/archive/message/cocoa/2006/2/4/156006
		[currentCell setEnabled:YES];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	NSPopUpButtonCell * currentCell = nil;
	FKFlatRoundedButtonCell * newCell = nil;
	
	if ( ![[self cell] isKindOfClass:[FKFlatRoundedButtonCell class]] )
	{
		currentCell = [self cell];
		
		newCell = [[FKFlatRoundedButtonCell alloc] init];
		
		[newCell setBezelStyle:[currentCell bezelStyle]];
		[newCell setEnabled:[currentCell isEnabled]];
		
		[self setCell:newCell];
	}
	
	return self;
}

#pragma mark -
#pragma mark GETTERS

- (BOOL)isOpaque {return NO;}

@end
