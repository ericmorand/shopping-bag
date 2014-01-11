//
//  PaymentMethodsModule.h
//  ShoppingBag
//
//  Created by Eric on 26/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBModule.h"

@interface PaymentMethodsModule : SBModule
{
	IBOutlet NSView *		generalInformationsView;
}

@property (retain) NSView *		generalInformationsView;
@end
