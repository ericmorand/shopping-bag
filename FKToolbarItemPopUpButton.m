//
//  FKToolbarItemPopUpButton.m
//  FKKit
//
//  Created by Eric on 15/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKToolbarItemPopUpButton.h"


@implementation FKToolbarItemPopUpButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
	
    if ( self )
	{
		[self setFont:[NSFont boldSystemFontOfSize:[NSFont smallSystemFontSize]]];
		[self setTitleForegroundColor:[NSColor colorWithDeviceRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0]];
	}
	
    return self;
}

@end
