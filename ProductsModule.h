//
//  ProductsModule.h
//  ShoppingBag
//
//  Created by alt on 04/11/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "SBModule.h"


@class Brand;
@class Product;
@class ProductCategory;
@class ProviderProduct;

@interface ProductsModule : SBModule
{	
	FKManagedArrayController *		productCategoriesArrayController;
	ProductCategory *				currentProductCategory;
	FKManagedArrayController *		providerProductsArrayController;
	ProviderProduct *				currentProviderProduct;
	
	// editView
		
	IBOutlet NSView *				generalView;
	IBOutlet NSResponder *			generalViewFirstResponder;
	IBOutlet NSResponder *			generalViewLastResponder;
	IBOutlet FKPlusMinusView *		generalViewProductCategoriesPlusMinusView;
	
	IBOutlet NSView *				providersView;
	IBOutlet NSResponder *			providersViewFirstResponder;
	IBOutlet NSResponder *			providersViewLastResponder;	
	IBOutlet FKPlusMinusView *		providersViewProviderProductsPlusMinusView;
	
	IBOutlet NSView *				imagesView;
	IBOutlet NSResponder *			imagesViewFirstResponder;
	IBOutlet NSResponder *			imagesViewLastResponder;	

	IBOutlet NSView *				stockView;
	IBOutlet NSResponder *			stockViewFirstResponder;
	IBOutlet NSResponder *			stockViewLastResponder;	
		
	// ...
	
	IBOutlet NSTextField *			barcodeTextField;
	
	// ...
	
	IBOutlet NSWindow *				stockCorrectionSheet;
	
	// Print Dialog
	
	IBOutlet NSMatrix *				printDialogMatrix;
	IBOutlet NSPopUpButton *		printMatrixPopUpButton;
	
	IBOutlet NSView *				testView;
	IBOutlet WebView *				testWebView;
	
	// Stock correction
	
	int								newStockValue;
	NSString *						newStockReason;
	
	// Sort descriptors
	
	// ...
	
	id								selection;
}

- (IBAction)removeProductCategories:(id)sender;

- (IBAction)openProductCategoriesBrowser:(id)sender;
- (IBAction)openProvidersBrowser:(id)sender;

- (IBAction)openStockCorrectionSheet:(id)sender;
- (IBAction)closeStockCorrectionSheet:(id)sender;

- (IBAction)testAction:(id)sender;

- (NSArray *)providerProductsSortDescriptors;

- (void)setNewStockValue:(int)newInt;

@property (nonatomic, retain) IBOutlet FKManagedArrayController * productCategoriesArrayController;
@property (nonatomic, retain) IBOutlet FKManagedArrayController * providerProductsArrayController;
@property (nonatomic, retain) ProviderProduct *	currentProviderProduct;

@property (retain) NSView *				generalView;
@property (retain) NSResponder *		generalViewFirstResponder;
@property (retain) NSResponder *		generalViewLastResponder;
@property (retain) FKPlusMinusView *	generalViewProductCategoriesPlusMinusView;
@property (retain) NSView *				providersView;
@property (retain) NSResponder *		providersViewFirstResponder;
@property (retain) NSResponder *		providersViewLastResponder;
@property (retain) FKPlusMinusView *	providersViewProviderProductsPlusMinusView;
@property (retain) NSView *				imagesView;
@property (retain) NSResponder *		imagesViewFirstResponder;
@property (retain) NSResponder *		imagesViewLastResponder;
@property (retain) NSView *				stockView;
@property (retain) NSResponder *		stockViewFirstResponder;
@property (retain) NSResponder *		stockViewLastResponder;
@property (retain) NSTextField *		barcodeTextField;
@property (retain) ProductCategory *	currentProductCategory;
@property (retain) NSWindow *			stockCorrectionSheet;
@property (retain) NSMatrix *			printDialogMatrix;
@property (retain) NSPopUpButton *		printMatrixPopUpButton;
@property (retain) NSView *				testView;
@property (retain) WebView *			testWebView;
@property (setter=setNewStockValue:) int	newStockValue;
@property (retain) NSString *			newStockReason;

@property (nonatomic, assign) id		selection;

@property (readonly) Product *			currentProduct;
@property (readonly) NSArray *			stockMovementsSortDescriptors;

@end
