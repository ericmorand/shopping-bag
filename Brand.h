//
//  Brand.h
//  ShoppingBag
//
//  Created by Eric on 01/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Provider;

@interface Brand : FKManagedObject  
{
}

@property (readonly) NSImage * icon;

+ (Brand *)brandInContext:(NSManagedObjectContext *)aContext;

- (Provider *)favoriteProvider;
- (NSImage *)icon;
- (NSData *)iconData;
- (NSString *)name;

- (void)setFavoriteProvider:(Provider *)value;
- (void)setIcon:(NSImage *)value;
- (void)setIconData:(NSData *)value;
- (void)setName:(NSString *)value;

@end
