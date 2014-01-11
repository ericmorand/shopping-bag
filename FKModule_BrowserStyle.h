//
//  FKModule_BrowserStyle.h
//  FKKit
//
//  Created by Eric on 21/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKModule (BrowserStyle)

- (void)finalizeSetupModuleViewUsingBrowserStyle;

- (void)browserWindowCancelButtonAction:(id)sender;
- (void)browserWindowOKButtonAction:(id)sender;

- (id)managedObjectWithValue:(id)value forKey:(NSString *)key;
- (void)showBrowserSheetModalForWindow:(NSWindow *)aWindow selectedObjects:(NSArray **)selectedObjects;
- (void)showBrowserWindowModalForWindow:(NSWindow *)aWindow selectedObjects:(NSArray **)selectedObjects;
- (int)showInexistantObjectAlertSheetWithValue:(NSString *)objectName modalForWindow:(NSWindow *)aWindow;

@end
