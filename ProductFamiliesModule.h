//
//  ProductFamiliesModule.h
//  ShoppingBag
//
//  Created by Eric on 14/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBModule.h"

@interface ProductFamiliesModule : SBModule
{
	IBOutlet NSView *		generalView;
}

@property (retain) NSView *		generalView;
@end
