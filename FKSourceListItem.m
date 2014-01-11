//
//  FKSourceListItem.m
//  ShoppingBag
//
//  Created by Eric on 15/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "FKSourceListItem.h"


@implementation FKSourceListItem

@synthesize name;
@synthesize icon;

- (NSTreeNode *)treeNodeRepresentation {
	return [FKSourceListItemNode treeNodeWithRepresentedObject:self];
}

@end

@implementation FKSourceListItemNode

- (NSString *)title {
	return [(FKSourceListItem *)[self representedObject] name];
}

- (NSImage *)icon {
	return [(FKSourceListItem *)[self representedObject] icon];
}

@end;
