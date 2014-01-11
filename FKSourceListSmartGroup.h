//
//  SBSmartGroup.h
//  ShoppingBag
//
//  Created by Eric on 15/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKSourceListItem.h"


@interface FKSourceListSmartGroup : FKSourceListItem {
	NSString *		moduleName;
	NSPredicate *	predicate;
}

@property (nonatomic, retain) NSString * moduleName;
@property (nonatomic, retain) NSPredicate * predicate;

@end

@interface FKSourceListSmartGroupNode : FKSourceListItemNode {	
}

@end;
