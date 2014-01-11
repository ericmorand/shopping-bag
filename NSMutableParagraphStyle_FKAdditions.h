//
//  NSMutableParagraphStyle_FKAdditions.h
//  FK
//
//  Created by Eric on 22/07/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSMutableParagraphStyle (FKAdditions)

+ (NSMutableParagraphStyle *)paragraphStyleWithAlignment:(NSTextAlignment)alignment;
- (id)initWithAlignment:(NSTextAlignment)alignment;

@end
