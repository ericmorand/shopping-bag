//
//  FKSourceListGroup.h
//  ShoppingBag
//
//  Created by Eric on 15/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKSourceListItem.h"


@interface FKSourceListGroup : FKSourceListItem {
	NSMutableArray *		children;
}

@property (nonatomic, retain) NSMutableArray * children;

@end

@interface FKSourceListGroupNode : FKSourceListItemNode {	
}

@end;
