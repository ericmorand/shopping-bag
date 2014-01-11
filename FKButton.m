//
//  FKButton.m
//  FKKit
//
//  Created by Eric on 01/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKButton.h"
#import "FKButtonCell.h"


@implementation FKButton

+ (Class)cellClass
{
	return [FKButtonCell class];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if ( self )
	{
		Class cellClass = [[self class] cellClass];
		
		NSButtonCell * oldCell = [self cell];
				
		id newCell = [[[cellClass alloc] init] autorelease];
		
		[newCell setAction:[oldCell action]];
		[newCell setAllowsEditingTextAttributes:[oldCell allowsEditingTextAttributes]];
		[newCell setAlignment:[oldCell alignment]];
		[newCell setAllowsMixedState:[oldCell allowsMixedState]];
		[newCell setAllowsUndo:[oldCell allowsUndo]];
		[newCell setAttributedStringValue:[oldCell attributedStringValue]];
		[newCell setBaseWritingDirection:[oldCell baseWritingDirection]];
		[newCell setContinuous:[oldCell isContinuous]];
		[newCell setFormatter:[oldCell formatter]];	
		[newCell setImage:[oldCell image]];
		[newCell setImagePosition:[oldCell imagePosition]];
		[newCell setLineBreakMode:[oldCell lineBreakMode]];
		[newCell setRepresentedObject:[oldCell representedObject]];
		[newCell setScrollable:[oldCell isScrollable]];
		[newCell setSelectable:[oldCell isSelectable]];
		[newCell setSendsActionOnEndEditing:[oldCell sendsActionOnEndEditing]];
		[newCell setShowsFirstResponder:[oldCell showsFirstResponder]];
		[newCell setState:[oldCell state]];
		[newCell setTarget:[oldCell target]];
		[newCell setTitle:[oldCell title]];
		[newCell setType:[oldCell type]];
		[newCell setWraps:[oldCell wraps]];
				
		[self setCell:newCell];
	}
	
	return self;
}

- (void)commonSetup
{
}

#pragma mark -
#pragma mark GETTERS

- (BOOL)isOpaque {return NO;}
- (BOOL)isFlipped {return NO;}

#pragma mark -
#pragma mark SETTERS

- (void)setFkBezelStyle:(FKBezelStyle)aStyle {[[self cell] setFkBezelStyle:aStyle];}
- (void)setBorderMask:(unsigned)anInt {[[self cell] setBorderMask:anInt];}
- (void)setLeftMargin:(float)aFloat {[[self cell] setLeftMargin:aFloat];}
- (void)setRightMargin:(float)aFloat {[[self cell] setRightMargin:aFloat];}

- (void)setTitle:(NSString *)aString
{
	if ( [aString isKindOfClass:[NSNumber class]] )
	{
		aString = [(NSNumber *)aString stringValue];
	}
	
	[super setTitle:aString];
}

#pragma mark -
#pragma mark MISC

- (void)sizeToFit
{
	[self setFrameSize:[[self cell] cellSize]];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
	NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter removeObserver:self name:NSWindowDidResignKeyNotification object:nil];
	[defaultCenter addObserver:self selector:@selector(windowDidChangeKeyNotification:) name:NSWindowDidResignKeyNotification object:newWindow];
	
	[defaultCenter removeObserver:self name:NSWindowDidBecomeKeyNotification object:nil];
	[defaultCenter addObserver:self selector:@selector(windowDidChangeKeyNotification:) name:NSWindowDidBecomeKeyNotification object:newWindow];
}

- (void)windowDidChangeKeyNotification:(NSNotification *)notification
{
	[self setNeedsDisplay:YES];
}

@end

#pragma mark -
#pragma mark FKGradientButton
#pragma mark -

@implementation FKGradientButton

+ (Class)cellClass
{
	return [FKGradientButtonCell class];
}

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if ( self )
	{
		[self commonSetup];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{	
	self = [super initWithCoder:decoder];
	
	if ( self )
	{
		[self commonSetup];
	}
	
	return self;
}

@end

#pragma mark -
#pragma mark FKPlateGradientButton
#pragma mark -

@implementation FKPlateGradientButton

+ (Class)cellClass
{
	return [FKPlateGradientButtonCell class];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if ( self )
	{
		//[self setRightAnglesMask:FKEveryBorder];
	}
	
	return self;
}


#pragma mark -
#pragma mark SETTERS

- (void)setRightAnglesMask:(unsigned)anInt {[[self cell] setRightAnglesMask:anInt];}
- (void)setStrokedBordersMask:(unsigned)anInt {[[self cell] setStrokedBordersMask:anInt];}

@end

#pragma mark -
#pragma mark FKRSPlateGradientButton
#pragma mark -

@implementation FKRSPlateGradientButton

- (void)commonSetup
{
	[super commonSetup];
	
	[self setRightAnglesMask:(FKTopLeftAngle | FKBottomLeftAngle)];
	[self setStrokedBordersMask:(FKEveryBorder - FKLeftBorder)];
	[self setLeftMargin:1.0];
}

@end
