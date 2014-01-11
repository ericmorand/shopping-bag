//
//  SBCustomerView.h
//  ShoppingBag
//
//  Created by Eric on 20/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Customer.h"

@interface CustomerView : NSView
{
	Customer *						customer; // Bound
	
	NSTrackingRectTag				trackingRectTag;
	BOOL							mouseOver;
	
	IBOutlet NSArrayController *	salesArrayController;
	
	IBOutlet NSButton *				editButton;
	IBOutlet NSButton *				deleteButton;
}

- (BOOL)mouseOver;

- (void)setCustomer:(Customer *)aCustomer;
- (void)setMouseOver:(BOOL)flag;

- (void)resetTrackingRect;
- (void)removeTrackingRect;

@property (assign,setter=setCustomer:) Customer *						customer;
@property NSTrackingRectTag				trackingRectTag;
@property (getter=mouseOver,setter=setMouseOver:) BOOL							mouseOver;
@property (retain) NSArrayController *	salesArrayController;
@property (retain) NSButton *				editButton;
@property (retain) NSButton *				deleteButton;
@end
