//
//  FKModulePlateToolbar.h
//  FKKit
//
//  Created by Eric on 15/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKModule.h"
#import "FKModuleToolbar.h"


@interface FKModuleFilterBar : FKModuleToolbar {
	NSMutableArray *		predicatesArray;
	NSPredicate *			predicate;	
}

@property (retain) NSMutableArray * predicatesArray;
@property (retain) NSPredicate * predicate;

@end

@interface NSObject (FKModuleFilterBarDelegate)

- (NSString *)filterBar:(FKModuleFilterBar *)aToolbar predicateFormatForItemIdentifier:(NSString *)anItemIdentifier;
- (NSString *)filterBar:(FKModuleFilterBar *)aToolbar predicateFormatForItemIdentifier:(NSString *)anItemIdentifier inAreaAtIndex:(NSInteger)areaIndex;
- (NSArray *)filterBar:(FKModuleFilterBar *)aToolbar predicateArgumentsForItemIdentifier:(NSString *)anItemIdentifier inAreaAtIndex:(NSInteger)areaIndex;

@end