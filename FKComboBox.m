//
//  FKComboBox.m
//  FK
//
//  Created by Eric Morand on 05/03/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import "FKComboBox.h"
#import "FKComboBoxCell.h"

@implementation FKComboBox

+ (Class)cellClass
{
	return [FKComboBoxCell class];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	NSArchiver * anArchiver = [[NSArchiver alloc] initForWritingWithMutableData:[NSMutableData dataWithCapacity: 256]];
	[anArchiver encodeClassName:@"NSComboBoxCell" intoClassName:@"FKComboBoxCell"];
	[anArchiver encodeRootObject:[self cell]];
	[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
	
	return self;
}

- (void)awakeFromNib
{
	//[[NSNotificationCenter defaultCenter] addObserver:_delegate selector:@selector(comboBoxDidAcceptFirstResponder:) name:@"NSComboBoxDidAccepFirstResponder" object:self];	
	//[[NSNotificationCenter defaultCenter] addObserver:_delegate selector:@selector(comboBoxSelectionIsChanging:) name:@"NSComboBoxSelectionIsChangingNotification" object:self];
	//[[NSNotificationCenter defaultCenter] addObserver:_delegate selector:@selector(comboBoxSelectionDidChange:) name:@"NSComboBoxSelectionDidChangeNotification" object:self];	
	
	[[self cell] setDelegate:self];
	[[self cell] awakeFromNib];
}

#pragma mark -
#pragma mark GETTERS

#pragma mark -
#pragma mark SETTERS

- (void)setObjectValue:(id)object {[[self cell] setObjectValue:object];}
- (void)setPlaceholderString:(NSString *)string {[[self cell] setPlaceholderString:string];}

- (void)setRightAnglesMask:(unsigned)anInt {[[self cell] setRightAnglesMask:anInt];}
- (void)setStrokedBordersMask:(unsigned)anInt {[[self cell] setStrokedBordersMask:anInt];}

- (BOOL)becomeFirstResponder
{	
	BOOL result = [super becomeFirstResponder];
	
	if ( result )
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"NSComboBoxDidAccepFirstResponder" object:self];
	}
	
	return result;
}

#pragma mark -
#pragma mark FKComboBoxCell DELEGATE

- (BOOL)comboBoxShouldSelectRow:(int)rowIndex
{
	if ( [[self delegate] respondsToSelector:@selector(comboBox:shouldSelectRow:)] )
	{		
		return [[self delegate] comboBox:self shouldSelectRow:rowIndex];
	}
	
	return YES;
}

- (void)comboBoxWillDisplayCell:(id)aCell atRow:(int)rowIndex
{
	if ( [[self delegate] respondsToSelector:@selector(comboBox:willDisplayCell:atRow:)] )
	{
		[[self delegate] comboBox:self willDisplayCell:aCell atRow:rowIndex];
	}
}

- (float)comboBoxHeightOfRow:(int)row
{
	float rowHeight = 0;
	
	if ( [[self delegate] respondsToSelector:@selector(comboBox:heightOfRow:)] )
	{
		rowHeight = [[self delegate] comboBox:self heightOfRow:row];
	}
	
	return ( rowHeight ? rowHeight : 0 );	
}

#pragma mark -
#pragma mark FKComboBoxCell DATASOURCE

- (id)textFieldObjectValueForSelectedItemOfComboBoxCell:(FKComboBoxCell *)aComboBoxCell
{
	id anObject = nil;
	
	if ( [self usesDataSource] )
	{
		if ( [[self dataSource] respondsToSelector:@selector(textFieldObjectValueForSelectedItemOfComboBox:)] )
		{
			anObject = [[self dataSource] textFieldObjectValueForSelectedItemOfComboBox:self];
		}
	}
	
	return anObject;
}

#pragma mark -
#pragma mark NSComboBoxCell Delegate

- (void)cellTableViewSelectionDidChange:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NSComboBoxSelectionDidChangeNotification" object:self];
}

- (void)cellTableViewSelectionIsChanging:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NSComboBoxSelectionIsChangingNotification" object:self];	
}

- (void)comboBoxCellWillDismiss:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NSComboBoxWillDismissNotification" object:self];
}

- (void)comboBoxCellWillPopUp:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NSComboBoxWillPopUpNotification" object:self];
}

#pragma mark -
#pragma mark MISC

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
