// -----------------------------------------------------------------------------------
// NSImage-Resolution.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sun May 12 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NSImage-Resolution.h"


@implementation NSImage (normalize)
// -----------------------------------------------------------------------------------
- (NSImage *) normalizeSize
// -----------------------------------------------------------------------------------
{
    NSBitmapImageRep *theBitmap = nil;
    NSSize newSize;
    NSArray *reps = [self representations];

    for (NSImageRep *theRep in reps )
    {
        if ([theRep isKindOfClass:[NSBitmapImageRep class]])
        {
            theBitmap = (NSBitmapImageRep *)theRep;
            break;
        }
    }
    if (theBitmap != nil)
    {
        newSize.width = [theBitmap pixelsWide];
        newSize.height = [theBitmap pixelsHigh];
        [theBitmap setSize:newSize];
        [self setSize:newSize];
    }
    return self;
}
// -----------------------------------------------------------------------------------
- (NSImage *) setDPI:(int)dpi
// -----------------------------------------------------------------------------------
{
    NSBitmapImageRep *theBitmap = nil;
    NSSize newSize;
    NSArray *reps = [self representations];

    for (NSImageRep *theRep in reps )
    {
        if ([theRep isKindOfClass:[NSBitmapImageRep class]])
        {
            theBitmap = (NSBitmapImageRep *)theRep;
            break;
        }
    }
    if (theBitmap != nil)
    {
        newSize.width = (float)([theBitmap pixelsWide])/dpi*72;
        newSize.height = (float)([theBitmap pixelsHigh])/dpi*72;
        [theBitmap setSize:newSize];
        [self setSize:newSize];
    }
    return self;
}
@end
