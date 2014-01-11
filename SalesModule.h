//
//  SalesModule.h
//  ShoppingBag
//
//  Created by Eric on 01/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBModule.h"
#import "PaymentMethod.h"
#import "Sale.h"
#import "SaleLine.h"

@class CustomersModule;
@class ProductsModule;

@interface SalesModule : SBModule
{
	NSSplitView *					editModeSplitView;
	
	IBOutlet NSView *				editModeSaleView;
	FKTabView *						editModeTabView;

	// ...
	
	ProductsModule *				productsModule;
	CustomersModule *				customersModule;
	
	// ...
	
	IBOutlet NSView *				generalInformationsView;
	IBOutlet NSResponder *			generalInformationsViewFirstResponder;
	IBOutlet NSResponder *			generalInformationsViewLastResponder;
	
	IBOutlet NSView *				productsView;
	IBOutlet NSResponder *			productsViewFirstResponder;
	IBOutlet NSResponder *			productsViewLastResponder;
	
	FKManagedArrayController *		saleLinesController;
	FKManagedArrayController *		paymentMethodsController;
	PaymentMethod *					currentPaymentMethod;
	NSWindow *						paySheet;
	BOOL							exportsLines;
}

@property (retain) NSSplitView *		editModeSplitView;
@property (retain) NSView *				editModeSaleView;
@property (retain) FKTabView *			editModeTabView;
@property (retain) ProductsModule *		productsModule;
@property (retain) CustomersModule *	customersModule;
@property (retain) NSView *				generalInformationsView;
@property (retain) NSResponder *		generalInformationsViewFirstResponder;
@property (retain) NSResponder *		generalInformationsViewLastResponder;
@property (retain) NSView *				productsView;
@property (retain) NSResponder *		productsViewFirstResponder;
@property (retain) NSResponder *		productsViewLastResponder;

@property (nonatomic, retain) IBOutlet FKManagedArrayController * saleLinesController;
@property (nonatomic, retain) IBOutlet FKManagedArrayController * paymentMethodsController;
@property (nonatomic, assign) PaymentMethod * currentPaymentMethod;
@property (nonatomic, retain) IBOutlet NSWindow * paySheet;
@property (assign) BOOL exportsLines;

@property (readonly) Sale *				currentSale;

- (void)addProductsWithURIs:(NSArray *)productsURIs;
- (void)setCustomerWithURI:(NSURL *)uRI;

- (IBAction)removeCustomer:(id)sender;
- (IBAction)closePaySheet:(id)sender;
- (IBAction)openPaymentMethodsBrowser:(id)sender;

- (void)deleteKeyDown:(id)sender;

@end
