//
//  FKBarcodeScanner.m
//  FKKit
//
//  Created by Eric on 05/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKBarcodeScanner.h"


@implementation FKBarcodeScanner

- (void)dealloc
{
	[self setProductName:nil];
	[self setManufacturerName:nil];
	[self setProductID:nil];
	[self setVendorID:nil];
	
	IOObjectRelease(hidDevice);
	free(hidDataRef);
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (NSString *)productName {return productName;}
- (NSString *)manufacturerName {return manufacturerName;}
- (NSNumber *)productID {return productID;}
- (NSNumber *)vendorID {return vendorID;}
- (io_object_t)hidDevice {return hidDevice;}
- (HIDDataRef)hidDataRef {return hidDataRef;}
- (NSString *)lastScannedString {return lastScannedString;}
- (NSMutableString *)bufferString {return bufferString;}
- (BOOL)isScanning {return isScanning;}
- (BOOL)isEnabled {return isEnabled;}

- (NSString *)barcodeScannerID
{
	NSString * barcodeScannerID = nil;
	
	barcodeScannerID = [NSString stringWithFormat:@"%@/%@", [vendorID stringValue], [productID stringValue]];
	
	return barcodeScannerID;
}

#pragma mark -
#pragma mark SETTERS

- (void)setProductName:(NSString *)aString
{
	if ( aString != productName )
	{
		[productName release];
		productName = [aString retain];
	}
}

- (void)setManufacturerName:(NSString *)aString
{
	if ( aString != manufacturerName )
	{
		[manufacturerName release];
		manufacturerName = [aString retain];
	}
}

- (void)setProductID:(NSNumber *)aNumber
{
	if ( aNumber != productID)
	{
		[productID release];
		productID = [aNumber retain];
	}
}

- (void)setVendorID:(NSNumber *)aNumber
{
	if ( aNumber != vendorID )
	{
		[vendorID release];
		vendorID = [aNumber retain];
	}
}

- (void)setHidDevice:(io_object_t)aHidDevice {hidDevice = aHidDevice;}
- (void)setHidDataRef:(HIDDataRef)aHidDataRef {hidDataRef = aHidDataRef;}

- (void)setLastScannedString:(NSString *)aString
{
	if ( aString != lastScannedString )
	{
		[lastScannedString release];
		lastScannedString = [aString retain];
	}
}

- (void)setBufferString:(NSMutableString *)aString
{
	if ( aString != bufferString )
	{
		[bufferString release];
		bufferString = [aString retain];
	}
}

- (void)setIsScanning:(BOOL)aBool {isScanning = aBool;}
- (void)setIsEnabled:(BOOL)aBool {isEnabled = aBool;}

@end
