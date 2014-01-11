//
//  FKImageAndTextField.m
//  FKKit
//
//  Created by Eric Morand on 27/02/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import "FKImageAndTextField.h"
//#import "FKTextFieldCell.h"

@implementation FKImageAndTextField

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	/*if ( ![[self cell] isKindOfClass:[FKTextFieldCell class]] )
	{
		NSArchiver * anArchiver = [[NSArchiver alloc] initForWritingWithMutableData:[NSMutableData dataWithCapacity:256]];
		[anArchiver encodeClassName:@"NSTextFieldCell" intoClassName:@"FKTextFieldCell"];
		[anArchiver encodeRootObject:[self cell]];
		[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
		
		[[self cell] setLeftMargin:0];
	}*/
	
	return self;
}

@end
