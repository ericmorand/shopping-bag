//
//  SBMOCHelper+ProductFamily.h
//  ShoppingBag
//
//  Created by Eric on 10/03/10.
//  Copyright 2010 Alt Informatique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBMOCHelper.h"
#import "ProductFamily.h"

@interface SBMOCHelper (ProductFamily)

- (ProductFamily *)fetchProductFamilyWithName:(NSString *)inName inManagedObjectContext:(NSManagedObjectContext *)inMoc;

@end
