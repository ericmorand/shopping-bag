//
//  NSPointFunctions_FKAdditions.h
//  FK
//
//  Created by Eric on 21/07/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <math.h>
#import <float.h> /* Standard C lib that contains some constants, look at http://www.acm.uiuc.edu/webmonkeys/book/c_guide/2.4.html -- JP */

static inline NSPoint NSAddPoints(NSPoint firstPoint, NSPoint secondPoint)
{
	return NSMakePoint(firstPoint.x + secondPoint.x, firstPoint.y + secondPoint.y);
}

static inline NSPoint NSSubtractPoints(NSPoint firstPoint, NSPoint secondPoint)
{
	return NSMakePoint(firstPoint.x - secondPoint.x, firstPoint.y - secondPoint.y);
}

static inline NSPoint NSOffsetPoint(NSPoint point, float amountX, float amountY)
{
    return NSAddPoints(point, NSMakePoint(amountX, amountY));
}

static inline NSPoint NSReflectedPointAboutXAxis(NSPoint point)
{
    return NSMakePoint(-point.x, point.y);
}

static inline NSPoint NSReflectedPointAboutYAxis(NSPoint point)
{
    return NSMakePoint(point.x, -point.y);
}

static inline NSPoint NSReflectedPointAboutOrigin(NSPoint point)
{
    return NSMakePoint(-point.x, -point.y);
}

static inline NSPoint NSTransformedPoint(NSPoint point, NSAffineTransform * transform)
{
	return [transform transformPoint:point];
}

static inline NSPoint NSCartesianToPolar(NSPoint cartesianPoint)
{
    return NSMakePoint(sqrtf(cartesianPoint.x * cartesianPoint.x + cartesianPoint.y * cartesianPoint.y), atan2f(cartesianPoint.y, cartesianPoint.x));
}

static inline NSPoint NSPolarToCartesian(NSPoint polarPoint)
{
    return NSMakePoint(polarPoint.x*cosf(polarPoint.y), polarPoint.x*sinf(polarPoint.y));
}
