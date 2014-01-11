//
//  TaxRatesModule.h
//  ShoppingBag
//
//  Created by Eric on 10/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBModule.h"

@interface TaxRatesModule : SBModule
{
	IBOutlet NSView *		generalView;
}

@property (retain) NSView *		generalView;
@end
