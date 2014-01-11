//
//  BrandsModule.h
//  ShoppingBag
//
//  Created by Eric on 23/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBModule.h"

@interface BrandsModule : SBModule
{
	IBOutlet NSView *		generalInformationsView;
}

@property (retain) NSView *		generalInformationsView;
@end
