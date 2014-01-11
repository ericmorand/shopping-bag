//
//  FKModuleToolbarButtonCell.m
//  Shopping Bag
//
//  Created by Eric on 11/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleToolbarButtonCell.h"
#import "FKModuleToolbarButton.h"

@interface FKModuleToolbarButtonCell (Private)

- (void)setFirstLine:(NSString *)aString;
- (void)setSecondLine:(NSString *)aString;
- (void)calculateLayout;

@end

@implementation FKModuleToolbarButtonCell

@synthesize firstLine;
@synthesize secondLine;
@synthesize maxLineWidth;
@synthesize horizontalMargin;
@synthesize toolbar;
@synthesize toolbarItem;

- (id)init {
	self = [super init];
	
	if (nil != self) {		
		maxLineWidth = 75.0;
		horizontalMargin = 10.0;
	}
	
	return self;
}

- (void)dealloc {
	self.firstLine = nil;
	self.secondLine = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (NSSize)cellSize
{	
	NSSize cellSize = NSZeroSize;	
	
	if (self.usesCustomDrawing) {
		NSAttributedString * attributedTitle = [self attributedTitle];
			
		if ((attributedTitle != nil) && (![[attributedTitle string] isEqualToString:@""])) {		
			NSSize titleSize = [attributedTitle size];
			
			cellSize.width = ceil(titleSize.width);
			cellSize.height = ceil(titleSize.height);
		}	
		
		if ([self image]) {
			NSSize imageSize = [[self image] size];
			
			cellSize.width = MAX(cellSize.width, imageSize.width);
			cellSize.height += ceil(imageSize.height);
		}
	}
	else {
		cellSize = [super cellSize];
	}
	
	return cellSize;
}

- (BOOL)usesCustomDrawing {
	return YES;
}

#pragma mark -
#pragma mark SETTERS

- (void)setTitle:(NSString *)aString {
	[super setTitle:aString];
	
	if (self.usesCustomDrawing) {
		FKModuleToolbarButton * controlButton = (FKModuleToolbarButton *)[self controlView];
		NSDictionary * titleAttributes = [[controlButton toolbar] labelStringAttributes];
	
		NSAttributedString * attributedTitle = [[[NSAttributedString alloc] initWithString:[self title] attributes:titleAttributes] autorelease];
	
		[self setAttributedTitle:attributedTitle];
	}
}

#pragma mark -
#pragma mark LAYOUT

- (void)calculateLayout {	
	// Par defaut, les instances de NSButton utilisent un systeme de coordonnees "flipped"
	
	FKModuleToolbarButton * controlButton = (FKModuleToolbarButton *)[self controlView];
	
	NSRect bounds = [controlButton bounds];
	
	// *****
	// Image
	// *****
	
	imageRect.size = [[self image] size];
	imageRect.origin.x = floor((NSWidth(bounds) - NSWidth(imageRect)) / 2.0);
	
	// *****
	// Titre
	// *****
	
	titleRect = NSZeroRect;

	titleRect.size = [[self attributedTitle] size];
	titleRect.origin.x = floor((NSWidth(bounds) - NSWidth(titleRect)) / 2.0);
	titleRect.origin.y = NSHeight(bounds) - NSHeight(titleRect);
}

#pragma mark -
#pragma mark DRAWING

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	if (self.usesCustomDrawing) {
		FKModuleToolbarButton * controlButton = (FKModuleToolbarButton *)controlView;
		
		// *****
		// Image
		// *****
	
		NSRect srcRect = NSZeroRect;
		NSRect destRect = NSZeroRect;
	
		NSImage * image = [self imageToDrawInView:controlButton];
	
		srcRect.size = [image size];

		destRect.size = srcRect.size;
		destRect.origin.x = floor((NSWidth(cellFrame) - NSWidth(destRect)) / 2.0);
		destRect.origin.y += 1.0;
	
		[image drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];
	
		// *****
		// Titre
		// *****
	
		NSMutableAttributedString * attributedTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
		NSColor * titleColor = nil;
	
		BOOL isKeyWindow = [[controlButton window] isKeyWindow];
	
		if (([controlButton isEnabled] ) && isKeyWindow) {
			titleColor = [NSColor toolbarEnabledForeColor];
		}
		else {
			titleColor = [NSColor toolbarDisabledForeColor];
		}
	
		[attributedTitle beginEditing];
		[attributedTitle addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, [attributedTitle length])];
		[attributedTitle endEditing];
	
		[attributedTitle drawInRect:titleRect];
	}
	else {
		[super drawWithFrame:cellFrame inView:controlView];
	}
}

- (NSImage *)imageToDrawInView:(NSView *)controlView;
{
	//NSLog (@"[self title] = %@, imageToDrawInView = %@", [self title], [self image]);
	
	NSImage * image = [self image];

	FKModuleToolbarButton * controlButton = (FKModuleToolbarButton *)controlView;
	
	BOOL isKeyWindow = [[controlButton window] isKeyWindow];
	BOOL isHighlighted = [self isHighlighted];
	
	if ( !image ) {return nil;}
	
    NSSize newSize = [image size];
    NSImage * newImage = [[NSImage alloc] initWithSize:newSize];
	
	NSRect srcRect = NSZeroRect;
	
	srcRect.size = newSize;
	
	[newImage setFlipped:[controlButton isFlipped]];
    [newImage lockFocus];
	
	float fraction = 1.0;
		
	if ( ![self isEnabled] || !isKeyWindow )
	{		
		fraction = 0.50;
	}	
	
    [image drawAtPoint:NSZeroPoint fromRect:srcRect operation:NSCompositeSourceOver fraction:fraction];
	
	if ( isHighlighted )
	{
		[[[NSColor blackColor] colorWithAlphaComponent:0.5] set];
		
		NSRectFillUsingOperation(srcRect, NSCompositeSourceAtop);
	}
	
    [newImage unlockFocus];
	
    return [newImage autorelease];
}

@end
