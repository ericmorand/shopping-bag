//
//  Inventory.h
//  ShoppingBag
//
//  Created by Eric on 30/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>

@class StockMovement;
@class StockSnapshot;

typedef enum _InventoryStatus {
	InventoryStatusRunning = 0,
	InventoryStatusPaused = 1,
	InventoryStatusIdle = 2,
	InventoryStatusDone = 3
} InventoryStatus;

@interface Inventory : FKManagedObject  
{
}

@property (readonly) NSImage * icon;

+ (Inventory *)runningInventory;
+ (void)setRunningInventory:(Inventory *)anInventory;

- (BOOL)canRun;
- (BOOL)canStop;
- (NSDate *)beginDate;
- (StockSnapshot *)beginStockSnapshot;
- (NSDate *)endDate;
- (StockSnapshot *)endStockSnapshot;
- (NSString *)name;
- (NSNumber *)status;

- (NSImage *)statusIcon;

- (void)setBeginDate:(NSDate *)value;
- (void)setBeginStockSnapshot:(StockSnapshot *)value;
- (void)setEndDate:(NSDate *)value;
- (void)setEndStockSnapshot:(StockSnapshot *)value;
- (void)setName:(NSString *)value;
- (void)setStatus:(NSNumber *)value;

- (BOOL)validateBeginDate:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateBeginStockSnapshot:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateEndDate:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateName:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateStatus:(id *)valueRef error:(NSError **)outError;

// Access to-many relationship via -[NSObject mutableSetValueForKey:]
- (void)addStockMovementsObject:(StockMovement *)value;
- (void)removeStockMovementsObject:(StockMovement *)value;

- (void)run;
- (void)stop;

@end
