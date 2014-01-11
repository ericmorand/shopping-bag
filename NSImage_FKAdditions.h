//
//  NSImage_FKAdditions.h
//  FKKit
//
//  Created by Eric on 30/08/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSImage (FKAdditions)

+ (id)imageNamed:(NSString *)name forClass:(Class)aClass;

- (NSImage *)grayScaleImage;
- (NSBitmapImageRep *)bitmapImageRep;
- (NSData *)JPEGRepresentationUsingCompression:(float)compressionValue;

- (void)drawFocusRingInView:(NSView *)aView inRect:(NSRect)aRect;

@end
