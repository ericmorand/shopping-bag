//
//  FKBarcodeScannersManager.h
//  FKKit
//
//  Created by Eric on 05/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKBarcodeScannersManager : NSObject
{
	NSMutableArray *		availableScanners;
	
	// ...
	
	NSMutableDictionary *	refConDictionary;
}

+ (FKBarcodeScannersManager *)defaultManager;

- (NSMutableArray *)availableScanners;
- (void)setAvailableScanners:(NSMutableArray *)anArray;
- (void)setRefConDictionary:(NSMutableDictionary *)aDictionary;

- (void)startMonitoring;
- (void)stopMonitoring;

@end
