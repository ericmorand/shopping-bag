//
//  FKVerticallyCenteredCurrencyTextFieldCell.m
//  FKKit
//
//  Created by Eric on 27/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKVerticallyCenteredCurrencyTextFieldCell.h"


@implementation FKVerticallyCenteredCurrencyTextFieldCell

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
