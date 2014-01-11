//
//  FKBarcodeScanner.h
//  FKKit
//
//  Created by Eric on 05/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <IOKit/hid/IOHIDLib.h>


typedef struct HIDData
{	
	io_object_t					notification;
	IOHIDDeviceInterface122 ** 	hidDeviceInterface;
	CFRunLoopSourceRef			eventSource;
    UInt8                       buffer[8];
} HIDData;

typedef HIDData *				HIDDataRef;

@interface FKBarcodeScanner : NSObject
{	
	NSString *					productName;
	NSString *					manufacturerName;
	NSNumber *					productID;
	NSNumber *					vendorID;
	
	io_object_t					hidDevice;	
	HIDDataRef					hidDataRef;
	
	NSString *					lastScannedString;
	NSMutableString *			bufferString;
	
	BOOL						isScanning;
	BOOL						isEnabled;
}

- (NSString *)productName;
- (NSString *)manufacturerName;
- (NSNumber *)productID;
- (NSNumber *)vendorID;
- (io_object_t)hidDevice;
- (HIDDataRef)hidDataRef;
- (NSString *)lastScannedString;
- (NSMutableString *)bufferString;
- (BOOL)isScanning;
- (BOOL)isEnabled;

- (NSString *)barcodeScannerID;

- (void)setProductName:(NSString *)aString;
- (void)setManufacturerName:(NSString *)aString;
- (void)setProductID:(NSNumber *)aNumber;
- (void)setVendorID:(NSNumber *)aNumber;
- (void)setHidDevice:(io_object_t)aHidDevice;
- (void)setHidDataRef:(HIDDataRef)aHidDataRef;
- (void)setLastScannedString:(NSString *)aString;
- (void)setBufferString:(NSMutableString *)aString;
- (void)setIsScanning:(BOOL)aBool;
- (void)setIsEnabled:(BOOL)aBool;

@property (getter=hidDevice,setter=setHidDevice:) io_object_t					hidDevice;
@property (getter=hidDataRef,setter=setHidDataRef:) HIDDataRef					hidDataRef;
@property (getter=isScanning,setter=setIsScanning:) BOOL						isScanning;
@property (getter=isEnabled,setter=setIsEnabled:) BOOL						isEnabled;
@end
