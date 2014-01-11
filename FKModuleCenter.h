//
//  FKModuleCenter.h
//  FKKit
//
//  Created by Eric on 16/10/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKModuleCenter : NSObject
{
	NSMutableArray *					modulesArray;
	FKModule *							currentModule;
	FKModule *							nextModule;
}

- (void)setModulesArray:(NSMutableArray *)anArray;
- (void)setCurrentModule:(FKModule *)newModule;
- (void)setNextModule:(FKModule *)newModule;

@end

@interface NSObject (FKModuleCenterDelegate)

- (NSArray *)moduleNames;

@end