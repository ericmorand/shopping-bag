//
//  FKTextFieldCell.h
//  FKKit
//
//  Created by Eric on 15/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKTextFieldCell : NSTextFieldCell
{
	BOOL		isVerticallyCentered;
	BOOL		isEditingOrSelecting;
}

+ (Class)formatterClass;

@property BOOL		isVerticallyCentered;
@property BOOL		isEditingOrSelecting;
@end
