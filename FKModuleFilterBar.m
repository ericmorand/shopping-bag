//
//  FKModulePlateToolbar.m
//  FKKit
//
//  Created by Eric on 15/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleFilterBar.h"
#import "FKModuleFilterBarClipIndicator.h"
#import "FKModuleToolbarSeparator.h"

@interface FKModuleFilterBar (Private)

//- (NSString *)askDelegateForPredicateFormatForItemIdentifier:(NSString *)anItemIdentifier;
- (NSString *)askDelegateForPredicateFormatForItemIdentifier:(NSString *)anItemIdentifier inAreaAtIndex:(NSInteger)areaIndex;
- (NSArray *)askDelegateForPredicateArgumentsForItemIdentifier:(NSString *)anItemIdentifier inAreaAtIndex:(NSInteger)areaIndex;

@end

@implementation FKModuleFilterBar

@synthesize predicatesArray;
@synthesize predicate;

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
	if (nil != self) {
		interItemsMargin = 4.0;
		//itemHeight = 24.0;
		
		self.predicatesArray = [NSMutableArray array];
		self.predicate = nil;
    }
	
    return self;
}

- (void)dealloc {
	self.predicatesArray = nil;
	self.predicate = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (BOOL)isFlipped {
	return YES;
}

- (Class)buttonClass {
	return [FKModuleFilterBarButton class];
}

- (Class)clipIndicatorClass {
	return [FKModuleFilterBarClipIndicator class];
}

#pragma mark -
#pragma mark SETTERS

- (void)setSelectedItemIdentifier:(NSString *)itemIdentifier forAreaAtIndex:(int)areaIndex {
	NSString *format = [self askDelegateForPredicateFormatForItemIdentifier:itemIdentifier inAreaAtIndex:areaIndex];
	NSArray *arguments = [self askDelegateForPredicateArgumentsForItemIdentifier:itemIdentifier inAreaAtIndex:areaIndex];
	
	NSPredicate * aPredicate = [NSPredicate predicateWithFormat:format argumentArray:arguments];
	
	if (nil != aPredicate) {
		if ([predicatesArray count] > areaIndex) {
			[predicatesArray replaceObjectAtIndex:areaIndex withObject:aPredicate];
		}
		else {
			[predicatesArray addObject:aPredicate];
		}
		
		self.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:predicatesArray]];
		
		// Support du binding, voir ici :
		// http://www.tomdalling.com/cocoa/implementing-your-own-cocoa-bindings
		
		[self propagateValue:self.predicate forBinding:@"predicate"];
	}
	
	[super setSelectedItemIdentifier:itemIdentifier forAreaAtIndex:areaIndex];
}

#pragma mark -
#pragma mark MISC

- (void)reloadDat 
{
	[predicatesArray removeAllObjects];
	
	[super reloadData];
}

#pragma mark -
#pragma mark DRAWING

- (void)drawRect:(NSRect)rect {
	NSRect bounds = [self bounds];
	NSRect borderRect = NSZeroRect;
	
	NSDivideRect(bounds, &borderRect, &bounds, 1.0, NSMaxYEdge);	
	
	// Image
	
    NSImage * backImg = [NSImage imageNamed:@"FKNavigationBarBack"];
	NSRect srcRect = NSZeroRect;
	NSRect destRect = NSZeroRect;
	
	[backImg setFlipped:[self isFlipped]];
	
	srcRect.size = [backImg size];
	destRect = bounds;
	
	[backImg drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];
	
	// Bordure
	
	[[NSColor strongBorderColor] set];
	
	NSRectFill(borderRect);
}

#pragma mark -
#pragma mark NOTIFICATIONS

- (void)windowDidUpdate:(NSNotification *)aNotification {
	[super windowDidUpdate:aNotification];
	
	//...
	
	NSString * anIdentifier = nil;
	NSNumber * areaIndexAsNumber = nil;	
	NSArray * selectableItemIdentifiersArray = nil;
	
	int areaIndex = 0;
	
	for (areaIndex = 0; areaIndex < numberOfAreas; areaIndex++) {	
		areaIndexAsNumber = [NSNumber numberWithInt:areaIndex];
		
		// On determine l'item selectionne dans la zone donnee
		
		anIdentifier = [selectedItemIdentifiers objectForKey:areaIndexAsNumber];
		
		if (nil == anIdentifier) {			
			// Si aucun item n'est selectionne dans la zone donnee,
			// on selectionne arbitrairement le premier item disponible de la zone
			
			selectableItemIdentifiersArray = [selectableItemIdentifiers objectForKey:areaIndexAsNumber];
			
			if ([selectableItemIdentifiersArray count] > 0) {
				anIdentifier = [selectableItemIdentifiersArray objectAtIndex:0];
				
				[self setSelectedItemIdentifier:anIdentifier forAreaAtIndex:areaIndex];
			}
		}
	}
}

#pragma mark -
#pragma mark DELEGATE METHODS

- (NSString *)askDelegateForPredicateFormatForItemIdentifier:(NSString *)anItemIdentifier inAreaAtIndex:(NSInteger)areaIndex {
//- (NSString *)askDelegateForPredicateFormatForItemIdentifier:(NSString *)anItemIdentifier {
	if ([delegate respondsToSelector:@selector(filterBar:predicateFormatForItemIdentifier:inAreaAtIndex:)]) {
		return [delegate filterBar:self predicateFormatForItemIdentifier:anItemIdentifier inAreaAtIndex:areaIndex];
	}
	else if ([delegate respondsToSelector:@selector(filterBar:predicateFormatForItemIdentifier:)]) {
		return [delegate filterBar:self predicateFormatForItemIdentifier:anItemIdentifier];
	}
	
	return nil;
}

- (NSArray *)askDelegateForPredicateArgumentsForItemIdentifier:(NSString *)anItemIdentifier inAreaAtIndex:(NSInteger)areaIndex {
	if ([delegate respondsToSelector:@selector(filterBar:predicateArgumentsForItemIdentifier:inAreaAtIndex:)]) {
		return [delegate filterBar:self predicateArgumentsForItemIdentifier:anItemIdentifier inAreaAtIndex:areaIndex];
	}
	
	return nil;
}

- (NSArray *)askDelegateForSelectableItemIdentifiersForAreaAtIndex:(int)areaIndex; {
	// Au sein d'une barre de filtre, tous les items sont selectionnables	
	
	if ([delegate respondsToSelector:@selector(moduleToolbarItemIdentifiers:forAreaAtIndex:)]) {
		return [delegate moduleToolbarItemIdentifiers:self forAreaAtIndex:areaIndex];
	}
	
	return nil;
}

@end
