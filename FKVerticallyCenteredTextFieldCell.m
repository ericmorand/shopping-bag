//
//  FKVerticallyCenteredTextFieldCell.m
//  FKKit
//
//  Created by Eric on 15/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKVerticallyCenteredTextFieldCell.h"


@implementation FKVerticallyCenteredTextFieldCell

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
