//
//  FKVerticallyCenteredDecimalTextFieldCell.m
//  FKKit
//
//  Created by Eric on 18/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKVerticallyCenteredDecimalTextFieldCell.h"


@implementation FKVerticallyCenteredDecimalTextFieldCell

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
