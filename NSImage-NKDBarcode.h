// -----------------------------------------------------------------------------------
//  NSImage-NKDBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 01 2002.
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "NKDBarcode.h"
#import "NKDBarcodeOffscreenView.h"


@interface NSImage (NKDBarcode)

+(NSImage *)imageFromBarcode:(NKDBarcode *)barcode;

@end
