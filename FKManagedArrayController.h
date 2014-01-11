//
//  FKArrayController.h
//  FKKit
//
//  Created by Eric on 18/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKManagedObject.h"

@interface FKManagedArrayController : NSArrayController {
	id selectedObject;
}

@property (nonatomic, retain) id selectedObject;

@end
