//
//  FKPrintManager.m
//  ShoppingBag
//
//  Created by Eric on 29/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKPrintManager.h"

static FKPrintManager * defaultManager;

@interface FKPrintManager (Private)

- (NSString *)htmlStringWithString:(NSString *)sourceString object:(FKManagedObject *)object;
- (NSString *)processString:(NSString *)sourceString dataType:(NSString *)dataType object:(FKManagedObject *)object;

@end

@implementation FKPrintManager

@synthesize printingOrientation;

+ (FKPrintManager *)defaultManager {
	if (nil == defaultManager) {
		defaultManager = [[FKPrintManager alloc] init];
	}
	
	defaultManager.printingOrientation = NSPortraitOrientation;	
	
	return defaultManager;
}

- (void)printTemplate:(NSString *)templateName withObject:(id)object cssFileName:(NSString *)cssFileName customPaperName:(NSString *)paperName 
{
	NSMutableString * templateString = nil; 
	
	NSString * templatePath = nil;	
	NSString * cssPath = nil; 
	NSString * pngPath = nil; 
	
	// Paper name
	
	customPaperName = paperName;
	
	// ...
	
	templatePath = [[NSBundle mainBundle] pathForResource:templateName ofType:@"html" inDirectory:@"Templates"];
	cssPath = [[NSBundle mainBundle] pathForResource:cssFileName ofType:@"css" inDirectory:@"Templates"];
	//pngPath = [[NSBundle mainBundle] pathForResource:@"LogoT2J" ofType:@"png" inDirectory:@"Templates"];

	//NSLog (@"templateName = %@", templateName);
	//NSLog (@"pngPath = %@", pngPath);
	
	templateString = [[NSString stringWithContentsOfFile:templatePath encoding:nil error:nil] mutableCopy];
	
	// CSS
	
	[templateString replaceOccurrencesOfString:[NSString stringWithFormat:@"./%@.css", cssFileName]
									withString:[NSString stringWithFormat:@"file://%@", cssPath]
									   options:0
										 range:NSMakeRange(0, [templateString length])];
	
	// PNG
	
	[templateString replaceOccurrencesOfString:[NSString stringWithFormat:@"./LogoT2J.png"]
									withString:[NSString stringWithFormat:@"file://%@", pngPath]
									   options:0
										 range:NSMakeRange(0, [templateString length])];
	
	// ...
	
	NSString * htmlString = [self htmlStringWithString:templateString object:object];
	
	// ...
	
	webView = [[WebView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 100.0, 100.0) frameName:@"r" groupName:@"r"];
	webViewWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0.0, 0.0, 100.0, 100.0) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	
	// ...
		
	[webView setFrameLoadDelegate:self];
	[webView setResourceLoadDelegate:self];	
	[webViewWindow setContentView:webView];
	
	//NSLog (@"htmlString = %@", htmlString);	
	
	[[webView mainFrame] loadHTMLString:htmlString baseURL:nil];
}

- (NSString *)htmlStringWithString:(NSString *)sourceString object:(FKManagedObject *)object
{
	NSString * result = sourceString;
	
	// currency:///
	
	result = [self processString:result dataType:@"currency" object:object];	
	
	// date:///
	
	result = [self processString:result dataType:@"date" object:object];
	
	// dateAndHour:///
	
	result = [self processString:result dataType:@"dateAndHour" object:object];
	
	// integer:///
	
	result = [self processString:result dataType:@"integer" object:object];	
	
	// percent:///
	
	result = [self processString:result dataType:@"percent" object:object];
	
	// string:///
	
	result = [self processString:result dataType:@"string" object:object];	
	
	return result;
}

// ...

- (NSString *)processString:(NSString *)sourceString dataType:(NSString *)dataType object:(FKManagedObject *)object
{
	NSFormatter * formatter = nil;
	
	if ( [dataType isEqualToString:@"date"] )
	{
		formatter = [[[NSDateFormatter alloc] init] autorelease];
		
		[(NSDateFormatter *)formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[(NSDateFormatter *)formatter setDateStyle:NSDateFormatterShortStyle];
	}
	else if ( [dataType isEqualToString:@"dateAndHour"] )
	{
		formatter = [[[NSDateFormatter alloc] init] autorelease];
		
		[(NSDateFormatter *)formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[(NSDateFormatter *)formatter setDateStyle:NSDateFormatterShortStyle];
		[(NSDateFormatter *)formatter setTimeStyle:NSDateFormatterShortStyle];
	}
	else if ( [dataType isEqualToString:@"currency"] )
	{
		formatter = [[[FKCurrencyFormatter alloc] init] autorelease];
	}
	else if ( [dataType isEqualToString:@"integer"] )
	{
		formatter = [[[FKIntegerFormatter alloc] init] autorelease];
	}
	else if ( [dataType isEqualToString:@"percent"] )
	{
		formatter = [[[FKPercentFormatter alloc] init] autorelease];
	}
	
	// ...
	
	NSMutableString * htmlString = [NSMutableString string];
	
	NSMutableString * workingString = nil;
	NSString * tempString = nil;
	NSString * keyPath = nil;
	NSString * sortedByKeyPath = nil;
	
	NSString * value = nil;	
	
	NSRange stringRange = NSMakeRange(0, 0);
	NSComparisonResult ascending = NSOrderedAscending;
	SEL sortDescriptorSelector = @selector(compare:);
	
	workingString = [sourceString mutableCopy];
	
	// ...
	
	NSMutableSet * mutableSet = nil;
	NSEnumerator * enumerator = nil;
	FKManagedObject * anObject = nil;
	
	NSString * repeatString = nil;
	
	NSRange repeatRange;
	
	while ( stringRange.location != NSNotFound )
	{
		stringRange = [workingString rangeOfString:[NSString stringWithFormat:@"%@:///", dataType]];
		repeatRange = [workingString rangeOfString:@"<!-- BeginRepeat ON "];
		
		// ...
		
		if ( repeatRange.location < stringRange.location )
		{
			tempString = [workingString substringToIndex:repeatRange.location];
							
			//NSLog (@"append 2");
			
			[htmlString appendString:tempString];

			//NSLog (@" fin append 2");
			
			[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(repeatRange))];
			
			// KeyPath
			
			repeatRange = [workingString rangeOfString:@" | "];
	
			if ( repeatRange.location != NSNotFound )
			{
				keyPath = [workingString substringWithRange:NSMakeRange(0, repeatRange.location)];
				
				[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(repeatRange))];
			}
			
			// Sorted by
				
			repeatRange = [workingString rangeOfString:@"SORTED BY "];		
				
			if ( repeatRange.location != NSNotFound )
			{
				[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(repeatRange))];
					
				repeatRange = [workingString rangeOfString:@" | "];
				
				if ( repeatRange.location != NSNotFound )
				{
					sortedByKeyPath = [workingString substringWithRange:NSMakeRange(0, repeatRange.location)];
					
					[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(repeatRange))];
				}
			}
					
			// Ascending
					
			repeatRange = [workingString rangeOfString:@"ASCENDING "];
					
			if ( repeatRange.location != NSNotFound )
			{
				[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(repeatRange))];				
				
				repeatRange = [workingString rangeOfString:@" | "];
				
				if ( repeatRange.location != NSNotFound )
				{
					ascending = [[workingString substringWithRange:NSMakeRange(0, repeatRange.location)] intValue];
					
					[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(repeatRange))];
				}
			}
			
			// Case insensitive
			
			repeatRange = [workingString rangeOfString:@"CASE INSENSITIVE "];		

			if ( repeatRange.location != NSNotFound )
			{
				[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(repeatRange))];				
				
				repeatRange = [workingString rangeOfString:@" | "];
							
				if ( repeatRange.location != NSNotFound )
				{
					int isCaseInsensitive = [[workingString substringWithRange:NSMakeRange(0, repeatRange.location)] intValue];
					
					sortDescriptorSelector = ( isCaseInsensitive ? @selector(caseInsensitiveCompare:) : @selector(compare:) );
								
					[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(repeatRange))];
				}
			}
			
			// -->
			
			repeatRange = [workingString rangeOfString:@"-->"];		
			
			if ( repeatRange.location != NSNotFound )
			{		
				[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(repeatRange))];
			}
			
			// EndRepeat
		
			repeatRange = [workingString rangeOfString:@"<!-- EndRepeat -->"];
		
			if ( repeatRange.location != NSNotFound )
			{
				repeatString = [workingString substringWithRange:NSMakeRange(0, repeatRange.location)];
			}
						
			mutableSet = [object mutableSetValueForKeyPath:keyPath];
					
			NSMutableArray * objectsArray = [[mutableSet allObjects] mutableCopy];
					
			// ...
			
			NSSortDescriptor * sortDesriptor = nil;
			
			if ( nil != sortedByKeyPath )
			{
				sortDesriptor = [[[NSSortDescriptor alloc] initWithKey:sortedByKeyPath ascending:ascending selector:sortDescriptorSelector] autorelease];
				
				[objectsArray sortUsingDescriptors:[NSArray arrayWithObject:sortDesriptor]];
			}
			
			// ...
					
			
			for ( anObject in objectsArray )
			{	
				//NSLog (@"append 1");
				
				[htmlString appendString:[self htmlStringWithString:repeatString object:anObject]];
				
				//NSLog (@" fin append 1");
			}
			
			[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(repeatRange))];
		}
		else
		{
			if ( stringRange.location != NSNotFound )
			{
				// ...
			
				tempString = [workingString substringToIndex:stringRange.location];
				
				//NSLog (@"append 3 : %@, %@", workingString, tempString);
				
				[htmlString appendString:tempString];

				//NSLog (@" fin append 3");
				
				[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(stringRange))];
			
				// .../
			
				stringRange = [workingString rangeOfString:@"/"];
			
				if ( stringRange.location != NSNotFound )
				{
					keyPath = [workingString substringWithRange:NSMakeRange(0, stringRange.location)];
				
					// ...
				
					value = [object valueForKeyPath:keyPath];
					
					if ( nil != formatter )
					{
						value = [formatter stringForObjectValue:value];
					}
					
					if ( nil == value )
					{
						value = @"";
					}
										
					[htmlString appendString:value];
					
					[workingString deleteCharactersInRange:NSMakeRange(0, NSMaxRange(stringRange))];
				}
			}
			else
			{
				[htmlString appendString:workingString];
			}
		}
	}
	
	return htmlString;
}

// ...

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource
{
	 NSLog (@"    ***** request = %@", request);
 
	 return request;
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	// ...
	
	NSPrintInfo * myPrintInfo = [[NSPrintInfo alloc] initWithDictionary:(NSMutableDictionary*)[[NSPrintInfo sharedPrintInfo]dictionary]];
				
	[myPrintInfo setOrientation:self.printingOrientation];
	[myPrintInfo setBottomMargin:(1*(72.0/2.54))];
	[myPrintInfo setLeftMargin:(1*(72.0/2.54))];
	[myPrintInfo setRightMargin:(1*(72.0/2.54))];
	[myPrintInfo setTopMargin:(1*(72.0/2.54))];
	[myPrintInfo setVerticallyCentered:NO];
	
	if ( [customPaperName isEqualToString:@"A6"] )
	{
		[myPrintInfo setPaperSize:NSMakeSize(10.5*(72.0/2.54),14.8*(72.0/2.54))];
	}
	
	[myPrintInfo setHorizontalPagination:NSFitPagination];
	
	NSMutableDictionary * myPrintInfoDictionary = (NSMutableDictionary*)[myPrintInfo dictionary];
	
	[myPrintInfoDictionary setObject:[NSNumber numberWithInt:1] forKey:NSPrintCopies];
	
	NSPrintOperation * myPrintOperation = [NSPrintOperation printOperationWithView:[[[sender mainFrame] frameView] documentView] printInfo:myPrintInfo];
	
	[myPrintOperation setCanSpawnSeparateThread:YES];
	[myPrintOperation setShowPanels:YES];
	[myPrintOperation runOperationModalForWindow:[NSApp mainWindow] delegate:self didRunSelector:@selector(printOperationDidRun:success:contextInfo:) contextInfo:nil];
	
	//[sender autorelease];
}

- (void)printOperationDidRun:(NSPrintOperation *)printOperation success:(BOOL)success contextInfo:(void *)contextInfo
{
	//[myPrintInfo release];
	
	[webView release];
	[webViewWindow release];
}

@synthesize customPaperName;
@synthesize webViewWindow;
@synthesize webView;
@end
