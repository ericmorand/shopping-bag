//
//  FKComboBoxCell.m
//  FK
//
//  Created by Eric on 15/07/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import "FKComboBoxCell.h"
//#import "FKTextFieldCell.h"


@implementation FKComboBoxCell

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if ( self )
	{
		//FKTextFieldCell * aCell = [[[FKTextFieldCell alloc] init] autorelease];
	
		//[aCell setLineBreakMode:NSLineBreakByTruncatingTail];
		
		//[[[_tableView tableColumns] objectAtIndex:0] setDataCell:aCell];
		
		FKPlatePopUpButtonCell * newButtonCell = [[[FKPlatePopUpButtonCell alloc] init] autorelease];
		NSPopUpButtonCell * oldButtonCell = [self valueForKey:@"_buttonCell"];
		
		[newButtonCell setRightAnglesMask:FKEveryAngle];
		[newButtonCell setPullsDown:YES];
		[newButtonCell setControlSize:-1];	
		//[newButtonCell setHighlighted:YES];
		
		[newButtonCell bind:@"highlighted" toObject:oldButtonCell withKeyPath:@"highlighted" options:nil];
		
		[self setButtonCell:newButtonCell];
	}
	
	return self;
}

- (void)dealloc
{
	[self setButtonCell:nil];
	
	[super dealloc];
}

- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:_delegate selector:@selector(cellTableViewSelectionIsChanging:) name:@"NSTableViewSelectionIsChangingNotification" object:_tableView];
	[[NSNotificationCenter defaultCenter] addObserver:_delegate selector:@selector(cellTableViewSelectionDidChange:) name:@"NSTableViewSelectionDidChangeNotification" object:_tableView];
	[[NSNotificationCenter defaultCenter] addObserver:_delegate selector:@selector(comboBoxCellWillDismiss:) name:@"NSComboBoxCellWillDismissNotification" object:self];
	[[NSNotificationCenter defaultCenter] addObserver:_delegate selector:@selector(comboBoxCellWillPopUp:) name:@"NSComboBoxCellWillPopUpNotification" object:self];
}

#pragma mark -
#pragma mark GETTERS

- (NSButtonCell *)buttonCell {return buttonCell;}

#pragma mark -
#pragma mark SETTERS

- (void)setDelegate:(id)delegate {_delegate = delegate;}
- (void)setHighlighted:(BOOL)flag {[buttonCell setHighlighted:flag];}

- (void)setButtonCell:(NSButtonCell *)aCell
{
	if ( aCell != buttonCell )
	{
		[buttonCell release];
		buttonCell = [aCell retain];
	}
}

- (void)setRightAnglesMask:(unsigned)anInt {[buttonCell setRightAnglesMask:anInt];}
- (void)setStrokedBordersMask:(unsigned)anInt {[buttonCell setStrokedBordersMask:anInt];}

#pragma mark -
#pragma mark NSTableView DELEGATE

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(int)rowIndex
{
	if ( [_delegate respondsToSelector:@selector(comboBoxShouldSelectRow:)] )
	{		
		return [_delegate comboBoxShouldSelectRow:rowIndex];
	}
	
	return YES;
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
	if ( [_delegate respondsToSelector:@selector(comboBoxWillDisplayCell:atRow:)] )
	{		
		[_delegate comboBoxWillDisplayCell:aCell atRow:rowIndex];
	}
}

- (float)tableView:(NSTableView *)tableView heightOfRow:(int)row
{
	float rowHeight = 0.0;
	
	if ( [_delegate respondsToSelector:@selector(comboBoxHeightOfRow:)] )
	{		
		rowHeight = [_delegate comboBoxHeightOfRow:row];
		
		return ( rowHeight ? rowHeight : [tableView rowHeight] );
	}
	
	return [tableView rowHeight];
}

#pragma mark -
#pragma mark DRAWING

- (NSRect)focusRingFrameForCellFrame:(NSRect)cellFrame
{
	NSRect focusRingFrame = cellFrame;
	
	focusRingFrame.size.width -= 1.5;
	focusRingFrame.size.height -= 3.0;
	focusRingFrame.origin.y += 1.0;
		
	return focusRingFrame;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
	[super drawWithFrame:cellFrame inView:controlView];
		
	if ( [self showsFirstResponder] )
	{
		NSBezierPath * focusRingPath = nil;
		
		focusRingPath = [buttonCell strokePathWithFrame:[self focusRingFrameForCellFrame:cellFrame] inView:controlView];
		
		[NSGraphicsContext saveGraphicsState];
		
		NSSetFocusRingStyle(NSFocusRingOnly);
		
		[focusRingPath fill];
		
		[NSGraphicsContext restoreGraphicsState];
	}
}

//- (struct _NSRect)_focusRingFrameForFrame:(struct _NSRect)fp8 cellFrame:(struct _NSRect)fp24
//{
//	return NSZeroRect;
//}

- (void)_drawThemeComboBoxButtonWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSRect pathRect = NSZeroRect;

	NSDivideRect(cellFrame, &pathRect, &cellFrame, 18.0, NSMaxXEdge);
	
	pathRect = NSInsetRect(pathRect, 0.0, 1.0);
	
	pathRect.size.width -= 2.0;
	pathRect.size.height -= 1.0;
		
	[buttonCell setEnabled:[_buttonCell isEnabled]];
	
	[buttonCell drawWithFrame:pathRect inView:controlView];
}

@end
