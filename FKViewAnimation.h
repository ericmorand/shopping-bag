//
//  FKViewAnimation.h
//  FKKit
//
//  Created by Eric on 10/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FKStackableView;

@interface FKViewAnimation : NSAnimation
{
	FKStackableView *	expandingView;
	FKStackableView *	shrinkingView;
	
	NSSize				expandingViewStartFrameSize;
	NSSize				expandingViewEndFrameSize;
	NSSize				shrinkingViewStartFrameSize;
	NSSize				shrinkingViewEndFrameSize;
}

- (FKStackableView *)expandingView;
- (FKStackableView *)shrinkingView;

- (void)setExpandingView:(FKStackableView *)aView;
- (void)setShrinkingView:(FKStackableView *)aView;
- (void)setExpandingViewEndFrameSize:(NSSize)aSize;
- (void)setShrinkingViewEndFrameSize:(NSSize)aSize;

@end

@interface NSObject (FKStackViewAnimationDelegate)

- (void)fkViewAnimationDidProgress:(FKViewAnimation *)animation;

@end