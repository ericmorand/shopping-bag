//
//  ProvidersModule.h
//  ShoppingBag
//
//  Created by Eric on 06/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBModule.h"

@class Provider;

@interface ProvidersModule : SBModule
{
	IBOutlet NSView *		generalView;
	
	IBOutlet NSView *		addressesView;
}

@property (retain) NSView *		generalView;
@property (retain) NSView *		addressesView;
@end
