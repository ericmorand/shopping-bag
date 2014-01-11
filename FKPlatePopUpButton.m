//
//  FKPlatePopUpButton.m
//  FKKit
//
//  Created by Eric on 05/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKPlatePopUpButton.h"
#import "FKPlatePopUpButtonCell.h"


@implementation FKPlatePopUpButton

+ (Class)cellClass
{
	return [FKPlatePopUpButtonCell class];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	NSPopUpButtonCell * currentCell = nil;
	FKPlatePopUpButtonCell * newCell = nil;
	Class cellClass = nil;
	
	cellClass = [[self class] cellClass];
	
	if ( ![[self cell] isKindOfClass:cellClass] )
	{
		currentCell = [self cell];
		
		newCell = [[cellClass alloc] init];
		
		[newCell setMenu:[currentCell menu]];
		[newCell setControlSize:[currentCell controlSize]];
		[newCell setFont:[currentCell font]]; // Voir ici : http://www.cocoabuilder.com/archive/message/cocoa/2005/3/22/131056
		[newCell setEditable:[currentCell isEditable]];
		[newCell setAutoenablesItems:[currentCell autoenablesItems]];
		
		[self setCell:newCell];
	}
	
	return self;
}

#pragma mark -
#pragma mark GETTERS

- (FKPlateGradientButtonCell *)drawingCell {return [[self cell] drawingCell];}

#pragma mark -
#pragma mark SETTERS

- (void)setMainTitle:(NSString *)aString {[[self cell] setMainTitle:aString];}
- (void)setTitleForegroundColor:(NSColor *)aColor {[[self cell] setTitleForegroundColor:aColor];}
- (void)setRightAnglesMask:(unsigned)anInt {[[self cell] setRightAnglesMask:anInt];}
- (void)setStrokedBordersMask:(unsigned)anInt {[[self cell] setStrokedBordersMask:anInt];}

#pragma mark -
#pragma mark LAYOUT

- (void)sizeToFit
{
	[self setFrameSize:[[self cell] cellSize]];
}

@end
