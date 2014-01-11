//
//  FKManagedPlatePopUpButton.m
//  FKKit
//
//  Created by Eric on 22/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKManagedPlatePopUpButton.h"

@interface FKManagedPlatePopUpButton (Private)

- (void)commonInit;

@end

@implementation FKManagedPlatePopUpButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
	
    if ( self )
	{
		[self commonInit];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if ( self )
	{
		[self commonInit];
	}
	
	return self;
}

- (void)commonInit
{
	[self setRightAnglesMask:(FKTopRightAngle | FKBottomRightAngle)];
	[self setStrokedBordersMask:FKEveryCorner];
}

@end
