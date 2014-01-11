//
//  FKSquareComboBox.m
//  FKKit
//
//  Created by Eric on 24/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKSquareComboBox.h"


@implementation FKSquareComboBox

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if ( self )
	{		
		[self setRightAnglesMask:FKEveryBorder];
		[self setStrokedBordersMask:(FKEveryBorder - FKLeftBorder)];
	}
	
	return self;
}

@end
