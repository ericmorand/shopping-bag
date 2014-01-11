//
//  FKTabViewItem.m
//  FKKit
//
//  Created by alt on 02/01/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKTabViewItem.h"

#define kIconImageSize		16.0

@interface FKTabViewItem (Private)

- (void)setUnselectedImage:(NSImage *)anImage;

@end

@implementation FKTabViewItem

@synthesize image;
@synthesize unselectedImage;

#pragma mark -
#pragma mark SETTERS

- (void)setImage:(NSImage *)anImage {
	if (anImage != image) {
		[image release];
		image = [anImage retain];
		
		[image setFlipped:YES]; // FIX : Voir pourquoi setFlipped ne fonctionne pas dans drawTabViewItem de FKTabView
		
		// ...
		
		self.unselectedImage = [image grayScaleImage];
	}
}

@end
