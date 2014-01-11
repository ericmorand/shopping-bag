//
//  PaymentMethod.h
//  ShoppingBag
//
//  Created by Eric on 13/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface PaymentMethod : FKManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (readonly) NSImage * icon;

- (NSString *)uniqueName;

@end



