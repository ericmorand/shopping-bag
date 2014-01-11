//
//  FKStackView.m
//  ShoppingBag
//
//  Created by Eric on 23/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKStackView.h"

#import "FKStackableView.h"
#import "FKViewAnimation.h"

@interface FKStackView (Private)

- (void)fkStackViewCommonSetup;

- (void)addStackedView:(NSView *)aView;

- (unsigned)askDelegateForNumberOfStackedViews;
- (FKStackableView *)askDelegateForStackedViewAtIndex:(int)anIndex;
- (void)askDelegateToFinalizeStackedView:(FKStackableView **)aView;

@end

@implementation FKStackView

- (id)initWithCoder:(NSCoder *)decoder
{    
	self = [super initWithCoder:decoder];
    
	if ( self )
	{
		[self fkStackViewCommonSetup];
	}
	
    return self;
}

- (id)initWithFrame:(NSRect)frame
{    
	self = [super initWithFrame:frame];
    
	if ( self )
	{
		[self fkStackViewCommonSetup];
	}
	
    return self;
}

- (void)fkStackViewCommonSetup
{	
	minSize.width = 400.0;
	interviewSpacing = NSMakeSize(0.0, 0.0);
	
	[self setStackedViewsArray:[NSMutableArray array]];
	
	needsReload = YES;
}

- (void)dealloc
{
	[self setStackedViewsArray:nil];
	[self setExpandedView:nil];
	[self setDelegate:nil];
	
	[super dealloc];
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize
{
	[super resizeSubviewsWithOldSize:(NSSize)oldBoundsSize];
	
	[self tile];
}

#pragma mark -
#pragma mark GETTERS

- (BOOL)isFlipped {return YES;}

#pragma mark -
#pragma mark SETTERS

- (void)setStackedViewsArray:(NSMutableArray *)anArray
{
	if ( anArray != stackedViewsArray )
	{
		[stackedViewsArray release];
		stackedViewsArray = [anArray retain];
	}
}

- (void)setExpandedView:(FKStackableView *)aView {expandedView = aView;}

- (void)setDelegate:(id)anObject
{
	if ( anObject != delegate )
	{
		delegate = anObject;
		
		if ( needsReload )
		{
			[self reloadData];
		}
	}
}

#pragma mark -
#pragma mark VIEWS MANAGEMENT

- (void)reloadData
{	
	FKStackableView * stackedView = nil;
	
	unsigned numberOfStackedViews = [self askDelegateForNumberOfStackedViews];
	unsigned i = 0;		
	
	// ...
	
	for ( i = 0; i < [stackedViewsArray count]; i++ )
	{
		stackedView = [stackedViewsArray objectAtIndex:i];
		
		[stackedView removeFromSuperview];
	}
		
	[stackedViewsArray removeAllObjects];
	
	// ...
	
	for ( i = 0; i < numberOfStackedViews; i++ )
	{
		stackedView = [self askDelegateForStackedViewAtIndex:i];
		
		[self addStackedView:stackedView];	
	}
	
	// ...
	
	if ( [stackedViewsArray count] > 0 )
	{
		[self expandStackedView:[stackedViewsArray objectAtIndex:0] updateFirstResponder:YES animate:NO];
	}
	
	needsReload = NO;
}

- (void)addStackedView:(NSView *)aView
{	
	NSRect stackableViewFrame = NSZeroRect;
	
	FKStackableView * newStackableView = nil;
	FKStackableView * lastStackableView = nil;
	FKStackableView * firstStackableView = nil;
	
	// ...
	
	stackableViewFrame.origin.x = interviewSpacing.width;	
	stackableViewFrame.size.width = NSWidth([self frame]) - (interviewSpacing.width * 2.0);
	stackableViewFrame.size.height = 10000.0;
		
	newStackableView = [[[FKStackableView alloc] initWithFrame:stackableViewFrame] autorelease];
		
	[newStackableView setContentView:aView];
	[newStackableView setStackView:self];
	
	// On donne au "delegate" l'opportunite de modifier la vue a empiler
	// (definir le titre, l'image, les "first" et "lastResponders", etc.) 
		
	[delegate stackView:self finalizeStackedView:&newStackableView atIndex:[stackedViewsArray count]];
	
	// On met a jour la "responders chain" en reliant le "lastResponder" de la
	// derniere vue de la pile au "firstResponder" de la vue a empiler
	
	lastStackableView = [stackedViewsArray lastObject];
		
	[[lastStackableView lastResponder] setNextKeyView:[newStackableView firstResponder]];
	
	// On ajoute la vue a empiler dans la tableau
	
	[stackedViewsArray addObject:newStackableView];	
	
	// On finalise la "responders chain" en reliant le "lastResponder" de
	// la vue qui vient d'etre empilee au "firstResponder" de la premiere vue
	// de la pile (qui peut parfaitement etre la vue qui vient d'etre empilee)
	
	firstStackableView = [stackedViewsArray objectAtIndex:0];
	
	[[newStackableView lastResponder] setNextKeyView:[firstStackableView firstResponder]];
	
	// ...
	
	[self setFirstResponder:[firstStackableView firstResponder]]; 
	[self setLastResponder:[newStackableView lastResponder]]; 
	
	// Notifications
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stackedViewDidExpand:) name:FKStackableViewDidExpandNotification object:newStackableView];
	
	// Enfin, on ajoute la vue a empiler a la liste des "subviews"
	
	[self addSubview:newStackableView];
}

- (float)availableHeightToExpandStackedView:(FKStackableView *)stackedView
{	
	FKStackableView * aView = nil;
	
	float availableHeight = NSHeight([self frame]);
	
	unsigned i = 0;
	
	for ( ; i < [stackedViewsArray count]; i++ )
	{			
		aView = [stackedViewsArray objectAtIndex:i];
			
		if ( aView != stackedView )
		{
			availableHeight -= [aView collapsedHeight] + interviewSpacing.height;
		}
	}
	
	return availableHeight;
}

- (void)fkViewAnimationDidProgress:(FKViewAnimation *)animation
{	
	[self tile];
	[self display];
}

- (void)expandStackedView:(FKStackableView *)stackedView updateFirstResponder:(BOOL)firstResponderFlag animate:(BOOL)animateFlag
{	
	if ( [stackedView isCollapsed] || ( stackedView != expandedView ) )
	{
		// ...
	
		float newHeight = [self availableHeightToExpandStackedView:stackedView];	
	
		if ( animateFlag )
		{
			NSSize expandingViewStartFrameSize = NSZeroSize;
			NSSize expandingViewEndFrameSize = NSZeroSize;
			NSSize collapsingViewStartFrameSize = NSZeroSize;
			NSSize collapsingViewEndFrameSize = NSZeroSize;
	
			FKViewAnimation * viewAnimation = [[[FKViewAnimation alloc] initWithDuration:0.3 animationCurve:NSAnimationEaseInOut] autorelease];		
		
			// ...
		
			expandingViewStartFrameSize = [stackedView frame].size;
		
			expandingViewEndFrameSize = expandingViewStartFrameSize;
			expandingViewEndFrameSize.height = newHeight;
		
			[viewAnimation setExpandingView:stackedView];		
			[viewAnimation setExpandingViewEndFrameSize:expandingViewEndFrameSize];
		
			// ...
		
			collapsingViewStartFrameSize = [expandedView frame].size;
		
			collapsingViewEndFrameSize = collapsingViewStartFrameSize;
			collapsingViewEndFrameSize.height = [expandedView collapsedHeight];
		
			[viewAnimation setShrinkingView:expandedView];		
			[viewAnimation setShrinkingViewEndFrameSize:collapsingViewEndFrameSize];
		
			// ...
		
			[viewAnimation setDelegate:self];
			[viewAnimation startAnimation];
		}
		else
		{
			[stackedView setFrameHeight:newHeight];
		}
		
		[stackedView setCollapsed:NO];
		[stackedView setAutoresizingMask:(NSViewHeightSizable | NSViewWidthSizable)];
	
		[self setExpandedView:stackedView];
	
		// ...
	
		if ( firstResponderFlag )
		{
			firstResponder = [expandedView firstResponder];
		
			[[self window] makeFirstResponder:firstResponder];
		}
	
		// ...
	
		FKStackableView * aView = nil;
	
		unsigned i = 0;
	
		for ( ; i < [stackedViewsArray count]; i++ )
		{
			aView = [stackedViewsArray objectAtIndex:i];
		
			if ( aView != expandedView )
			{
				[self collapseStackedView:aView];
			}
		}
	}
}

- (void)collapseStackedView:(FKStackableView *)stackedView
{
	[stackedView setFrameHeight:[stackedView collapsedHeight]];
	[stackedView setAutoresizingMask:NSViewWidthSizable];
	[stackedView setCollapsed:YES];
}
	
#pragma mark -
#pragma mark LAYOUT & DRAWING

- (void)tile
{
	//NSLog (@" tile");
	
	FKStackableView * aView = nil;
		
	float yOrigin = interviewSpacing.height;
	
	
	// ...
	
	for ( aView in stackedViewsArray )
	{
			
		[aView setFrameY:yOrigin];
			
		yOrigin += NSHeight([aView frame]) + interviewSpacing.height;
	}
}

#pragma mark -
#pragma mark DELEGATE METHODS

- (unsigned)askDelegateForNumberOfStackedViews
{
	unsigned numberOfStackedViews = 0;
	
	if ( [delegate respondsToSelector:@selector(stackViewNumberOfStackedViews:)] )
	{
		numberOfStackedViews = [delegate stackViewNumberOfStackedViews:self];
	}
	
	return numberOfStackedViews;
}

- (FKStackableView *)askDelegateForStackedViewAtIndex:(int)anIndex
{
	NSView * stackedViewAtIndex = nil;
	
	if ( [delegate respondsToSelector:@selector(stackView:stackedViewAtIndex:)] )
	{
		stackedViewAtIndex = [delegate stackView:self stackedViewAtIndex:anIndex];
	}
	
	return stackedViewAtIndex;
}

@synthesize expandedView;
@synthesize collapsingView;
@synthesize needsReload;
@end
