//
//  SBMOCHelper+Brand.h
//  ShoppingBag
//
//  Created by Eric on 10/03/10.
//  Copyright 2010 Alt Informatique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBMOCHelper.h"
#import "Brand.h"

@interface SBMOCHelper (Brand)

- (Brand *)fetchBrandWithName:(NSString *)inName inManagedObjectContext:(NSManagedObjectContext *)inMoc;

@end
