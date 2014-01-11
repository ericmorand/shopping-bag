//
//  SBSmartGroup.m
//  ShoppingBag
//
//  Created by Eric on 15/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "FKSourceListSmartGroup.h"


@implementation FKSourceListSmartGroup

@synthesize moduleName;
@synthesize predicate;

- (NSTreeNode *)treeNodeRepresentation {
	return [FKSourceListSmartGroupNode treeNodeWithRepresentedObject:self];
}

@end

@implementation FKSourceListSmartGroupNode

@end;