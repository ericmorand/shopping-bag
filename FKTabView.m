//
//  FKTabView.m
//  FKKit
//
//  Created by alt on 01/11/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKTabView.h"

@interface FKTabView (Private)

- (void)reloadData;
- (NSUInteger)askDelegateForNumberOfItems;
- (NSString *)askDelegateForIdentifierForItemAtIndex:(NSUInteger)anIndex;
- (NSView *)askDelegateForViewForItemAtIndex:(NSUInteger)anIndex;
- (NSString *)askDelegateForLabelForItemAtIndex:(NSUInteger)anIndex;
- (void)addTabViewItemRect:(NSRect)aRect;
- (void)notifyDelegateTabViewDidSelectTabViewItem:(FKTabViewItem *)anItem;

@end

@implementation FKTabView

@synthesize placeholderView;
@synthesize	needsReload;
@synthesize tabViewItems;
@synthesize tabViewItemRects;
@synthesize selectedTabViewItem;
@synthesize pressedTabViewItem;
@synthesize mouseOverTabViewItem;
@synthesize tabHeight;
@synthesize labelMargin;
@synthesize commonWidth;
@synthesize tabsAreaHeight;
@synthesize interItemsMargin;
@synthesize delegate;
@synthesize labelAttributes;
@synthesize alignment;

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	if (self) {		
		self.placeholderView = [[[FKView alloc] initWithFrame:NSZeroRect] autorelease];
		
		[placeholderView setBackgroundColor:[NSColor whiteColor]]; //[NSColor colorWithDeviceRed:240.0/255.0 green:240.0/255. blue:240.0/255. alpha:1.0]];
		[placeholderView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		//[placeholderView setAutoresizingMask:(NSViewHeightSizable)];
				
		[self setTabViewItems:[NSMutableArray array]];
		[self setTabViewItemRects:[NSMutableArray array]];
		[self setAlignment:FKTabViewCenterAlignment];
		
		tabHeight = 22.0;
		labelMargin = 12.0;
		tabsAreaHeight = 30.0;
		interItemsMargin = 1.0;
		
		// ...
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:NSViewFrameDidChangeNotification object:self];
		[self setPostsFrameChangedNotifications:YES];
		
		self.needsReload = YES;
		
		// ...
		
		[self setupLayout];
	}
	
	return self;
}

- (void)dealloc {
	self.placeholderView = nil;
	self.tabViewItems = nil;
	self.tabViewItemRects = nil;
	self.labelAttributes = nil;
	self.delegate = nil;
	
	[super dealloc];
}

- (void)awakeFromNib {
}

#pragma mark -
#pragma mark GETTERS

- (BOOL)isFlipped {
	return YES;
}

- (int)numberOfTabViewItems {
	return [tabViewItems count];
}

- (NSDictionary *)labelAttributes {
	if (nil == labelAttributes) {
		NSFont * font = [NSFont boldSystemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]];
		NSMutableParagraphStyle * style = [[[NSMutableParagraphStyle alloc] init] autorelease];
		
		[style setLineBreakMode:NSLineBreakByTruncatingTail];
		[style setAlignment:NSCenterTextAlignment]; 
		
		[self setLabelAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil]];
	}
	
	return labelAttributes;
}

- (NSRect)tabRectForTabViewItem:(FKTabViewItem *)anItem {
	NSRect tabRect = NSZeroRect;
	
	if ([tabViewItems containsObject:anItem]) {
		int index = [tabViewItems indexOfObject:anItem];
		
		tabRect = NSRectFromString([tabViewItemRects objectAtIndex:index]);
	}
	
	return tabRect;
}

- (FKTabViewItem *)tabViewItemAtPoint:(NSPoint)aPoint {
	NSRect itemRect = NSZeroRect;
	
	FKTabViewItem * anItem = nil;
	
	for (anItem in tabViewItems) {
		itemRect = [self tabRectForTabViewItem:anItem];
		
		if (NSPointInRect(aPoint, itemRect)) {
			break;
		}
	}
	
	return anItem;
}

- (int)indexOfTabViewItem:(FKTabViewItem *)tabViewItem {
	return [tabViewItems indexOfObject:tabViewItem];
}

#pragma mark -
#pragma mark SETTERS

- (void)setDelegate:(id)anObject {
	if ( anObject != delegate ) {
		delegate = anObject;
		
		if (needsReload) {
			[self reloadData];
		}
	}
}

#pragma mark -
#pragma mark TabViewItems Management

- (void)addTabViewItem:(FKTabViewItem *)tabViewItem {
	[tabViewItems addObject:tabViewItem];
	
	// On recalcule commonWidth	
	
	[self updateCommonWidthWithNewTabViewItem:tabViewItem];
}

- (void)insertTabViewItem:(FKTabViewItem *)tabViewItem atIndex:(int)index {
	[tabViewItems insertObject:tabViewItem atIndex:index];
	
	// On recalcule commonWidth	
	
	[self updateCommonWidthWithNewTabViewItem:tabViewItem];
}

- (void)removeTabViewItem:(FKTabViewItem *)tabViewItem {
	[tabViewItems removeObject:tabViewItem];
	
	// On recalcule commonWidth
	
	commonWidth = 0.0;
	
	NSTabViewItem * anItem = nil;
	NSAttributedString * attributedLabel = nil;
	
	for (anItem in tabViewItems) {
		attributedLabel = [[[NSAttributedString alloc] initWithString:[anItem label] attributes:[self labelAttributes]] autorelease];
		
		commonWidth = MAX(commonWidth, ceil([attributedLabel size].width + (2 * labelMargin)));		
	}
}

- (void)selectTabViewItem:(FKTabViewItem *)tabViewItem {
	if (tabViewItem != selectedTabViewItem) {
		selectedTabViewItem = tabViewItem;
	
		NSView * itemView = [selectedTabViewItem view];
		
		//[itemView setFrameHeight:<#(float)aFloat#>
		
		[placeholderView setContentView:itemView];
		
		[self notifyDelegateTabViewDidSelectTabViewItem:tabViewItem];
	}
}

- (void)selectTabViewItemAtIndex:(int)index {
	if (index < [self numberOfTabViewItems])
	{
		FKTabViewItem * itemToSelect = [tabViewItems objectAtIndex:index];
	
		if (nil != itemToSelect) {
			[self selectTabViewItem:itemToSelect];
		}
	}
}

- (void)selectTabViewItemWithIdentifier:(NSString *)identifier {
	FKTabViewItem * anItem = nil;
	
	for (anItem in tabViewItems) {
		if ([[anItem identifier] isEqualToString:identifier]) {
			break;
		}
	}
	
	[self selectTabViewItem:anItem];
}

- (void)updateCommonWidthWithNewTabViewItem:(FKTabViewItem *)anItem {
	NSAttributedString * attributedLabel = [[[NSAttributedString alloc] initWithString:[anItem label] attributes:[self labelAttributes]] autorelease];
	//NSImage * itemImage = [anItem image];
	
	commonWidth = MAX(commonWidth, ceil([attributedLabel size].width + (2 * labelMargin)));
}

#pragma mark -
#pragma mark LAYOUT & DRAWING

- (void)reloadData {	
	NSView * view = nil;
	NSString * identifier = nil;
	NSString * title = nil;
	
	NSUInteger numberOfItems = [self askDelegateForNumberOfItems];
	NSUInteger i = 0;		
	
	FKTabViewItem * item = nil;
	
	// ...
	
	if (nil != selectedTabViewItem) {
		[[selectedTabViewItem view] removeFromSuperview];
	}
	
	[tabViewItems removeAllObjects];
	
	// ...
	
	for (i = 0; i < numberOfItems; i++) {
		view = [self askDelegateForViewForItemAtIndex:i];		
		identifier = [self askDelegateForIdentifierForItemAtIndex:i];
		title = [self askDelegateForLabelForItemAtIndex:i];
		
		item = [[[FKTabViewItem alloc] initWithIdentifier:identifier] autorelease];
					
		[item setLabel:title];
		[item setView:view];
		
		[self addTabViewItem:item];	
	}
	
	// ...
	
	if ( numberOfItems > 0 ) {
		[self selectTabViewItemAtIndex:0];
	}
	
	needsReload = NO;
}

- (void)frameDidChange:(NSNotification *)aNotification {
	[self tile];	
}

- (void)setupLayout {	
	[self addSubview:placeholderView];
}

- (void)tile {	
	NSRect bounds = [self bounds];
	NSDivideRect(bounds, &tabsAreaRect, &placeholderRect, tabsAreaHeight, NSMinYEdge);	

	[placeholderView setFrame:placeholderRect];
	
	// ...
	
	tabsUnionRect = NSZeroRect;
	
	// ...
	
	[tabViewItemRects removeAllObjects];
		
	int numberOfTabViewItems = [self numberOfTabViewItems];
	
	float scrollerWidth = [NSScroller scrollerWidth] + 5.0;
	
	float availableWidth = tabsAreaRect.size.width - (2 * scrollerWidth) - ((numberOfTabViewItems - 1) * interItemsMargin);
	float bufferWidth = availableWidth - (numberOfTabViewItems * commonWidth);
	
	NSRect tabViewItemRect = NSZeroRect;
	
	tabViewItemRect.size.height = tabHeight;
	tabViewItemRect.origin.x = scrollerWidth;
	tabViewItemRect.origin.y = tabsAreaHeight - tabViewItemRect.size.height;
	
	int i = 0;
	
	// ...
	
	if (bufferWidth >= 0.0) {
		if ( alignment == FKTabViewCenterAlignment ) {
			tabViewItemRect.origin.x += floor(bufferWidth / 2.0);
		}
		
		for (i = 0; i < numberOfTabViewItems; i++) {
			tabViewItemRect.size.width = commonWidth;
			
			[self addTabViewItemRect:tabViewItemRect];
			
			tabViewItemRect.origin.x += tabViewItemRect.size.width + interItemsMargin;
		}
	}
	else {
		for (i = 0; i < numberOfTabViewItems; i++) {
			if (i == (numberOfTabViewItems - 1)) {
				tabViewItemRect.size.width = availableWidth;
			}
			else {
				tabViewItemRect.size.width = floor(availableWidth / (numberOfTabViewItems - i));
			}
						
			[self addTabViewItemRect:tabViewItemRect];
			
			tabViewItemRect.origin.x += tabViewItemRect.size.width + interItemsMargin;
			availableWidth -= tabViewItemRect.size.width;
		}
	}
}

- (void)addTabViewItemRect:(NSRect)aRect {	
	// ...
	
	[tabViewItemRects addObject:NSStringFromRect(aRect)];
	
	tabsUnionRect = NSUnionRect(tabsUnionRect, aRect);
}

- (void)drawRect:(NSRect)aRect
{	
	[NSGraphicsContext saveGraphicsState];
		
	// FIX : Optimiser en ne redessinant que la zone "dirty"
	
	NSRect backgroundRect = tabsAreaRect;
	
	// Fond
	
	NSImage * backImg = [NSImage imageNamed:@"TabViewBack"];
	
	NSRect srcRect = NSZeroRect;
	
	srcRect.size.width = [backImg size].width;
	srcRect.size.height = [backImg size].height;
	
	[backImg setFlipped:[self isFlipped]];
	[backImg drawInRect:backgroundRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];
	
	// TabViewItems
		
	for (FKTabViewItem * anItem in tabViewItems) {
		[self drawTabViewItem:anItem];
	}
	
	[NSGraphicsContext restoreGraphicsState];
}

- (NSBezierPath *)segmentPathWithSegmentRect:(NSRect)aRect
{
	NSBezierPath * path = [NSBezierPath bezierPath];	
	
	if ( aRect.size.height > 0 )
	{	
		NSRect insetRect = aRect;
		
		insetRect.origin.x += 0.5;	
		insetRect.origin.y += 0.5;
		insetRect.size.width -= 1.0;
		insetRect.size.height -= 0.5;
		
		float radius = 5.0;
		
		float rectWidth = NSWidth(insetRect);
		float rectHeight = NSHeight(insetRect);
		float originX = insetRect.origin.x;
		float originY = insetRect.origin.y + rectHeight;		
		
		NSPoint nextPoint = NSZeroPoint;
			
		// ...
			
		nextPoint = NSMakePoint(originX, originY);
				
		[path moveToPoint:nextPoint];
			
		// ...
			
		nextPoint = NSMakePoint(originX + radius, originY - rectHeight + radius);
				
		[path appendBezierPathWithArcWithCenter:nextPoint radius:radius startAngle:180.0 endAngle:270.0 clockwise:NO];
			
		// ...

		nextPoint = NSMakePoint(originX + rectWidth - radius, originY - rectHeight + radius);
				
		[path appendBezierPathWithArcWithCenter:nextPoint radius:radius startAngle:270.0 endAngle:  0.0 clockwise:NO];
			
		// ...
			
		nextPoint = NSMakePoint(originX + rectWidth, originY);
				
		[path lineToPoint:nextPoint];
	}
	
	return path;
}

- (void)drawTabViewItem:(FKTabViewItem *)anItem {
	NSRect segmentRect = [self tabRectForTabViewItem:anItem];
		
	NSShadow * shadow = [[[NSShadow alloc] init] autorelease];
	
	[shadow setShadowColor:[NSColor blackColor]];
	[shadow setShadowOffset:NSMakeSize(10.0, 10.0)];
	
	
	//NSFrameRect(segmentRect);
	
	BOOL isMouseOver = NO;
	BOOL isSelected = NO;
	BOOL isPressed = NO;
		
	// ****
	// Fond
	// ****
	
	[NSGraphicsContext saveGraphicsState];
	
	//[shadow set];
	
	isMouseOver = ( anItem == mouseOverTabViewItem );
	isPressed = ( anItem == pressedTabViewItem );
	isSelected = ( anItem == selectedTabViewItem );
		
	NSBezierPath * segmentPath = nil;
	
	[[NSColor lightBorderColor] set];
	
	if (isSelected) {
		NSRect selectedSegmentRect = segmentRect;
		NSRect borderRect = NSZeroRect;
		
		NSDivideRect(segmentRect, &borderRect, &selectedSegmentRect, 1.0, NSMaxYEdge);
		
		
		segmentPath = [self segmentPathWithSegmentRect:selectedSegmentRect];
		
		[segmentPath linearGradientFillWithStartColor:[NSColor whiteColor]
											 endColor:[NSColor whiteColor]];
		
		[segmentPath stroke];
				
		NSRectFill(borderRect);
	}
	else {
		NSRect unselectedSegmentRect = segmentRect;
		
		unselectedSegmentRect.size.height -= 1.0;
		
		segmentPath = [self segmentPathWithSegmentRect:unselectedSegmentRect];
	
		[segmentPath linearGradientFillWithStartColor:[NSColor colorWithDeviceRed:200.0/255.0 green:200.0/255. blue:200.0/255. alpha:1.0]
											 endColor:[NSColor colorWithDeviceRed:150.0/255.0 green:150.0/255. blue:150.0/255. alpha:1.0]];
		
		[segmentPath stroke];
	}
	
	[NSGraphicsContext restoreGraphicsState];
	
	// *****
	// Image
	// *****
	
	if (nil != anItem.image) {	
		NSImage * imageToDraw = nil;
		
		if (isSelected | isPressed | isMouseOver) {
			imageToDraw = [anItem image];			
		}
		else {
			imageToDraw = [anItem unselectedImage];
		}
		
		//[imageToDraw setFlipped:YES];
				
		NSRect srcRect = NSZeroRect;
		NSRect destRect = segmentRect;
		
		srcRect.size = [imageToDraw size];
		destRect.size = NSMakeSize(48.0, 48.0);
		
		if (isPressed && !isSelected) {
			destRect.size = NSMakeSize(40.0, 40.0);
		}
		
		destRect.origin.x += floor((NSWidth(segmentRect) - NSWidth(destRect)) / 2.0);
		destRect.origin.y += floor((NSHeight(segmentRect) - (NSHeight(destRect) + 10.0)) / 2.0);
				
		if (isMouseOver && !isSelected) {
			[imageToDraw drawFocusRingInView:self inRect:destRect];
		}
		
		[imageToDraw drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];
	}
		
	// *****
	// Label
	// *****
	
	NSAttributedString * attributedLabel = [[[NSAttributedString alloc] initWithString:[anItem label] attributes:[self labelAttributes]] autorelease];
	
	NSSize labelSize = [attributedLabel size];
	NSRect labelRect = segmentRect;
	
	labelRect.size.width -= (2 * labelMargin);
	labelRect.size.height = labelSize.height;
	labelRect.origin.x += labelMargin;
	labelRect.origin.y += segmentRect.size.height - (labelRect.size.height + 4.0);
	
	[attributedLabel drawInRect:labelRect];
}

- (void)viewDidMoveToWindow
{
	[self tile];
}

#pragma mark -
#pragma mark EVENTS

- (void)mouseDown:(NSEvent *)theEvent
{
	BOOL done = NO;
	
	NSPoint currentPoint = NSZeroPoint;
	
	// ...
	
	currentPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
	if ( NSPointInRect(currentPoint, tabsAreaRect) )
	{
		FKTabViewItem * clickedItem = [self tabViewItemAtPoint:currentPoint];
		
		if ( clickedItem )
		{
			pressedTabViewItem = clickedItem;
		
			[self setNeedsDisplayInRect:tabsAreaRect];
	
			while ( !done )
			{
				NSEvent * nextEvent = [NSApp nextEventMatchingMask:(NSLeftMouseUpMask|NSLeftMouseDraggedMask) untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES];
		
				if ( nextEvent )
				{
					done = ( [nextEvent type] == NSLeftMouseUp );
			
					if ( !done ) // NSLeftMouseDragged
					{				
						currentPoint = [self convertPoint:[nextEvent locationInWindow] fromView:nil];
				
						if ( !NSPointInRect(currentPoint, [self tabRectForTabViewItem:clickedItem]) )
						{
							pressedTabViewItem = nil;	
						}
						else
						{
							pressedTabViewItem = clickedItem ;
						}
					}
					else
					{
						if ( NSPointInRect(currentPoint, [self tabRectForTabViewItem:clickedItem]) )
						{
							[self selectTabViewItem:clickedItem];
							
							pressedTabViewItem = nil;
						}
					}
				
					[self setNeedsDisplayInRect:tabsAreaRect];
				}
			}
		}
	}
}

#pragma mark -
#pragma mark DELEGATE SUPPORT

- (NSUInteger)askDelegateForNumberOfItems {
	NSUInteger numberOfStackedViews = 0;
	
	if ([delegate respondsToSelector:@selector(fkTabViewNumberOfItems:)]) {
		numberOfStackedViews = [delegate fkTabViewNumberOfItems:self];
	}
	
	return numberOfStackedViews;
}

- (NSString *)askDelegateForIdentifierForItemAtIndex:(NSUInteger)anIndex {
	NSString * identifierForItemAtIndex = nil;
	
	if ([delegate respondsToSelector:@selector(fkTabView:identifierForItemAtIndex:)]) {
		identifierForItemAtIndex = [delegate fkTabView:self identifierForItemAtIndex:anIndex];
	}
	
	return identifierForItemAtIndex;
}

- (NSView *)askDelegateForViewForItemAtIndex:(NSUInteger)anIndex {
	NSView * viewForItemAtIndex = nil;
	
	if ([delegate respondsToSelector:@selector(fkTabView:viewForItemAtIndex:)]) {
		viewForItemAtIndex = [delegate fkTabView:self viewForItemAtIndex:anIndex];
	}
	
	return viewForItemAtIndex;
}

- (NSString *)askDelegateForLabelForItemAtIndex:(NSUInteger)anIndex {
	NSString * labelForItemAtIndex = nil;
	
	if ([delegate respondsToSelector:@selector(fkTabView:labelForItemAtIndex:)]) {
		labelForItemAtIndex = [delegate fkTabView:self labelForItemAtIndex:anIndex];
	}
	
	return labelForItemAtIndex;
}

- (void)notifyDelegateTabViewDidSelectTabViewItem:(FKTabViewItem *)anItem {
	if ([delegate respondsToSelector:@selector(fkTabView:didSelectTabViewItem:)]) {
		[delegate fkTabView:self didSelectTabViewItem:anItem];
	}
}

@end