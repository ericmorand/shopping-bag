//
//  PreferencesController.h
//  FKKit
//
//  Created by Eric on 06/05/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesController : FKMultiplePanesController
{
	IBOutlet NSView *						generalView;
	IBOutlet NSView *						barcodeReadersView;
	
	FKBarcodeScannersManager *				defaultScannersManager; // Not retained
}

@property (retain) NSView *						generalView;
@property (retain) NSView *						barcodeReadersView;
@property (retain) FKBarcodeScannersManager *				defaultScannersManager;
@end
