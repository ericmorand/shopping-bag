//
//  FKTextField.m
//  FKKit
//
//  Created by Eric on 15/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKTextField.h"
#import "FKTextFieldCell.h"

@implementation FKTextField

+ (Class)cellClass {return [FKTextFieldCell class];}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if ( self )
	{
		Class cellClass = [[self class] cellClass];
		
		NSTextFieldCell * oldCell = [self cell];
		NSTextFieldCell * newCell = [[[cellClass alloc] initTextCell:@""] autorelease];
		
		[newCell setFont:[oldCell font]];
		[newCell setEditable:[oldCell isEditable]];
		[newCell setBezeled:[oldCell isBezeled]];
		[newCell setBezelStyle:[oldCell bezelStyle]];
		[newCell setLineBreakMode:[oldCell lineBreakMode]];
		[newCell setAlignment:[oldCell alignment]];
		
		[self setCell:newCell];
	}
	
	return self;
}

@end
