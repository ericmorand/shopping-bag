//
//  CustomersModule.h
//  ShoppingBag
//
//  Created by Eric on 19/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBModule.h"
#import "Customer.h"

@interface CustomersModule : SBModule
{
	IBOutlet NSView *				generalView;
	IBOutlet NSResponder *			generalViewFirstResponder;
	IBOutlet NSResponder *			generalViewLastResponder;
	
	IBOutlet NSView *				salesView;
	IBOutlet NSResponder *			salesViewFirstResponder;
	IBOutlet NSResponder *			salesViewLastResponder;
	
	NSArray *						salesControllerSortDescriptors;
}

@property (retain) NSView *			generalView;
@property (retain) NSResponder *	generalViewFirstResponder;
@property (retain) NSResponder *	generalViewLastResponder;
@property (retain) NSView *			salesView;
@property (retain) NSResponder *	salesViewFirstResponder;
@property (retain) NSResponder *	salesViewLastResponder;
@property (retain) NSArray *		salesControllerSortDescriptors;

@end
