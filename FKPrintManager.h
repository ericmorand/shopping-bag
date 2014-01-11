//
//  FKPrintManager.h
//  ShoppingBag
//
//  Created by Eric on 29/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface FKPrintManager : NSObject
{
	NSString *					customPaperName; // Not retained
	
	NSWindow *					webViewWindow;
	WebView *					webView;
	
	NSPrintingOrientation		printingOrientation;
}

@property (assign) NSPrintingOrientation printingOrientation;

+ (FKPrintManager *)defaultManager;

- (void)printTemplate:(NSString *)templateName withObject:(id)object cssFileName:(NSString *)cssFileName customPaperName:(NSString *)paperName;

@property (retain) NSString *		customPaperName;
@property (retain) NSWindow *		webViewWindow;
@property (retain) WebView *		webView;
@end
