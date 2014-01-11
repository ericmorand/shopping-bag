//
//  FKAlert.m
//  FKKit
//
//  Created by Eric on 27/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKAlert.h"

@implementation FKAlert

#pragma mark -
#pragma mark GETTERS

//- (NSPanel *)panel {return panel;}

#pragma mark -
#pragma mark SETTERS

- (void)setAccessoryView:(NSView *)aView
{
	if ( aView != accessoryView )
	{
		[accessoryView release];
		accessoryView = [aView retain];
	}
}

- (void)setDontWarnMessage:(NSString *)aString
{
	if ( aString != dontWarnMessage )
	{
		[dontWarnMessage release];
		dontWarnMessage = [aString retain];
	}
}

- (void)addDontWarnCheckbox
{
	
}

- (void)addAccessoryView
{
    float checkboxPadding = 14.0f; // according to the apple HIG
    
    NSWindow * window = [self panel];
    NSView * content = [window contentView];
    
    // Find the position of the lower (small-fonted) text field
	
    NSArray *subviews = [content subviews];
    NSView *subview = nil;
    NSTextField *messageText = nil;
	NSImageView * imageView = nil;
    int count = 0;
    
	NSRect windowFrame = [window frame];
	NSRect checkboxFrame = [accessoryView frame];	
	
	//windowFrame.size.height += NSHeight(checkboxFrame);
	
	[window setFrame:windowFrame display:YES];		
	
    for ( subview in subviews )
	{
        if ( [subview isKindOfClass:[NSTextField class]] )
		{
            count++;
            
            if ( count == 2 )
			{
                messageText = (NSTextField *)subview;
            }
        }
		else if ( [subview isKindOfClass:[NSImageView class]] )
		{
			imageView = (NSImageView *)subview;
		}
    }
	
	float maxOriginY = NSMinY([messageText frame]);
	
	
	checkboxFrame.origin.x = NSMinX([messageText frame]); //[messageText frame].origin.x;	
	checkboxFrame.origin.y = maxOriginY - NSHeight(checkboxFrame);

	NSLog(@"maxOriginY = %f", maxOriginY);
	
	[accessoryView setFrame:checkboxFrame];	
	
    [content addSubview:accessoryView] ;
}

- (id)buildAlertStyle:(int)fp8 title:(id)fp12 formattedMsg:(id)fp16 first:(id)fp20 second:(id)fp24 third:(id)fp28 oldStyle:(BOOL)fp32
{
	id retVal = [super buildAlertStyle:fp8 title:fp12 formattedMsg:fp16 first:fp20 second:fp24 third:fp28 oldStyle:fp32];

	[self addAccessoryView];
	
	return retVal;
}

- (id)buildAlertStyle:(int)fp8 title:(id)fp12 message:(id)fp16 first:(id)fp20 second:(id)fp24 third:(id)fp28 oldStyle:(BOOL)fp32 args:(char *)fp36
{
	id retVal = [super buildAlertStyle:fp8 title:fp12 message:fp16 first:fp20 second:fp24 third:fp28 oldStyle:fp32 args:fp36];
	
	[self addAccessoryView];
	
	return retVal;
}

@end
