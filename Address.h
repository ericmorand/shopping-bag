//
//  Address.h
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Address : FKManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * line1;
@property (nonatomic, retain) NSString * line2;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;

@property (readonly) NSString * zipCodeCity;
@property (readonly) NSString * shortDescription;

@end
