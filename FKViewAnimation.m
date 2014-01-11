//
//  FKViewAnimation.m
//  FKKit
//
//  Created by Eric on 10/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKViewAnimation.h"


@implementation FKViewAnimation

- (void)dealloc
{
	[self setExpandingView:nil];
	[self setShrinkingView:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (FKStackableView *)expandingView {return expandingView;}
- (FKStackableView *)shrinkingView {return shrinkingView;}

#pragma mark -
#pragma mark SETTERS

- (void)setExpandingView:(FKStackableView *)aView
{
	if ( aView != expandingView )
	{
		[expandingView release];
		expandingView = [aView retain];
		
		expandingViewStartFrameSize = [expandingView frame].size;
	}
}

- (void)setShrinkingView:(FKStackableView *)aView
{
	if ( aView != shrinkingView )
	{
		[shrinkingView release];
		shrinkingView = [aView retain];
		
		shrinkingViewStartFrameSize = [shrinkingView frame].size;
	}
}

- (void)setExpandingViewEndFrameSize:(NSSize)aSize {expandingViewEndFrameSize = aSize;}
- (void)setShrinkingViewEndFrameSize:(NSSize)aSize {shrinkingViewEndFrameSize = aSize;}

- (void)setCurrentProgress:(NSAnimationProgress)progress
{
    [super setCurrentProgress:progress];
	
	float currentValue = [self currentValue];
	
	float expandingViewDeltaHeight = expandingViewEndFrameSize.height - expandingViewStartFrameSize.height;
	float shrinkingViewDeltaHeight = shrinkingViewEndFrameSize.height - shrinkingViewStartFrameSize.height;
	
	float newExpandingViewHeight = expandingViewStartFrameSize.height;
	float newCollaspingViewHeight = shrinkingViewStartFrameSize.height;
	
	newExpandingViewHeight += floor(currentValue * expandingViewDeltaHeight);
	newCollaspingViewHeight += ceil(currentValue * shrinkingViewDeltaHeight);
	
	[expandingView setFrameHeight:newExpandingViewHeight];
	[shrinkingView setFrameHeight:newCollaspingViewHeight];
	
	// ...
	
	id delegate = [self delegate];
	
	if ( [delegate respondsToSelector:@selector(fkViewAnimationDidProgress:)] )
	{
		[delegate fkViewAnimationDidProgress:self];
	}
}

@end
