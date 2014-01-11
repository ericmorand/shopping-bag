//
//  FKSourceListItem.h
//  ShoppingBag
//
//  Created by Eric on 15/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKSourceListItem : NSObject {
	NSString *		name;
	NSImage *		icon;
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, copy) NSImage * icon;

- (NSTreeNode *)treeNodeRepresentation;

@end

@interface FKSourceListItemNode : NSTreeNode {
}

@property (readonly) NSString * title;
@property (readonly) NSImage * icon;

@end;
