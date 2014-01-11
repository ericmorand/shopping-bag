//
//  FKVerticallyCenteredPercentTextFieldCell.m
//  FKKit
//
//  Created by Eric on 18/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKVerticallyCenteredPercentTextFieldCell.h"


@implementation FKVerticallyCenteredPercentTextFieldCell

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if ( self )
	{
		isVerticallyCentered = YES;
	}
	
	return self;
}

@end
