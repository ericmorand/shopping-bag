//
//  FKModuleGradientTextField.m
//  ShoppingBag
//
//  Created by Eric on 01/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleGradientTextField.h"
#import "FKModuleGradientTextFieldCell.h"


@implementation FKModuleGradientTextField

+ (Class)cellClass {return [FKModuleGradientTextFieldCell class];}

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if ( self )
	{
		[self setEditable:NO];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if ( self )
	{
		if ( ![[self cell] isKindOfClass:[FKModuleGradientTextFieldCell class]] )
		{
			NSArchiver * anArchiver = [[NSArchiver alloc] initForWritingWithMutableData:[NSMutableData dataWithCapacity:256]];
			[anArchiver encodeClassName:@"NSTextFieldCell" intoClassName:@"FKModuleGradientTextFieldCell"];
			[anArchiver encodeRootObject:[self cell]];
			[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
		}
	}
	
	return self;
}

@end
