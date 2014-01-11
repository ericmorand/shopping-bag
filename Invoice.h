//
//  Invoice.h
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Sale;

@interface Invoice :  FKManagedObject  
{
}

- (NSDate *)date;
- (void)setDate:(NSDate *)value;
- (BOOL)validateDate: (id *)valueRef error:(NSError **)outError;

- (NSString *)invoiceNumber;
- (void)setInvoiceNumber:(NSString *)value;
- (BOOL)validateInvoiceNumber: (id *)valueRef error:(NSError **)outError;

- (Sale *)sale;
- (void)setSale:(Sale *)value;
- (BOOL)validateSale: (id *)valueRef error:(NSError **)outError;

@end
