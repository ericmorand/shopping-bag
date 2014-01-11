//
//  SBModule.m
//  ShoppingBag
//
//  Created by Eric on 19/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "SBModule.h"


@implementation SBModule

- (id)initWithContext:(NSManagedObjectContext *)aContext userInfo:(NSDictionary *)aDictionary {
	self = [super initWithContext:aContext userInfo:aDictionary];
	
	if (nil != self) {
	}
	
	return self;
}

#pragma mark -
#pragma mark LAYOUT

- (void)finalizeSetupModuleViewUsingMiniStyle {
	[super finalizeSetupModuleViewUsingMiniStyle];
	
	[multipleObjectsLeftTableView setRowHeight:17.0];
}

@end
