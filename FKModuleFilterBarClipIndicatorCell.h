//
//  FKModulePlateToolbarClipIndicatorCell.h
//  Shopping Bag
//
//  Created by Eric on 11/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKModuleToolbarClipIndicatorCell.h"


@interface FKModuleFilterBarClipIndicatorCell : FKModuleToolbarClipIndicatorCell {
	NSButtonCell *	bezelCell;
}

@property (nonatomic, retain) NSButtonCell * bezelCell;

@end
