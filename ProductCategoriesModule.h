//
//  ProductCategoriesManager.h
//  ShoppingBag
//
//  Created by Eric on 07/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBModule.h"

@class ProductCategory;

@interface ProductCategoriesModule : SBModule
{
	IBOutlet NSView *		generalInformationsView;
}

@property (retain) NSView *		generalInformationsView;
@end
