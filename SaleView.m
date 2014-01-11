//
//  SBSaleView.m
//  ShoppingBag
//
//  Created by Eric on 24/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "SaleView.h"
#import "Customer.h"
#import "Product.h"
#import "Sale.h"

@implementation SaleView

@synthesize salesModule;

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
    
	if (nil != self) {
		[self registerForDraggedTypes:[NSArray arrayWithObjects:ProductPBoardDataType, CustomerPBoardDataType, nil]];
    }
	
    return self;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	Sale * currentSale = (Sale *)[salesModule currentObject];
	
	// ...
	
	if ( nil == [currentSale paymentMethod] )
	{
		[self setHighlighted:YES];
	
		return NSDragOperationCopy;
	}
	
	return NSDragOperationNone;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
	[self setHighlighted:NO];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	BOOL success = NO;
	
	NSPasteboard * pboard = [sender draggingPasteboard];
	
	NSData * productsData = nil;
	NSData * customersData = nil;
	
	NSArray * objectURIs = nil;
	
	// Products
    
	productsData = [pboard dataForType:ProductPBoardDataType];
	
	if ( nil != productsData )
	{
		objectURIs = [NSKeyedUnarchiver unarchiveObjectWithData:productsData];
		
		[salesModule addProductsWithURIs:objectURIs];
		
		success = YES;
	}
	
	// Customers
	
	customersData = [pboard dataForType:CustomerPBoardDataType];
 
	if ( nil != customersData )
	{
		objectURIs = [NSKeyedUnarchiver unarchiveObjectWithData:customersData];
		
		if ( [objectURIs count] > 0 )
		{
			[salesModule setCustomerWithURI:[objectURIs objectAtIndex:0]];
		}
		
		success = YES;
	}
		
	[self setHighlighted:NO];
	
	return success;
}

- (void)keyDown:(NSEvent *)theEvent {
	if ([theEvent keyCode] == 51) {
		[salesModule deleteKeyDown:[[self window] firstResponder]];
	}
	
	[super keyDown:theEvent];
}

@end
