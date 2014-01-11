//
//  FKNavigationToolbarItem.m
//  FK
//
//  Created by Eric on 07/03/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKNavigationToolbarItem.h"
#import "FKToolbarItemView.h"


@implementation FKNavigationToolbarItem

- (id)initWithItemIdentifier:(NSString *)itemIdentifier
{
	self = [super initWithItemIdentifier:itemIdentifier];
	
	if ( self )
	{
		FKToolbarItemView * buttonsView = [[[FKToolbarItemView alloc] initWithFrame:NSZeroRect] autorelease];
		
		previousButton = [[[FKToolbarItemButton alloc] initWithFrame:NSZeroRect] autorelease];
				
		[previousButton setImage:[NSImage imageNamed:@"Previous" forClass:[self class]]];
		[previousButton setRightAnglesMask:FKRightBorder];
		[previousButton sizeToFit];
		
		nextButton = [[[FKToolbarItemButton alloc] initWithFrame:NSZeroRect] autorelease];
		
		[nextButton setImage:[NSImage imageNamed:@"Next" forClass:[self class]]];
		[nextButton setRightAnglesMask:FKLeftBorder];		
		[nextButton sizeToFit];
		
		// ...
		
		NSRect viewFrame = NSZeroRect;
		NSRect previousButtonFrame = [previousButton frame];
		NSRect nextButtonFrame = [nextButton frame];
		
		// ...
		
		nextButtonFrame.origin.x += NSMaxX(previousButtonFrame) + 1.0;
		
		[nextButton setFrame:nextButtonFrame];
		
		// ...
		
		viewFrame.size.width = NSMaxX(nextButtonFrame);
		viewFrame.size.height = MAX(NSHeight(previousButtonFrame), NSHeight(nextButtonFrame));
		
		[buttonsView setFrame:viewFrame];
		
		// ...
		
		[buttonsView addSubview:previousButton];
		[buttonsView addSubview:nextButton];
		
		[self setView:buttonsView];
		[self setMinSize:viewFrame.size];
		[self setMaxSize:viewFrame.size];
	}
	
	return self;
}

- (void)setTarget:(id)target
{
	//[previousButton setTarget:target];
	//[nextButton setTarget:target];
}

- (void)setPreviousAction:(SEL)aSelector
{
	//[previousButton setAction:aSelector];
}

- (void)setNextAction:(SEL)aSelector
{
	//[nextButton setAction:aSelector];
}

- (void)setPreviousEnabled:(BOOL)flag
{
	//[previousButton setEnabled:flag];
}

- (void)setNextEnabled:(BOOL)flag
{
	//[previousButton setEnabled:flag];
}

/*- (void)validate
{
	id target = [previousButton target];
	
	if ( [target respondsToSelector:@selector(validateToolbarItem:)] )
	{
		[[previousButton target] validateToolbarItem:self];
	}
}*/

@synthesize previousButton;
@synthesize nextButton;
@end
