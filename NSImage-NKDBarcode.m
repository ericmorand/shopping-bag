// -----------------------------------------------------------------------------------
//  NSImage-NKDBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 01 2002.
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------

#import "NSImage-NKDBarcode.h"

@implementation NSImage (NKDBarcode)

+ (NSImage *)imageFromBarcode:(NKDBarcode *)barcode
{
    NKDBarcodeOffscreenView * view = [[[NKDBarcodeOffscreenView alloc] initWithBarcode:barcode] autorelease];
    NSData * data = [view dataWithPDFInsideRect:[view bounds]];
     
    NSImage * image = [[[NSImage alloc] initWithData:data] autorelease];
	    
	return image;
}
@end
