//
//  SBSaleView.h
//  ShoppingBag
//
//  Created by Eric on 24/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SalesModule.h"

@interface SaleView : FKView
{
	IBOutlet SalesModule *			salesModule;
}

@property (retain) SalesModule *	salesModule;
@end
