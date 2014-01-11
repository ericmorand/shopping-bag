//
//  Shopping_Bag_AppDelegate.m
//  ShoppingBag
//
//  Created by alt on 04/11/06.
//  Copyright Eric Morand 2006. All rights reserved.
//

#import "ShoppingBagAppDelegate.h"
#import "Inventory.h"
#import "ProductCategory.h"
#import "PaymentMethod.h"
#import "PreferencesController.h"
#import "Product.h"
#import "Provider.h"
#import "ProviderProduct.h"
#import "Sale.h"
#import "Customer.h"
#import "Brand.h"
#import "ProductFamily.h"
#import "SaleLine.h"
#import "StockMovement.h"
#import "TaxRate.h"

#define DAILYTASKS_NAME			@"COMMON TASKS"
#define ADMINTASKS_NAME			@"ADMIN TASKS"
#define FOLDERS_NAME			@"FOLDERS"
#define MAINTOOLBARADDSALEID	@"MainToolbarAddSale"
#define MAINTOOLBAREXPORTID		@"MainToolbarExport"
#define MAINTOOLBARPRINTID		@"MainToolbarPrint"

@interface ShoppingBagAppDelegate (Private)

- (FKSourceListSmartGroup *)defaultSmartGroupForModuleNamed:(NSString *)moduleName;

@end

@implementation ShoppingBagAppDelegate

@synthesize preferencesController;
@synthesize progressWindow;
@synthesize progressIndicator;
@synthesize progressMessageTextField;

- (id)init {
	self = [super init];
	
	if (nil != self) {
		[NSDecimalNumber setDefaultBehavior:[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:5 raiseOnExactness:YES raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES]];
		[self setPreferencesController:[[[PreferencesController alloc] init] autorelease]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:NSApplicationDidBecomeActiveNotification object:nil];
	}
	
	return self;
}

#pragma mark -
#pragma mark KVO
//
//- (void)computeExportSalesPeriod {
//	NSCalendar * curCalendar = nil;
//	NSDateComponents * dateComp = nil;
//	NSDate * today = nil;
//	
//	today = [NSDate date];
//	curCalendar = [NSCalendar currentCalendar];
//	
//	NSDate * tmpDate = nil;
//	NSTimeInterval timeInterval = 0;
//	
//	switch (exportSalesSelectedPeriod) {
//		case 0: { // Today
//			self.exportSalesStartDate = today;
//			self.exportSalesEndDate = exportSalesStartDate;
//			
//			break;
//		}
//		case 1: { // Yesterday
//			dateComp = [[[NSDateComponents alloc] init] autorelease];
//			
//			[dateComp setDay:-1];
//			
//			self.exportSalesStartDate = [curCalendar dateByAddingComponents:dateComp toDate:today options:0];
//			self.exportSalesEndDate = exportSalesStartDate;
//			
//			break;
//		}
//		case 2: { // This week
//			if ([curCalendar rangeOfUnit:NSWeekCalendarUnit startDate:&tmpDate interval:&timeInterval forDate:today]) {
//				self.exportSalesStartDate = tmpDate;
//				self.exportSalesEndDate = [exportSalesStartDate addTimeInterval:(timeInterval - 1)];
//			}
//			
//			break;
//		}
//		case 3: { // Last week
//			dateComp = [[[NSDateComponents alloc] init] autorelease];
//			
//			[dateComp setWeek:-1];
//			
//			today = [curCalendar dateByAddingComponents:dateComp toDate:today options:0];
//			
//			if ([curCalendar rangeOfUnit:NSWeekCalendarUnit startDate:&tmpDate interval:&timeInterval forDate:today]) {
//				self.exportSalesStartDate = tmpDate;
//				self.exportSalesEndDate = [exportSalesStartDate addTimeInterval:(timeInterval - 1)];
//			}
//			
//			break;
//		}
//		case 4: { // This month
//			if ([curCalendar rangeOfUnit:NSMonthCalendarUnit startDate:&tmpDate interval:&timeInterval forDate:today]) {
//				self.exportSalesStartDate = tmpDate;
//				self.exportSalesEndDate = [exportSalesStartDate addTimeInterval:(timeInterval - 1)];
//			}
//			
//			break;
//		}
//		case 5: { // This month
//			dateComp = [[[NSDateComponents alloc] init] autorelease];
//			
//			[dateComp setMonth:-1];
//			
//			today = [curCalendar dateByAddingComponents:dateComp toDate:today options:0];
//			
//			if ([curCalendar rangeOfUnit:NSMonthCalendarUnit startDate:&tmpDate interval:&timeInterval forDate:today]) {
//				self.exportSalesStartDate = tmpDate;
//				self.exportSalesEndDate = [exportSalesStartDate addTimeInterval:(timeInterval - 1)];
//			}
//			
//			break;
//		}
//		case 8: { // This year
//			if ([curCalendar rangeOfUnit:NSYearCalendarUnit startDate:&tmpDate interval:&timeInterval forDate:today]) {
//				self.exportSalesStartDate = tmpDate;
//				self.exportSalesEndDate = [exportSalesStartDate addTimeInterval:(timeInterval - 1)];
//			}
//			
//			break;
//		}
//		case 9: { // Last year
//			dateComp = [[[NSDateComponents alloc] init] autorelease];
//			
//			[dateComp setYear:-1];
//			
//			today = [curCalendar dateByAddingComponents:dateComp toDate:today options:0];
//			
//			if ([curCalendar rangeOfUnit:NSYearCalendarUnit startDate:&tmpDate interval:&timeInterval forDate:today]) {
//				self.exportSalesStartDate = tmpDate;
//				self.exportSalesEndDate = [exportSalesStartDate addTimeInterval:(timeInterval - 1)];
//			}
//			
//			break;
//		}
//		default:
//			break;
//	}
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//	if ([keyPath isEqualToString:@"exportSalesSelectedPeriod"]) {
//		[self computeExportSalesPeriod];
//		[self toggleExportSalesCustomPeriodBoxVisibility:YES];
//	}
//}

- (void)awakeFromNib
{
	[super awakeFromNib];
		
	[[self window] setContentBorderThickness:32.0 forEdge:NSMinYEdge];	
	
	// ...
	
	Inventory * runningInventory = nil;
	NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"status = %@", [NSNumber numberWithInt:InventoryStatusRunning]];
	NSArray * results = nil;
	
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Inventory" inManagedObjectContext:[self managedObjectContext]]];
	[fetchRequest setPredicate:predicate];
	
	results = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
	
	if ([results count] > 0) {
		runningInventory = [results objectAtIndex:0];
	}
		
	[Inventory setRunningInventory:runningInventory];
		
	// **********
	// sourceList
	// **********
	
	[sourceList expandItem:[sourceList itemAtRow:0]];
	[sourceList expandItem:[sourceList itemAtRow:4]];
	[sourceList expandItem:[sourceList itemAtRow:12]];
	[sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
}

//- (void)toggleExportSalesCustomPeriodBoxVisibility:(BOOL)animate {
//	if ((exportSalesSelectedPeriod == 99 && [exportSalesCustomPeriodBox isHidden]) ||
//		(exportSalesSelectedPeriod != 99 && ![exportSalesCustomPeriodBox isHidden])) {
//		NSRect windowFrame = [exportSalesWindow frame];
//		
//		float boxHeight = [exportSalesCustomPeriodBox frame].size.height;
//		
//		if (exportSalesSelectedPeriod == 99) {
//			windowFrame.origin.y -= boxHeight;
//			windowFrame.size.height += boxHeight;
//		}
//		else {
//			windowFrame.origin.y += boxHeight;
//			windowFrame.size.height -= boxHeight;
//			
//			[exportSalesCustomPeriodBox setHidden:YES];
//		}
//		
//		[exportSalesWindow setFrame:windowFrame display:YES animate:animate];
//		
//		if (exportSalesSelectedPeriod == 99) {
//			[exportSalesCustomPeriodBox setHidden:NO];
//			[exportSalesWindow makeFirstResponder:exportSalesStartDatePicker];
//		}
//	}
//}

- (void)dealloc
{
	self.preferencesController = nil;
	
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// TEST
	
	NSFetchRequest *fr = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *en = [NSEntityDescription entityForName:@"StockMovement" inManagedObjectContext:self.managedObjectContext];
	NSPredicate *pr = [NSPredicate predicateWithFormat:@"saleLine.sale.saleNumber == nil AND reason BEGINSWITH %@", @"Vente"];
	
	[fr setEntity:en];
	[fr setPredicate:pr];
	
	NSArray *results = [self.managedObjectContext executeFetchRequest:fr error:nil];
	NSString *reason = nil;
	NSString *saleNumber = nil;
	
	NSArray *sales = nil;
	Sale *sale = nil;
	SaleLine *saleLine = nil;
	Product *product = nil;
	
	for (StockMovement *sm in results) {
		reason = sm.reason;
		product = sm.product;
		
		// ...
		
		saleLine = sm.saleLine;
		
		Product *saleLineProduct = nil;
		BOOL ex = false;
		
		@try {
			saleLineProduct = saleLine.product;
		}
		@catch (NSException * e) {	
			ex = true;
		}
		@finally {
		}
		
		if (ex || saleLine == NULL) {
			[self.managedObjectContext deleteObject:saleLine];
			
			SaleLine *newSaleLine = [NSEntityDescription insertNewObjectForEntityForName:@"SaleLine" inManagedObjectContext:self.managedObjectContext];
			
			newSaleLine.quantity = [NSDecimalNumber decimalNumberWithDecimal:[sm.quantity decimalValue]];
			newSaleLine.quantity = [newSaleLine.quantity decimalNumberByMultiplyingBy:(NSDecimalNumber *)[NSDecimalNumber numberWithInt:-1]];
			newSaleLine.product = product;
			newSaleLine.productBasePriceHT = product.unitPriceHT;
			newSaleLine.productBasePriceTTC = product.unitPriceTTC;
			newSaleLine.productDiscountPriceHT = newSaleLine.productBasePriceHT;
			newSaleLine.productDiscountPriceTTC = newSaleLine.productBasePriceTTC;
			newSaleLine.productTaxRate = product.taxRate.rate;
			newSaleLine.stockMovement = sm;
			
			[newSaleLine computeLineTotals];
			
			saleLine = newSaleLine;
		}
				
		// ...
				
		saleNumber = [reason substringFromIndex:8];
		
		fr = [[[NSFetchRequest alloc] init] autorelease];
		en = [NSEntityDescription entityForName:@"Sale" inManagedObjectContext:self.managedObjectContext];
		pr = [NSPredicate predicateWithFormat:@"saleNumber = %@", saleNumber];
		
		[fr setEntity:en];
		[fr setPredicate:pr];
		
		sales = [self.managedObjectContext executeFetchRequest:fr error:nil];
		
		if ([sales count] > 0) {
			sale = [sales objectAtIndex:0];
		}
		else {			
			sale = [NSEntityDescription insertNewObjectForEntityForName:@"Sale" inManagedObjectContext:self.managedObjectContext];
			sale.saleNumber = saleNumber;
			sale.date = sm.date;
		}
		
		[sale addSaleLine:saleLine];
		
		[sale computeTotalHTAndTTC];
		[sale computeDiscountedTotalHTAndTTC];
		[sale computeTotalTax];
	}
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification {	
	[self showWindow:nil];
}

#pragma mark -
#pragma mark GETTERS

- (NSArray *)defaultSourceListItems {
	NSMutableArray * tmpArray = [NSMutableArray array];
	FKSourceListGroup * group = nil;
		
	// ****************
	// Gestion courante
	// ****************
	
	group = [[[FKSourceListGroup alloc] init] autorelease];
	
	group.name = NSLocalizedString(DAILYTASKS_NAME, @"");
	
	[tmpArray addObject:group];	
	
	[group.children addObject:[self defaultSmartGroupForModuleNamed:@"Sales" ]];
	[group.children addObject:[self defaultSmartGroupForModuleNamed:@"Products"]];
	[group.children addObject:[self defaultSmartGroupForModuleNamed:@"Customers" ]];
		
	// **************
	// Administration
	// **************
	
	group = [[[FKSourceListGroup alloc] init] autorelease];
	
	group.name = NSLocalizedString(ADMINTASKS_NAME, @"");
	
	[tmpArray addObject:group];	
	
	[group.children addObject:[self defaultSmartGroupForModuleNamed:@"Brands"]];
	[group.children addObject:[self defaultSmartGroupForModuleNamed:@"Inventories"]];
	[group.children addObject:[self defaultSmartGroupForModuleNamed:@"PaymentMethods"]];
	[group.children addObject:[self defaultSmartGroupForModuleNamed:@"ProductCategories"]];
	[group.children addObject:[self defaultSmartGroupForModuleNamed:@"ProductFamilies"]];
	[group.children addObject:[self defaultSmartGroupForModuleNamed:@"Providers"]];	
	[group.children addObject:[self defaultSmartGroupForModuleNamed:@"TaxRates"]];
		
	[group.children sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease]]];

	// ********
	// Dossiers
	// ********
	
	group = [[[FKSourceListGroup alloc] init] autorelease];
	
	group.name = NSLocalizedString(FOLDERS_NAME, @"");
	
	[tmpArray addObject:group];	
	
	FKSourceListSmartGroup * smartGroup = [[[FKSourceListSmartGroup alloc] init] autorelease];
	NSDate * today = [NSDate date];
	
	smartGroup.name = @"Ventes du jour";
	smartGroup.moduleName = @"Sales";
	smartGroup.predicate = [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObjects:[today firstSecond], [today lastSecond], nil]];
	smartGroup.icon = [NSImage imageNamed:@"NSFolderSmart"];
	
	[group.children addObject:smartGroup];
	
	NSDate * yesterday = [NSDate yesterday];	
	
	smartGroup = [[[FKSourceListSmartGroup alloc] init] autorelease];	
	smartGroup.name = @"Ventes de la veille";
	smartGroup.moduleName = @"Sales";
	smartGroup.predicate = [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObjects:[yesterday firstSecond], [yesterday lastSecond], nil]];
	smartGroup.icon = [NSImage imageNamed:@"NSFolderSmart"];
	
	[group.children addObject:smartGroup];
	
	// Ventes de la semaine
	
	NSCalendar * cal = [NSCalendar currentCalendar];
	
	NSDate * firstDayOfWeek = nil;
	NSDate * lastDayOfWeek = nil;
	NSTimeInterval ti = 0;
	
	[cal rangeOfUnit:NSWeekCalendarUnit startDate:&firstDayOfWeek interval:&ti forDate:today];
	
	lastDayOfWeek = [firstDayOfWeek addTimeInterval:ti];
	lastDayOfWeek = [lastDayOfWeek addTimeInterval:-1];

	smartGroup = [[[FKSourceListSmartGroup alloc] init] autorelease];	
	smartGroup.name = NSLocalizedString(@"CurrentWeekSales", NULL);
	smartGroup.moduleName = @"Sales";
	smartGroup.predicate = [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObjects:[firstDayOfWeek firstSecond], [lastDayOfWeek lastSecond], nil]];
	smartGroup.icon = [NSImage imageNamed:@"NSFolderSmart"];
	
	[group.children addObject:smartGroup];
	
	// Ventes de la semaine pr残仕ente
	
	firstDayOfWeek = [firstDayOfWeek addTimeInterval:-1];
	
	[cal rangeOfUnit:NSMonthCalendarUnit startDate:&firstDayOfWeek interval:&ti forDate:firstDayOfWeek];
	
	lastDayOfWeek = [firstDayOfWeek addTimeInterval:ti];
	lastDayOfWeek = [lastDayOfWeek addTimeInterval:-1];
	
	smartGroup = [[[FKSourceListSmartGroup alloc] init] autorelease];	
	smartGroup.name = NSLocalizedString(@"PreviousWeekSales", NULL);
	smartGroup.moduleName = @"Sales";
	smartGroup.predicate = [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObjects:[firstDayOfWeek firstSecond], [lastDayOfWeek lastSecond], nil]];
	smartGroup.icon = [NSImage imageNamed:@"NSFolderSmart"];
	
	[group.children addObject:smartGroup];	
	
	// Ventes du mois
	
	NSDate * firstDayOfMonth = nil;
	NSDate * lastDayOfMonth = nil;
	
	[cal rangeOfUnit:NSMonthCalendarUnit startDate:&firstDayOfMonth interval:&ti forDate:today];
	
	lastDayOfMonth = [firstDayOfMonth addTimeInterval:ti];
	lastDayOfMonth = [lastDayOfMonth addTimeInterval:-1];
	
	smartGroup = [[[FKSourceListSmartGroup alloc] init] autorelease];	
	smartGroup.name = NSLocalizedString(@"CurrentMonthSales", NULL);
	smartGroup.moduleName = @"Sales";
	smartGroup.predicate = [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObjects:[firstDayOfMonth firstSecond], [lastDayOfMonth lastSecond], nil]];
	smartGroup.icon = [NSImage imageNamed:@"NSFolderSmart"];
	
	[group.children addObject:smartGroup];
	
	// Ventes du mois pr残仕ent
	
	firstDayOfMonth = [firstDayOfMonth addTimeInterval:-1];
	
	[cal rangeOfUnit:NSMonthCalendarUnit startDate:&firstDayOfMonth interval:&ti forDate:firstDayOfMonth];
	
	lastDayOfMonth = [firstDayOfMonth addTimeInterval:ti];
	lastDayOfMonth = [lastDayOfMonth addTimeInterval:-1];
	
	smartGroup = [[[FKSourceListSmartGroup alloc] init] autorelease];	
	smartGroup.name = NSLocalizedString(@"PreviousMonthSales", NULL);
	smartGroup.moduleName = @"Sales";
	smartGroup.predicate = [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObjects:[firstDayOfMonth firstSecond], [lastDayOfMonth lastSecond], nil]];
	smartGroup.icon = [NSImage imageNamed:@"NSFolderSmart"];
	
	[group.children addObject:smartGroup];	
	
	// Ventes de l'ann仔
	
	NSDate * firstDayOfYear = nil;
	NSDate * lastDayOfYear = nil;
	
	[cal rangeOfUnit:NSYearCalendarUnit startDate:&firstDayOfYear interval:&ti forDate:today];
	
	lastDayOfYear = [firstDayOfYear addTimeInterval:ti];
	lastDayOfYear = [lastDayOfYear addTimeInterval:-1];
	
	smartGroup = [[[FKSourceListSmartGroup alloc] init] autorelease];	
	smartGroup.name = NSLocalizedString(@"CurrentYearSales", NULL);
	smartGroup.moduleName = @"Sales";
	smartGroup.predicate = [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObjects:[firstDayOfYear firstSecond], [lastDayOfYear lastSecond], nil]];
	smartGroup.icon = [NSImage imageNamed:@"NSFolderSmart"];
	
	[group.children addObject:smartGroup];
	
	// Ventes de l'ann仔 pr残仕ente

	firstDayOfYear = [firstDayOfYear addTimeInterval:-1];

	[cal rangeOfUnit:NSYearCalendarUnit startDate:&firstDayOfYear interval:&ti forDate:firstDayOfYear];

	lastDayOfYear = [firstDayOfYear addTimeInterval:ti];
	lastDayOfYear = [lastDayOfYear addTimeInterval:-1];
	
	smartGroup = [[[FKSourceListSmartGroup alloc] init] autorelease];	
	smartGroup.name = NSLocalizedString(@"PreviousYearSales", NULL);
	smartGroup.moduleName = @"Sales";
	smartGroup.predicate = [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObjects:[firstDayOfYear firstSecond], [lastDayOfYear lastSecond], nil]];
	smartGroup.icon = [NSImage imageNamed:@"NSFolderSmart"];
	
	[group.children addObject:smartGroup];
	
	// sorting
	
	//[group.children sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease]]];
	
	return [NSArray arrayWithArray:tmpArray];
}

- (FKSourceListSmartGroup *)defaultSmartGroupForModuleNamed:(NSString *)moduleName {
	FKSourceListSmartGroup * smartGroup = [[[FKSourceListSmartGroup alloc] init] autorelease];
	
	smartGroup.name = NSLocalizedString(moduleName, @"");
	smartGroup.moduleName = moduleName;
	smartGroup.predicate = [NSPredicate predicateWithValue:TRUE];
	smartGroup.icon = [NSImage imageNamed:moduleName];
	
	return smartGroup;
}

#pragma mark -
#pragma mark SETTERS

- (void)setPreferencesController:(PreferencesController *)aController
{
	if ( aController != preferencesController )
	{
		[preferencesController release];
		preferencesController = [aController retain];
	}
}

- (NSTreeNode *)defaultSystemSmartGroupNodeAtIndex:(int)index {
	FKSourceListSmartGroup * smartGroup = [[[FKSourceListSmartGroup alloc] init] autorelease];
	
	switch (index)
	{
		case 0:
		{			
			smartGroup.name = NSLocalizedString(@"Products", @"");
			smartGroup.moduleName = @"Products";
			smartGroup.predicate = [NSPredicate predicateWithValue:YES];
			
			break;
		}
		case 1:
		{
			smartGroup.name = NSLocalizedString(@"Sales", @"");
			smartGroup.moduleName = @"Sales";
			smartGroup.predicate = [NSPredicate predicateWithValue:YES];
			
			break;
		}
		case 2:
		{
			smartGroup.name = NSLocalizedString(@"Customers", @"");
			smartGroup.moduleName = @"Customers";
			smartGroup.predicate = [NSPredicate predicateWithValue:YES];
			
			break;
		}
		default:
		{
			break;
		}
	}
	
	return [NSTreeNode treeNodeWithRepresentedObject:smartGroup];
}

#pragma mark -
#pragma mark ACTIONS

- (IBAction)openPreferences:(id)sender
{
	[preferencesController showWindow:nil];
}

- (IBAction)printDailyZ:(id)sender;
{
	[self showWindow:sender];
	
	FKPrintManager * printManager = [FKPrintManager defaultManager];
	
	printManager.printingOrientation = NSPortraitOrientation;	
	
	NSMutableDictionary * saleLinesDictionary = [NSMutableDictionary dictionary];
	NSDecimalNumber * totalTTC = [NSDecimalNumber zero];
	
	// ...
	
	NSManagedObjectContext * context = [self managedObjectContext];
	NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	// ...
	
	NSCalendarDate * todayDate = [NSCalendarDate calendarDate];
	NSCalendarDate * beginDate = [NSCalendarDate dateWithYear:[todayDate yearOfCommonEra] month:[todayDate monthOfYear] day:[todayDate dayOfMonth] hour:0 minute:0 second:0 timeZone:[todayDate timeZone]];
	NSCalendarDate * endDate = [NSCalendarDate dateWithYear:[todayDate yearOfCommonEra] month:[todayDate monthOfYear] day:([todayDate dayOfMonth] + 1) hour:0 minute:0 second:0 timeZone:[todayDate timeZone]];
	
	// ...
	
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"paymentMethod != nil AND (date >= %@ AND date < %@)", beginDate, endDate];
	NSEntityDescription * entity = [NSEntityDescription entityForName:@"Sale" inManagedObjectContext:context];
	NSArray * results = nil;
	
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:predicate];
	
	results = [context executeFetchRequest:fetchRequest error:nil];
	
	NSMutableArray * mutableArray = [NSMutableArray array];
	Sale * aSale = nil;
	
	NSMutableSet * saleLines = nil;
	
	for ( aSale in results )
	{
		saleLines = [aSale mutableSetValueForKey:@"saleLines"];
		
		[mutableArray addObjectsFromArray:[saleLines allObjects]];
		
		if ( nil != [aSale discountedTotalHT] )
		{
			totalTTC = [totalTTC decimalNumberByAdding:[aSale discountedTotalTTC]];
		}
	}
	
	[saleLinesDictionary setObject:mutableArray forKey:@"saleLines"];
	[saleLinesDictionary setObject:[NSDate date] forKey:@"date"];
	[saleLinesDictionary setObject:totalTTC forKey:@"totalTTC"];
	
	// ...
	
	[printManager printTemplate:@"DailyZ" withObject:saleLinesDictionary cssFileName:@"ShoppingBag" customPaperName:nil];
}

- (IBAction)printStockValue:(id)sender
{
	[self showWindow:sender];
	
	FKPrintManager * printManager = [FKPrintManager defaultManager];
	
	printManager.printingOrientation = NSPortraitOrientation;	
	
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	
	NSMutableDictionary * providerDictionary = nil;
	NSMutableArray * providerDictionariesArray = [NSMutableArray array];
	
	NSDecimalNumber * providerStockValue = nil;
	NSDecimalNumber * totalStockValue = [NSDecimalNumber zero];
	
	NSManagedObjectContext * context = [self managedObjectContext];
	NSFetchRequest * fetchRequest = nil;
	NSEntityDescription * entity = nil;
	
	NSMutableArray * providersArray = nil;
	Provider * aProvider = nil;

	NSEnumerator * productsEnumerator = nil;
	Product * aProduct = nil;	
	
	// ...
	
	fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	entity = [NSEntityDescription entityForName:@"Provider" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
	providersArray = [[[context executeFetchRequest:fetchRequest error:nil] mutableCopy] autorelease];
	
	// ...
	
	
	for ( aProvider in providersArray )
	{
		providerStockValue = [NSDecimalNumber zero];
		providerDictionary = [NSMutableDictionary dictionary];
		
		productsEnumerator = [[aProvider products] objectEnumerator];
		
		while ( aProduct = [productsEnumerator nextObject] )
		{
			providerStockValue = [providerStockValue decimalNumberByAdding:[aProduct stockValueForProvider:aProvider]];
		}
		
		[providerDictionary setObject:[aProvider name] forKey:@"providerName"];
		[providerDictionary setObject:providerStockValue forKey:@"providerStockValue"];
		
		[providerDictionariesArray addObject:providerDictionary];
		
		// ...
		
		totalStockValue = [totalStockValue decimalNumberByAdding:providerStockValue];
	}
	
	
	
	
	[dictionary setObject:[NSDate date] forKey:@"date"];
	[dictionary setObject:providerDictionariesArray forKey:@"providers"];
	[dictionary setObject:totalStockValue forKey:@"totalStockValue"];
	
	// ...
	
	[printManager printTemplate:@"StockValue" withObject:dictionary cssFileName:@"ShoppingBag" customPaperName:nil];
}

- (IBAction)export:(id)sender {
	[currentModule export:sender];
}

- (IBAction)exportDailyZ:(id)sender;
{
	[self showWindow:sender];
	
	NSSavePanel * savePanel = [NSSavePanel savePanel];

	[savePanel setRequiredFileType:@"csv"];
	[savePanel beginSheetForDirectory:nil
								 file:nil
					   modalForWindow:[NSApp mainWindow]
						modalDelegate:self
					   didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:)
						  contextInfo:nil];
}

- (IBAction)exportSaleLines:(id)sender {
	[self showWindow:sender];
	
	NSSavePanel * savePanel = [NSSavePanel savePanel];
	
	[savePanel setRequiredFileType:@"csv"];
	[savePanel beginSheetForDirectory:nil
								 file:nil
					   modalForWindow:[NSApp mainWindow]
						modalDelegate:self
					   didEndSelector:@selector(exportSaleLinesPanelDidEnd:returnCode:contextInfo:)
						  contextInfo:nil];
}

- (NSString *)csvStringForValue:(id)object {
	return [self csvStringForValue:object formatter:nil];
}

- (NSString *)csvStringForValue:(id)object formatter:(NSFormatter *)formatter {
	NSString * result = nil;
	NSString * tmpStr = nil;
	
	tmpStr = (object != nil ? object : ([object isKindOfClass:[NSDecimalNumber class]] ? [NSDecimalNumber zero] : [NSString string]));
	
	if (nil != formatter) {
		tmpStr = [formatter stringForObjectValue:tmpStr];
	}
	
	result = [NSString stringWithFormat:@"\"%@\"", tmpStr];
	
	return result;
}

- (void)exportSaleLinesPanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo {
	if (returnCode == NSOKButton) {				
		NSMutableArray * csvArray = nil;
		NSMutableString * csvString = [NSMutableString string];
		NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		FKDecimalFormatter * decimalFormatter = [[[FKDecimalFormatter alloc] init] autorelease];
		FKPercentFormatter * percentFormatter = [[[FKPercentFormatter alloc] init] autorelease];
		
		[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];	
		
		// En-tete
		
		csvArray = [NSMutableArray array];
		
		[csvArray addObject:NSLocalizedString(@"SaleNumber", @"")];
		[csvArray addObject:NSLocalizedString(@"Date", @"")];
		[csvArray addObject:NSLocalizedString(@"Customer", @"")];
		[csvArray addObject:NSLocalizedString(@"Product", @"")];
		[csvArray addObject:NSLocalizedString(@"Reference", @"")];
		[csvArray addObject:NSLocalizedString(@"Brand", @"")];
		[csvArray addObject:NSLocalizedString(@"ProductFamily", @"")];
		[csvArray addObject:NSLocalizedString(@"PrimaryProvider", @"")];
		[csvArray addObject:NSLocalizedString(@"Quantity", @"")];
		[csvArray addObject:NSLocalizedString(@"DiscountRate", @"")];
		[csvArray addObject:NSLocalizedString(@"TaxRate", @"")];
		[csvArray addObject:NSLocalizedString(@"TotalTTC", @"")];
		[csvArray addObject:NSLocalizedString(@"PaymentMethod", @"")];
		
		[csvString appendFormat:@"%@\n", [csvArray componentsJoinedByString:@";"]];
		
		// ...
		
		NSString * saleNumberStr = nil;
		NSString * dateStr = nil;
		NSString * customerStr = nil;
		NSString * discountStr = nil;
		NSString * totalStr = nil;
		NSString * paymentMethodStr = nil;
		
		
		NSManagedObjectContext * context = [self managedObjectContext];
		NSFetchRequest * fetchRequest = nil;
		NSEntityDescription * entity = nil;
		
		NSMutableArray * saleLinesArray = nil;
		SaleLine * aSaleLine = nil;
		Sale * aSale = nil;		
		// ...
		
		fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		entity = [NSEntityDescription entityForName:@"SaleLine" inManagedObjectContext:context];
		
		[fetchRequest setEntity:entity];
		
		saleLinesArray = [[[context executeFetchRequest:fetchRequest error:nil] mutableCopy] autorelease];
		
		for (aSaleLine in saleLinesArray) {
			
			if (aSale = aSaleLine.sale) {
				saleNumberStr = [self csvStringForValue:aSale.saleNumber];
				dateStr = [self csvStringForValue:aSale.date formatter:dateFormatter];
				customerStr = [self csvStringForValue:aSale.customer.name];
				discountStr = [self csvStringForValue:aSale.discountRate formatter:percentFormatter];
				totalStr = [self csvStringForValue:aSale.discountedTotalTTC formatter:decimalFormatter];
				paymentMethodStr = [self csvStringForValue:aSale.paymentMethod.name];
			}
			else {
				saleNumberStr = @"";
				dateStr = @"";
				customerStr = @"";
				discountStr = @"";
				totalStr = @"";
				paymentMethodStr = @"";
			}
			
			csvArray = [NSMutableArray array];
					
			[csvArray addObject:saleNumberStr];
			[csvArray addObject:dateStr];
			[csvArray addObject:customerStr];
			[csvArray addObject:[self csvStringForValue:aSaleLine.product.name]];
			[csvArray addObject:[self csvStringForValue:aSaleLine.product.reference]];
			[csvArray addObject:[self csvStringForValue:aSaleLine.product.brand.name]];
			[csvArray addObject:[self csvStringForValue:aSaleLine.product.productFamily.name]];
			[csvArray addObject:[self csvStringForValue:aSaleLine.product.primaryProvider.name]];
			[csvArray addObject:[self csvStringForValue:aSaleLine.quantity]];
			[csvArray addObject:[self csvStringForValue:aSaleLine.discountRate formatter:percentFormatter]];
			[csvArray addObject:[self csvStringForValue:aSaleLine.productTaxRate formatter:percentFormatter]];
			[csvArray addObject:[self csvStringForValue:aSaleLine.lineTotalTTC formatter:decimalFormatter]];
			[csvArray addObject:paymentMethodStr];
					
			[csvString appendFormat:@"%@\n", [csvArray componentsJoinedByString:@";"]];
		}
		
		NSError * error = nil;
		
		if (![csvString writeToFile:[sheet filename] atomically:YES encoding:NSUnicodeStringEncoding error:&error]) {
			[self presentError:error];
		}
	}
}

- (IBAction)import:(id)sender
{
	[self showWindow:sender];
	
	NSOpenPanel * openPanel = [[[NSOpenPanel alloc] init] autorelease];
	
	[openPanel beginSheetForDirectory:nil
								 file:nil
								types:[NSArray arrayWithObject:@"csv"]
						modalForWindow:[NSApp mainWindow]
							modalDelegate:self 
					   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
						  contextInfo:nil];
	
	if ( [NSApp runModalForWindow:openPanel] == NSOKButton )
	{
	
	// ...
	
	[NSApp beginSheet:progressWindow
	   modalForWindow:[NSApp mainWindow]
		modalDelegate:self
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
	
	// ...
	
	NSLog (@" Debut importation...");
	
	NSArray * URLs = [openPanel URLs];
	NSURL * anURL = nil;
	NSString * fileString = nil;
	
	NSError * encodingError = nil;
		
	for ( anURL in URLs )
	{
		fileString = [NSString stringWithContentsOfFile:[anURL path] encoding:NSMacOSRomanStringEncoding error:&encodingError];
		
		NSArray * linesArray = [fileString componentsSeparatedByString:@"\n"];
		NSEnumerator * linesEnumerator = [linesArray objectEnumerator];
		NSString * lineAsString = nil;
		NSArray * aLine = nil;
		
		[progressIndicator setMaxValue:[linesArray count]];
		
		while ( lineAsString = [linesEnumerator nextObject] )
		{
			// On remplace les virgules situees entre deux " par des points
			
			NSMutableString * finalString = [NSMutableString stringWithString:lineAsString];
			
			NSScanner * aScanner = [NSScanner scannerWithString:finalString];
			NSString * valueString = nil;
			unsigned beginIndex = 0;
			unsigned endIndex = 0;
			unsigned currentIndex = 0;
			
			
			while ( ![aScanner isAtEnd] )
			{
				[aScanner scanUpToString:@"\"" intoString:nil];
			
				beginIndex = [aScanner scanLocation];
			
				if ( ![aScanner isAtEnd] )
				{
				
					currentIndex = beginIndex + 1;
				
					[aScanner setScanLocation:currentIndex];
				}
				
				[aScanner scanUpToString:@"\"" intoString:&valueString];
			
				//NSMutableString * mutableString = [NSMutableString stringWithString:valueString];
				
				endIndex = [aScanner scanLocation];
			
				if ( ![aScanner isAtEnd] )
				{
					currentIndex = endIndex + 1;
					
					[aScanner setScanLocation:currentIndex];
				}
				
				[finalString replaceOccurrencesOfString:@"," withString:@"." options:1 range:NSMakeRange(beginIndex, (endIndex - beginIndex))];
				

			}
			
			//NSLog (@"finalString = %@", finalString);
			
			// ...
			
			aLine = [finalString componentsSeparatedByString:@","];
			
			Product * importedProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:[self managedObjectContext]];

			NSString * reference = [[aLine objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
			
			[importedProduct setReference:reference];
			
			NSString * defaultName = [[aLine objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
			NSString * productName = defaultName;
			
			unsigned index = 0;
			
			NSError * error = nil;
			
			while ( ![importedProduct validateValue:&productName forKey:@"name" error:&error] )
			{		
				index++;
				
				productName = [defaultName stringByAppendingFormat:@" (%d)", index];
			}
			
			[importedProduct setName:productName];
						
			// Fournisseur
			
			NSString * providerName = [[aLine objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
			
			NSString * providerPriceHTString = [[aLine objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
			NSString * unitPriceTTCString = [[aLine objectAtIndex:7] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
			NSString * taxRateString = [[aLine objectAtIndex:10] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
			
			NSDecimalNumber * providerPriceHT = [NSDecimalNumber zero];
			
			if ( ![providerPriceHTString isEqualToString:@""] )
			{	
				providerPriceHT = [NSDecimalNumber decimalNumberWithString:providerPriceHTString];
			}
			
			NSDecimalNumber * unitPriceTTC = [NSDecimalNumber zero];
			
			if ( ![unitPriceTTCString isEqualToString:@""] )
			{
				unitPriceTTC = [NSDecimalNumber decimalNumberWithString:unitPriceTTCString];
			}
			
			NSDecimalNumber * taxRate = [NSDecimalNumber zero];
			
			if ( ![taxRateString isEqualToString:@""] )
			{
				taxRate = [NSDecimalNumber decimalNumberWithString:taxRateString];
				taxRate = [taxRate decimalNumberByDividingBy:[NSDecimalNumber hundred]];
			}
			
			//NSLog (@"On cherche providerName (%@)...", providerName);
			
			Provider * provider = nil; // [[FKMOCIndexesManager defaultManager] objectForEntityForName:@"Provider" withValue:providerName forIndexedKey:@"name"];
			
			//NSLog (@"...et on le trouve (ou pas !) : %@", [provider name]);
			
			if ( nil == provider )
			{
				provider = [NSEntityDescription insertNewObjectForEntityForName:@"Provider" inManagedObjectContext:[self managedObjectContext]];
				
				[provider setName:providerName];
			}
			
			ProviderProduct * providerProduct = [NSEntityDescription insertNewObjectForEntityForName:@"ProviderProduct" inManagedObjectContext:[self managedObjectContext]];
			
			[providerProduct setProduct:importedProduct];
			[providerProduct setProvider:provider];
			[providerProduct setProviderPriceHT:providerPriceHT];
			
			[importedProduct addProviderProductsObject:providerProduct];
			
			// Tax rate
			
			TaxRate * theTaxRate = nil; // [[FKMOCIndexesManager defaultManager] objectForEntityForName:@"TaxRate" withValue:taxRate forIndexedKey:@"rate"];	
			
			
			if ( nil == theTaxRate )
			{
				theTaxRate = [NSEntityDescription insertNewObjectForEntityForName:@"TaxRate" inManagedObjectContext:[self managedObjectContext]];
				
				[theTaxRate setRate:taxRate];
			}
			
			[importedProduct setTaxRate:theTaxRate];
			
			// ...
			
			[importedProduct setUnitPriceTTC:unitPriceTTC];
			
			// Categories (11, 12, 13)
			
			ProductCategory * aProductCategory = nil;
			NSString * productCategoryName = nil;
			
			int catIndex = 11;
			
			while ( catIndex <= 13 )
			{
				productCategoryName = [aLine objectAtIndex:catIndex];
				
				//NSLog (@"productCategoryName = %@", productCategoryName);
				
				if ( ![productCategoryName isEqualToString:@""] )
				{
					aProductCategory = nil; // [[FKMOCIndexesManager defaultManager] objectForEntityForName:@"ProductCategory" withValue:productCategoryName forIndexedKey:@"name"];

					if ( nil == aProductCategory )
					{
						aProductCategory = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCategory" inManagedObjectContext:[self managedObjectContext]];
						
						[aProductCategory setName:productCategoryName];
					}
					
					[importedProduct addProductCategoriesObject:aProductCategory];
				}
				
				catIndex++;
			}
			
			// ...
						
			[progressIndicator incrementBy:1.0];
			[progressIndicator displayIfNeeded];
			
			}
		}
	
		[NSApp endSheet:progressWindow returnCode:NSOKButton];
	}
	
	NSLog (@" Fin importation !");
}

- (void)testBarcodeReader:(id)sender {
	FKBarcodeScanner * scanner = [[[FKBarcodeScanner alloc] init] autorelease];
	
	[scanner setLastScannedString:@"3421272101313"];
	
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FKBarcodeScannerDidEndScanningNotification
														object:scanner];
}






- (void)openPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	[NSApp stopModalWithCode:returnCode];
	[panel orderOut:self];
}

- (IBAction)recalculateStock:(id)sender
{
	// ...
	
	[progressMessageTextField setStringValue:@"Recalcul du stock..."];
	
	[NSApp beginSheet:progressWindow
	   modalForWindow:[NSApp mainWindow]
		modalDelegate:self
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
	
	NSManagedObjectContext * context = [self managedObjectContext];
	
	NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
	NSPredicate * predicate = nil;
	
	[fetchRequest setEntity:entityDescription];
	
	NSArray * productsArray = [context executeFetchRequest:fetchRequest error:nil];
	Product * aProduct = nil;
	
	NSArray * movementsArray = nil;
	StockMovement * aMovement = nil;
	
	int currentStock = 0;
	
	[progressIndicator setMaxValue:[productsArray count]];
	
	for ( aProduct in productsArray )
	{
		fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		entityDescription = [NSEntityDescription entityForName:@"StockMovement" inManagedObjectContext:context];
		predicate = [NSPredicate predicateWithFormat:@"product == %@", aProduct];
		
		[fetchRequest setEntity:entityDescription];
		[fetchRequest setPredicate:predicate];
		
		movementsArray = [context executeFetchRequest:fetchRequest error:nil];
		
		for ( aMovement in movementsArray )
		{
			currentStock += [(NSNumber *)[aMovement quantity] intValue];
		}
		
		[aProduct setCurrentStock:[NSNumber numberWithInt:currentStock]];
		
		currentStock = 0;
		
		// ...
		
		[progressIndicator incrementBy:1.0];
		[progressIndicator displayIfNeeded];
	}
	
	[NSApp endSheet:progressWindow returnCode:NSOKButton];
	
	[context save:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	[NSApp stopModalWithCode:returnCode];
	[sheet orderOut:self];
}

#pragma mark -
#pragma mark NSOutlineView DELEGATE

- (BOOL)isSpecialGroup:(FKSourceListItemNode *)listItemNode { 
	return ([listItemNode.title isEqualToString:NSLocalizedString(DAILYTASKS_NAME, @"")] ||
			[listItemNode.title isEqualToString:NSLocalizedString(ADMINTASKS_NAME, @"")] ||
			[listItemNode.title isEqualToString:NSLocalizedString(FOLDERS_NAME, @"")]);
}

#pragma mark -
#pragma mark NSToolbar DELEGATE

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	NSToolbarItem * aToolbarItem = [super toolbar:toolbar itemForItemIdentifier:itemIdentifier willBeInsertedIntoToolbar:flag];
	
	if ([itemIdentifier isEqualToString:MAINTOOLBARADDSALEID]) {
		[aToolbarItem setImage:[NSImage imageNamed:@"TB_AddSale"]];
		[aToolbarItem setTarget:self];
		[aToolbarItem setAction:@selector(addSale:)];
	}
	else if ([itemIdentifier isEqualToString:MAINTOOLBAREXPORTID]) {
		[aToolbarItem setImage:[NSImage imageNamed:@"TB_Export"]];
		[aToolbarItem setTarget:self];
		[aToolbarItem setAction:@selector(export:)];
	}
	else if ([itemIdentifier isEqualToString:MAINTOOLBARPRINTID]) {
		[aToolbarItem setImage:[NSImage imageNamed:@"TB_Print"]];
	}
	else if ([itemIdentifier isEqualToString:@"TestBarcodeReader"]) {
		[aToolbarItem setImage:[NSImage imageNamed:@"BarcodeReadersPreferences"]];
		[aToolbarItem setTarget:self];
		[aToolbarItem setAction:@selector(testBarcodeReader:)];
	}
	
	return aToolbarItem;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	NSMutableArray * result = [NSMutableArray arrayWithArray:[super toolbarAllowedItemIdentifiers:toolbar]];
	
	[result insertObject:MAINTOOLBARADDSALEID atIndex:0];
	[result insertObject:MAINTOOLBAREXPORTID atIndex:1];
	[result insertObject:MAINTOOLBARPRINTID atIndex:2];
	[result insertObject:@"TestBarcodeReader" atIndex:3];
	
	return [NSArray arrayWithArray:result];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	NSMutableArray * result = [NSMutableArray arrayWithArray:[super toolbarDefaultItemIdentifiers:toolbar]];

	[result insertObject:MAINTOOLBARADDSALEID atIndex:0];
	[result insertObject:NSToolbarSeparatorItemIdentifier atIndex:1];
	[result insertObject:MAINTOOLBAREXPORTID atIndex:2];
	[result insertObject:MAINTOOLBARPRINTID atIndex:3];
	[result insertObject:NSToolbarSeparatorItemIdentifier atIndex:4];
	[result insertObject:@"TestBarcodeReader" atIndex:5];
	
	return [NSArray arrayWithArray:result];
}

@end
