//
//  FKSubviewTableViewCell.m
//  FKKit
//

#import "FKSubviewTableViewCell.h"
#import "FKSubviewTableViewController.h"


@implementation FKSubviewTableViewCell

- (void)dealloc
{
    [self setView:nil];
	
    [super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (NSView *)view
{
    return view;
}

#pragma mark -
#pragma mark SETTERS

- (void)setView:(NSView *)aView
{
    view = aView;
}

#pragma mark -
#pragma mark DRAWING

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [super drawWithFrame:cellFrame inView:controlView];

    [[self view] setFrame:cellFrame];

    if ( [[self view] superview] != controlView )
    {
		[controlView addSubview:[self view]];
    }
}

@end
