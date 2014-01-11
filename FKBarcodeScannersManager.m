//
//  FKBarcodeScannersManager.m
//  FKKit
//
//  Created by Eric on 05/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKBarcodeScannersManager.h"

#import <IOKit/IOMessage.h>
#import <IOKit/IOCFPlugIn.h>

NSString * FKBarcodeScannersManagerSelfKey = @"FKBarcodeScannersManagerSelfKey";
NSString * FKBarcodeScannersManagerHidDataRefKey = @"FKBarcodeScannersManagerHidDataRefKey";
NSString * FKBarcodeScannersManagerBarcodeScannerKey = @"FKBarcodeScannersManagerBarcodeScannerKey";
NSString * FKBarcodeScannerAddedNotification = @"FKBarcodeScannerAddedNotification";
NSString * FKBarcodeScannerRemovedNotification = @"FKBarcodeScannerRemovedNotification";
NSString * FKBarcodeScannerDidBeginScanningNotification = @"FKBarcodeScannerDidBeginScanningNotification";
NSString * FKBarcodeScannerDidEndScanningNotification = @"FKBarcodeScannerDidEndScanningNotification";
NSString * MonitoredBarcodeScannersKey = @"FKBarcodeScannersManager.MonitoredBarcodeScanners";
NSString * ProductIDKey = @"ProductID";
NSString * VendorIDKey = @"VendorID";

@interface FKBarcodeScannersManager (Private)

- (void)startMonitoringBarcodeScanner:(FKBarcodeScanner *)aBarcodeScanner;
- (void)stopMonitoringBarcodeScanner:(FKBarcodeScanner *)aBarcodeScanner;

@end

@implementation FKBarcodeScannersManager

static FKBarcodeScannersManager * defaultManager = nil;

static io_iterator_t			gAddedIter = 0;
static IONotificationPortRef	gNotifyPort = NULL;

static void DeviceAdded(void * refCon, io_iterator_t iterator);
static void DeviceNotification(void * refCon, io_service_t service, natural_t messageType, void * messageArgument);
static void InterruptReportCallbackFunction(void * target, IOReturn result, void * refcon, void * sender, UInt32 bufferSize);

+ (FKBarcodeScannersManager *)defaultManager
{
	if ( nil == defaultManager )
	{
		defaultManager = [[FKBarcodeScannersManager alloc] init];
	}
	
	return defaultManager;
}

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setAvailableScanners:[NSMutableArray array]];
		[self setRefConDictionary:[NSMutableDictionary dictionaryWithObject:self forKey:FKBarcodeScannersManagerSelfKey]];
	}
	
	return self;
}

- (void)dealloc
{
	[self setAvailableScanners:nil];
	[self setRefConDictionary:nil];

	[defaultManager release];
	defaultManager = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (NSMutableArray *)availableScanners {return availableScanners;}

#pragma mark -
#pragma mark SETTERS

- (void)setAvailableScanners:(NSMutableArray *)anArray
{
	if ( anArray != availableScanners )
	{
		[availableScanners release];
		availableScanners = [anArray retain];
	}
}

- (void)setRefConDictionary:(NSMutableDictionary *)aDictionary
{
	if ( aDictionary != refConDictionary )
	{
		[refConDictionary release];
		refConDictionary = [aDictionary retain];
	}	
}

#pragma mark -
#pragma mark SCANNERS MANAGEMENT

- (void)addBarcodeScanner:(FKBarcodeScanner *)barcodeScanner
{
	[self willChangeValueForKey:@"availableScanners"];
	
	[availableScanners addObject:barcodeScanner];
	
	[barcodeScanner addObserver:self forKeyPath:@"isEnabled" options:nil context:nil];
	
	// Si le scanner est present dans les preferences de l'application
	// en tant que scanner a surveiller, on l'active immediatement
	
	NSMutableArray * monitoredScanners = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MonitoredBarcodeScannersKey]];
	NSString * barcodeScannerID = [barcodeScanner barcodeScannerID];
	
	if ( [monitoredScanners containsObject:barcodeScannerID] )
	{
		[barcodeScanner setIsEnabled:YES];
	}
	
	// ...
	
	[self didChangeValueForKey:@"availableScanners"];	
}

- (void)removeBarcodeScanner:(FKBarcodeScanner *)aScanner
{
	[self willChangeValueForKey:@"availableScanners"];
	
	[availableScanners removeObject:aScanner];
	
	[aScanner setIsEnabled:NO];
	[aScanner removeObserver:self forKeyPath:@"isEnabled"];	
		
	[self didChangeValueForKey:@"availableScanners"];	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( [keyPath isEqualToString:@"isEnabled"] )
	{		
		FKBarcodeScanner * aScanner = (FKBarcodeScanner *)object;
		
		if ( [aScanner isEnabled] )
		{
			[self startMonitoringBarcodeScanner:aScanner];
		}
		else
		{
			[self stopMonitoringBarcodeScanner:aScanner];
		}
	}
}

- (void)startMonitoring
{
	NSMutableDictionary * matchingDict = nil;
	
	mach_port_t masterPort;
	kern_return_t kernReturn;
	
	// First create a master_port for my task
	
	kernReturn = IOMasterPort(MACH_PORT_NULL, &masterPort);
	
	if ( kernReturn || !masterPort )
	{
		return;
	}
	
	// Create a notification port and add its run loop event source to our run loop
	// This is how async notifications get set up
	
	gNotifyPort = IONotificationPortCreate(masterPort);
	
	CFRunLoopAddSource(CFRunLoopGetCurrent(), IONotificationPortGetRunLoopSource(gNotifyPort), kCFRunLoopDefaultMode);
	
	// Create the IOKit notifications that we need
	
	matchingDict = (NSMutableDictionary *)IOServiceMatching(kIOHIDDeviceKey); 
	
	// ...
	
	kernReturn = IOServiceAddMatchingNotification(gNotifyPort,							// notifyPort
												  kIOFirstPublishNotification,			// notificationType
												  (CFMutableDictionaryRef)matchingDict,	// matching
												  DeviceAdded,							// callback
												  refConDictionary,						// refCon
												  &gAddedIter							// notification
												  );
	
    // Iterate once to get already-present devices and arm the notification    
	
	DeviceAdded(refConDictionary, gAddedIter);
}

- (void)stopMonitoring
{
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), IONotificationPortGetRunLoopSource(gNotifyPort), kCFRunLoopDefaultMode);
}

- (void)startMonitoringBarcodeScanner:(FKBarcodeScanner *)aBarcodeScanner
{	
	NSLog (@"startMonitoringBarcodeScanner : %@", aBarcodeScanner);
	
    IOHIDDeviceInterface122 **	hidDeviceInterface 	= NULL;
    IOCFPlugInInterface ** plugInInterface = NULL;
	HIDDataRef hidDataRef = NULL;
    HRESULT result = S_FALSE;
	
	io_object_t hidDevice = 0;
	IOReturn kernReturn = 0;	
    SInt32 score = 0;	

	hidDataRef = [aBarcodeScanner hidDataRef];
	hidDevice = [aBarcodeScanner hidDevice];
	
	// Create the CF plugin for this device
	
	kernReturn = IOCreatePlugInInterfaceForService(hidDevice, kIOHIDDeviceUserClientTypeID, kIOCFPlugInInterfaceID, &plugInInterface, &score);
	result = (*plugInInterface)->QueryInterface(plugInInterface, CFUUIDGetUUIDBytes(kIOHIDDeviceInterfaceID122), (LPVOID)&hidDeviceInterface);
	
	// Got the interface
	
	if ( ( result == S_OK ) && hidDeviceInterface )
	{
		hidDataRef = malloc(sizeof(HIDData));
		bzero(hidDataRef, sizeof(HIDData));
		
		[aBarcodeScanner setHidDataRef:hidDataRef];
		
		hidDataRef->hidDeviceInterface = hidDeviceInterface;
		
		result = (*hidDeviceInterface)->open(hidDeviceInterface, kIOHIDOptionsTypeSeizeDevice);
		
		// ...
		
		[refConDictionary setValue:aBarcodeScanner forKey:FKBarcodeScannersManagerBarcodeScannerKey];
		
		// ... 
		
		result = (*hidDeviceInterface)->createAsyncEventSource(hidDeviceInterface, &hidDataRef->eventSource);
		result = (*hidDeviceInterface)->setInterruptReportHandlerCallback(hidDeviceInterface, &hidDataRef->buffer, sizeof(hidDataRef->buffer), InterruptReportCallbackFunction, NULL, refConDictionary);
				
		CFRunLoopAddSource(CFRunLoopGetCurrent(), hidDataRef->eventSource, kCFRunLoopDefaultMode);
		
		// ...
		
		IOServiceAddInterestNotification(gNotifyPort, hidDevice, kIOGeneralInterest, DeviceNotification, refConDictionary, &(hidDataRef->notification));	
		
		// ...
		
		(*plugInInterface)->Release(plugInInterface);
		
		// Enfin, on ajoute le lecteur de code-barre a la liste des lecteurs
		// surveilles dans les preferences de l'application s'il ne s'y trouve pas deja
				
		NSMutableArray * monitoredScanners = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MonitoredBarcodeScannersKey]];
		NSString * barcodeScannerID = [aBarcodeScanner barcodeScannerID];
		
		if ( ![monitoredScanners containsObject:barcodeScannerID] )
		{
			if ( nil == monitoredScanners )
			{
				monitoredScanners = [NSMutableArray array];
			}
		
			[monitoredScanners addObject:barcodeScannerID];
		
			[[NSUserDefaults standardUserDefaults] setObject:monitoredScanners forKey:MonitoredBarcodeScannersKey];
		}
	}
}

- (void)stopMonitoringBarcodeScanner:(FKBarcodeScanner *)aBarcodeScanner
{
	HIDDataRef hidDataRef = [aBarcodeScanner hidDataRef];
	
	CFRunLoopSourceInvalidate(hidDataRef->eventSource);
	
	(*hidDataRef->hidDeviceInterface)->Release(hidDataRef->hidDeviceInterface);
	hidDataRef->hidDeviceInterface = NULL;
	
	// Enfin, on supprime le lecteur de code-barre de la liste des lecteurs
	// surveilles dans les preferences de l'application, s'il s'y trouve
	
	NSMutableArray * monitoredScanners = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MonitoredBarcodeScannersKey]];
	NSString * barcodeScannerID = [aBarcodeScanner barcodeScannerID];
	
	if ( [monitoredScanners containsObject:barcodeScannerID] )
	{
		[monitoredScanners removeObject:barcodeScannerID];
		
		[[NSUserDefaults standardUserDefaults] setObject:monitoredScanners forKey:MonitoredBarcodeScannersKey];		
	}
}

#pragma mark -
#pragma mark IOKIT

void DeviceAdded(void * refCon, io_iterator_t iterator)
{
	NSLog (@"DeviceAdded");
	
	NSDictionary * refConDictionary = (NSDictionary *)refCon;
	
	id self = [refConDictionary valueForKey:FKBarcodeScannersManagerSelfKey];
	
	NSMutableDictionary * deviceProperties = nil;
	FKBarcodeScanner * aBarcodeScanner = nil;
	NSString * productName = nil;

	io_object_t hidDevice = 0;
	
    while ( hidDevice = IOIteratorNext(iterator) )
    {
		IORegistryEntryCreateCFProperties(hidDevice, (CFMutableDictionaryRef *)&deviceProperties, kCFAllocatorDefault, kNilOptions);
		
		productName = [deviceProperties valueForKey:@"Product"];
		
		if ( [productName rangeOfString:@"Scanner"].location != NSNotFound )
		{
			aBarcodeScanner = [[FKBarcodeScanner alloc] init];
		
			[aBarcodeScanner setProductName:productName];
			[aBarcodeScanner setManufacturerName:[deviceProperties valueForKey:@"Manufacturer"]];
			[aBarcodeScanner setProductID:[deviceProperties valueForKey:@"ProductID"]];
			[aBarcodeScanner setVendorID:[deviceProperties valueForKey:@"VendorID"]];			
			[aBarcodeScanner setHidDevice:hidDevice];
			
			[self addBarcodeScanner:aBarcodeScanner];
		}
    }
}

void DeviceNotification(void * refCon, io_service_t service, natural_t messageType, void * messageArgument)
{
	NSDictionary * refConDictionary = (NSDictionary *)refCon;
	id self = [refConDictionary valueForKey:FKBarcodeScannersManagerSelfKey];
    FKBarcodeScanner * barcodeScanner = [refConDictionary valueForKey:FKBarcodeScannersManagerBarcodeScannerKey];
	HIDDataRef hidDataRef = [barcodeScanner hidDataRef];
	
    if ( messageType == kIOMessageServiceIsTerminated )
	{		
		NSLog (@" DeviceRemoved");
		
		CFRunLoopRemoveSource(CFRunLoopGetCurrent(), hidDataRef->eventSource, kCFRunLoopDefaultMode);
		
		[self removeBarcodeScanner:barcodeScanner];
	}
}

void InterruptReportCallbackFunction (void * target, IOReturn result, void * refCon, void * sender, UInt32 bufferSize)
{	
	NSDictionary * refConDictionary = (NSDictionary *)refCon;
	
	FKBarcodeScanner * barcodeScanner = [refConDictionary valueForKey:FKBarcodeScannersManagerBarcodeScannerKey];
	NSMutableString * bufferString = [barcodeScanner bufferString];
	HIDDataRef hidDataRef = [barcodeScanner hidDataRef];;
	
	int i = 0;
    
    if ( !hidDataRef )
	{
		return;
	}
		
	NSString * bufferAsString = [NSString string];
	NSString * bufferSubstring = nil;	
	
	for ( ; i < bufferSize; i++ )
	{
		bufferAsString = [bufferAsString stringByAppendingFormat:@"%2.2x", hidDataRef->buffer[i]];
	}
	
	bufferSubstring = [bufferAsString substringWithRange:NSMakeRange(0, 2)];
	
	if ( ![barcodeScanner isScanning] && [bufferSubstring isEqualToString:@"02"] )
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:FKBarcodeScannerDidBeginScanningNotification
															object:barcodeScanner
														  userInfo:nil];		
		bufferString = [NSMutableString string];
		
		NSLog (@"bufferString = %@", NSStringFromClass([bufferString class]));
		
		[barcodeScanner setBufferString:bufferString];
		[barcodeScanner setIsScanning:YES];
	}
	else if ( [barcodeScanner isScanning] && [bufferAsString isEqualToString:@"0000280000000000"] ) // Retour chariot
	{		
		// ...
		
		[barcodeScanner setLastScannedString:[barcodeScanner bufferString]];
				
		[barcodeScanner setIsScanning:NO];
		
		// ...	
		
		[NSApp activateIgnoringOtherApps:YES];
				
		[[NSNotificationCenter defaultCenter] postNotificationName:FKBarcodeScannerDidEndScanningNotification
															object:barcodeScanner
														  userInfo:nil];
	}
		
	if ( [barcodeScanner isScanning] && ![bufferAsString isEqualToString:@"0000000000000000"] )
	{		
		if ( [bufferAsString isEqualToString:@"02001e0000000000"] )
		{
			[bufferString appendString:@"1"];
		}
		else if ( [bufferAsString isEqualToString:@"02001f0000000000"] )
		{
			[bufferString appendString:@"2"];
		}
		else if ( [bufferAsString isEqualToString:@"0200200000000000"] )
		{
			[bufferString appendString:@"3"];
		}
		else if ( [bufferAsString isEqualToString:@"0200210000000000"] )
		{
			[bufferString appendString:@"4"];
		}
		else if ( [bufferAsString isEqualToString:@"0200220000000000"] )
		{
			[bufferString appendString:@"5"];
		}
		else if ( [bufferAsString isEqualToString:@"0200230000000000"] )
		{
			[bufferString appendString:@"6"];
		}
		else if ( [bufferAsString isEqualToString:@"0200240000000000"] )
		{
			[bufferString appendString:@"7"];
		}
		else if ( [bufferAsString isEqualToString:@"0200250000000000"] )
		{
			[bufferString appendString:@"8"];
		}
		else if ( [bufferAsString isEqualToString:@"0200260000000000"] )
		{
			[bufferString appendString:@"9"];
		}
		else if ( [bufferAsString isEqualToString:@"0200270000000000"] )
		{
			[bufferString appendString:@"0"];
		}
	}
}

@end
