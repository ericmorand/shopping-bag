//
//  NSDate_FKAdditions.m
//  FKKit
//
//  Created by Eric on 15/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "NSDate_FKAdditions.h"


@implementation NSDate (FKAdditions)

- (NSDate *)firstSecond {
	NSDate * result = nil;
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	
	result = [cal dateFromComponents:comps];
	
	return result;
}

- (NSDate *)lastSecond {
	NSDate * result = nil;
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	
	[comps setHour:23];
	[comps setMinute:59];
	[comps setSecond:59];
	
	result = [cal dateFromComponents:comps];
	
	return result;
}

+ (NSDate *)yesterday {
	NSDate * result = nil;
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * comps = [[[NSDateComponents alloc] init] autorelease];
	
	[comps setDay:-1];
	
	result = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];
	
	return result;
}

@end
