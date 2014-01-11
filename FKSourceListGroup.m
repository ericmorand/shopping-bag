//
//  FKSourceListGroup.m
//  ShoppingBag
//
//  Created by Eric on 15/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "FKSourceListGroup.h"


@implementation FKSourceListGroup

@synthesize children;

- (id)init {
	self = [super init];
	
	if (nil != self) {
		self.children = [NSMutableArray array];
	}
	
	return self;
}

- (NSTreeNode *)treeNodeRepresentation {
	FKSourceListGroupNode * node = [FKSourceListGroupNode treeNodeWithRepresentedObject:self];
	
	// childNodes
	
	for (FKSourceListItem * item in children) {
		[[node mutableChildNodes] addObject:[item treeNodeRepresentation]];
	}
	
	return node;
}

@end

@implementation FKSourceListGroupNode

@end;