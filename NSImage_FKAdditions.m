//
//  NSImage_FKAdditions.m
//  FKKit
//
//  Created by Eric on 30/08/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import "NSImage_FKAdditions.h"


@implementation NSImage (FKAdditions)

+ (id)imageNamed:(NSString *)name forClass:(Class)aClass
{
	NSImage * imageNamed = nil;
	NSString * imagePath = nil;
	
	imagePath = [[NSBundle bundleForClass:aClass] pathForResource:name ofType:@"png"];
	imageNamed = [[[NSImage alloc] initWithContentsOfFile:imagePath] autorelease];
	
	return imageNamed;
}

- (NSData *)JPEGRepresentationUsingCompression:(float)compressionValue
{	
	NSBitmapImageRep * myBitmapImageRep = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
	
	NSDictionary * propertyDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:compressionValue]
															  forKey:NSImageCompressionFactor];

	return [myBitmapImageRep representationUsingType:NSJPEGFileType properties:propertyDict];
}

/*- (NSImage *)grayScaleImage
{
	NSImage * grayScaleImage = [[[NSImage alloc] initWithSize:[self size]] autorelease];
	
	[grayScaleImage lockFocus];
	
	CIContext * context = [[NSGraphicsContext currentContext] CIContext];
	CIImage * result = [[[CIImage alloc] initWithBitmapImageRep:[self bitmapImageRep]] autorelease];
	
	CGRect srcRect = CGRectMake(0.0, 0.0, [self size].width, [self size].height);
	
	CIFilter * monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:@"inputImage", result, nil];
				
	[monochromeFilter setValue:[CIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0] forKey:@"inputColor"];
	[monochromeFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
				
	result = [monochromeFilter valueForKey:@"outputImage"];
	
	[context drawImage:result atPoint:CGPointZero fromRect:srcRect];
	
	[grayScaleImage unlockFocus];
	
	return grayScaleImage;
}

- (NSBitmapImageRep *)bitmapImageRep
{
	NSSize size = [self size]; 
	
	[self lockFocus];
	
	NSBitmapImageRep * bitmapImageRep = [[[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0.0, 0.0, size.width, size.height)] autorelease];
	
	[self unlockFocus];
	
	return bitmapImageRep;
}

#pragma mark -
#pragma mark DRAWING

- (void)drawFocusRingInView:(NSView *)aView inRect:(NSRect)aRect
{
	[aView lockFocus];
	
	float bloomRadius = 3.0;
	float ringWidth = 5.0;
	
	NSSize selfSize = [self size];
	
	CIContext * context = [[NSGraphicsContext currentContext] CIContext];
	CIImage * selfCIImage = [[[CIImage alloc] initWithBitmapImageRep:[self bitmapImageRep]] autorelease];
	CIImage * focusRingCIImage = nil;
	
	CGRect focusRingRect = CGRectZero;
	CGRect destRect = CGRectZero;
	
	focusRingRect.size.width = selfSize.width + (2 * bloomRadius);
	focusRingRect.size.height = selfSize.height + (2 * bloomRadius);
	focusRingRect.origin.x -= bloomRadius;
	focusRingRect.origin.y -= bloomRadius;
	
	destRect.origin.x = NSMinX(aRect) - ringWidth;
	destRect.origin.y = NSMinY(aRect) - ringWidth;
	destRect.size.width = NSWidth(aRect) + (2 * ringWidth);
	destRect.size.height = NSHeight(aRect) + (2 * ringWidth);
	
	// False color
	
	CIFilter * falseColorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage", selfCIImage, nil];
	
	[falseColorFilter setValue:[CIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.75] forKey:@"inputColor0"];
	[falseColorFilter setValue:[CIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.75] forKey:@"inputColor1"];
	
	focusRingCIImage = [falseColorFilter valueForKey:@"outputImage"];
	
	// Bloom
	
	CIFilter * bloomFilter = [CIFilter filterWithName:@"CIBloom" keysAndValues:@"inputImage", focusRingCIImage, nil];
	
	[bloomFilter setValue:[NSNumber numberWithFloat:bloomRadius] forKey:@"inputRadius"];
	[bloomFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
	
	focusRingCIImage = [bloomFilter valueForKey:@"outputImage"];
	
	// Dessin de la focus ring dans la vue au point donne
	
	[context drawImage:focusRingCIImage inRect:destRect fromRect:focusRingRect];
	
	[aView unlockFocus];
}*/

@end
