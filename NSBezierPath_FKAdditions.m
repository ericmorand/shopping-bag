//
//  NSBezierPath_FKAdditions.m
//


#import "NSBezierPath_FKAdditions.h"


@implementation NSBezierPath (FKAdditions)

+ (NSBezierPath *)bezierPathWithPlateInRect:(NSRect)rect
{
	NSBezierPath * result = [[[NSBezierPath alloc] init] autorelease];
	
	[result appendBezierPathWithPlateInRect:rect];
	
	return result;
}

- (void)appendBezierPathWithPlateInRect:(NSRect)rect
{
	if ( NSHeight(rect) > 0)
	{
		float xoff = NSMinX(rect);
		float yoff = NSMinY(rect);
		float radius = rect.size.height / 2.0;
		
		NSPoint point4 = NSMakePoint(xoff + radius, yoff + NSHeight(rect));
		NSPoint center1 = NSMakePoint(xoff + radius, yoff + radius);
		NSPoint center2 = NSMakePoint(xoff + NSWidth(rect) - radius, yoff + radius);
		
		[self moveToPoint:point4];
		[self appendBezierPathWithArcWithCenter:center1 radius:radius startAngle: 90.0 endAngle:270.0];
		[self appendBezierPathWithArcWithCenter:center2 radius:radius startAngle:270.0 endAngle: 90.0];
		[self closePath];
	}
}

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius cornerMask:(unsigned int)cornerMask
{
	NSBezierPath * path = [[[NSBezierPath alloc] init] autorelease];
	
	[path appendBezierPathWithRoundedRect:rect cornerRadius:radius cornerMask:cornerMask];
	
	return path;
}

- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius cornerMask:(unsigned int)cornerMask
{
	if ( rect.size.height > 0 )
	{
		//NSLog (@"     COINS : radius = %f, cornerMask = %hu !!!", radius, cornerMask);
		
		if ( ( cornerMask & FKNoCorner ) || ( radius <= 0.0 ) )
		{
			// Aucun coin du rectangle n'est arrondi : c'est un rectangle classique,
			// on passe la main a la methode standard de NSBezierPath
			
			[self appendBezierPathWithRect:rect];
		}
		else
		{
			// Au moins un des coins doit etre arrondi...
		
			float originX = rect.origin.x;
			float originY = rect.origin.y;
			float rectWidth = rect.size.width;
			float rectHeight = rect.size.height;
		
			NSPoint nextPoint = NSZeroPoint;
					
			// Coin bas-gauche
			
			if ( cornerMask & FKBottomLeftCorner )
			{ 
				nextPoint = NSMakePoint(originX + radius, originY);
				
				[self moveToPoint:nextPoint];
				
				nextPoint = NSMakePoint(originX + radius, originY + radius);
				
				[self appendBezierPathWithArcWithCenter:nextPoint radius:radius startAngle:270.0 endAngle:180.0 clockwise:YES];
			}
			else
			{
				nextPoint = NSMakePoint(originX, originY);
				
				[self moveToPoint:nextPoint];
			}
			
			// Coin haut-gauche
		
			if ( cornerMask & FKTopLeftCorner )
			{
				nextPoint = NSMakePoint(originX + radius, originY + rectHeight - radius);
			
				[self appendBezierPathWithArcWithCenter:nextPoint radius:radius startAngle:180.0 endAngle: 90.0 clockwise:YES];
			}
			else
			{
				nextPoint = NSMakePoint(originX, originY + rectHeight);
			
				[self lineToPoint:nextPoint];
			}
		
			// Coin haut-droite
		
			if ( cornerMask & FKTopRightCorner )
			{
				nextPoint = NSMakePoint(originX + rectWidth - radius, originY + rectHeight - radius);
			
				[self appendBezierPathWithArcWithCenter:nextPoint radius:radius startAngle:90.0 endAngle:  0.0 clockwise:YES];
			}
			else
			{
				nextPoint = NSMakePoint(originX + rectWidth, originY + rectHeight);
			
				[self lineToPoint:nextPoint];
			}		
		
			// Coin bas-droite
		
			if ( cornerMask & FKBottomRightCorner )
			{
				nextPoint = NSMakePoint(originX + rectWidth - radius, originY + radius);
			
				[self appendBezierPathWithArcWithCenter:nextPoint radius:radius startAngle:  0.0 endAngle:270.0 clockwise:YES];
			}
			else
			{
				nextPoint = NSMakePoint(originX + rectWidth, originY);
			
				[self lineToPoint:nextPoint];
			}
		
			[self closePath];
		}
	}
}

+ (NSBezierPath *)bezierPathWithTriangleInRect:(NSRect)aRect orientation:(AMTriangleOrientation)orientation
{
	NSBezierPath *result = [[[NSBezierPath alloc] init] autorelease];
	[result appendBezierPathWithTriangleInRect:aRect orientation:orientation];
	return result;
}

- (void)appendBezierPathWithTriangleInRect:(NSRect)aRect orientation:(AMTriangleOrientation)orientation
{	
	NSPoint a, b, c;
	switch (orientation)	{
		case AMTriangleUp:
		{
			a = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
			b = NSMakePoint((NSMinX(aRect) + NSMaxX(aRect)) / 2, NSMaxY(aRect));
			c = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
			break;
		}
			
		case AMTriangleDown:
		{
			a = NSMakePoint(NSMinX(aRect), NSMaxY(aRect));
			c = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));
			b = NSMakePoint((NSMinX(aRect) + NSMaxX(aRect)) / 2, NSMinY(aRect));
			break;
		}
			
		case AMTriangleLeft:
		{
			a = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));
			b = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
			c = NSMakePoint(NSMinX(aRect), (NSMinY(aRect) + NSMaxY(aRect)) / 2);
			break;
		}
			
		default : // case AMTriangleRight:
		{
			a = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
			b = NSMakePoint(NSMinX(aRect), NSMaxY(aRect));
			c = NSMakePoint(NSMaxX(aRect), (NSMinY(aRect) + NSMaxY(aRect)) / 2);
			break;
		}
	}
	
	[self moveToPoint:a];
	[self lineToPoint:b];
	[self lineToPoint:c];
	[self closePath];
}

#pragma mark -
#pragma mark GRADIENT SUPPORT

static void linearShadedColor(void *info, const float *inData, float *outData)
{
	float * colors = info;
	
	*outData++ = colors[0] + *inData * colors[8];
	*outData++ = colors[1] + *inData * colors[9];
	*outData++ = colors[2] + *inData * colors[10];
	*outData++ = colors[3] + *inData * colors[11];
}

static void bilinearShadedColor(void *info, const float *in, float *out)
{
	float *colors = info;
	float factor = (*in)*2.0;
	if (*in > 0.5) {
		factor = 2-factor;
	}
	*out++ = colors[0] + factor * colors[8];
	*out++ = colors[1] + factor * colors[9];
	*out++ = colors[2] + factor * colors[10];
	*out++ = colors[3] + factor * colors[11];
}

- (void)linearGradientFillWithStartColor:(NSColor *)startColor endColor:(NSColor *)endColor
{
	static const CGFunctionCallbacks callbacks = {0, &linearShadedColor, NULL};
	
	[self customVerticalFillWithCallbacks:callbacks firstColor:startColor secondColor:endColor];
}

- (void)linearGradientStrokeWithStartColor:(NSColor *)startColor endColor:(NSColor *)endColor
{
	static const CGFunctionCallbacks callbacks = {0, &linearShadedColor, NULL};
	
	[self customVerticalStrokeWithCallbacks:callbacks firstColor:startColor secondColor:endColor];
}

- (void)bilinearGradientFillWithOuterColor:(NSColor *)outerColor innerColor:(NSColor *)innerColor
{
	static const CGFunctionCallbacks callbacks = {0, &bilinearShadedColor, NULL};
	
	[self customVerticalFillWithCallbacks:callbacks firstColor:innerColor secondColor:outerColor];
}

- (CGPathRef)quartzPath
{
    int i, numElements;
    CGPathRef           immutablePath = NULL;
	
    // If there are elements to draw, create a CGMutablePathRef and draw.
    numElements = [self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
		
        // Iterate over the points and add them to the mutable path object.
        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
					
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    break;
					
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
										  points[1].x, points[1].y,
										  points[2].x, points[2].y);
                    break;
					
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    break;
            }
        }
		
        // Return an immutable copy of the path.
        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
	
    return immutablePath;
}


- (void)loadQuartzPathOf:(NSBezierPath *)bezierPath intoContext:(CGContextRef)context
{
    CGPathRef path = [bezierPath quartzPath];
	
    CGContextAddPath(context, path);
	CGContextSetLineWidth(context, [self lineWidth]);
	CGContextSetLineJoin(context, [self lineJoinStyle]);
	CGContextSetLineCap(context, [self lineCapStyle]);
	CGContextSetMiterLimit(context, [self miterLimit]);
	
	float *myPattern = nil;
	float myPhase = 0;
	int	myCount = -1;
	[self getLineDash:nil count:&myCount phase:&myPhase];
	
	if ( myCount > 0 )
	{
		myPattern = malloc(myCount * sizeof(float)) ;
		[self getLineDash:myPattern count:&myCount phase:&myPhase];
		CGContextSetLineDash(context,myPhase,myPattern,myCount);
		free(myPattern);
	}
	
	CFRelease(path);
}

- (CGPathRef)quartzStrokePath
{
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGPathRef immutablePath = NULL;
    CGPathRef strokePath = NULL;
	
    CGContextSaveGState(context);
	
	[self loadQuartzPathOf:self intoContext:context];
	
    CGContextReplacePathWithStrokedPath(context);
	
	strokePath = (CGPathRef) CGContextCopyPath(context);
	immutablePath = CGPathCreateCopy(strokePath);
	
	CFRelease(strokePath);
	
    CGContextRestoreGState(context);
	
    return immutablePath;
}

- (void)customVerticalFillWithCallbacks:(CGFunctionCallbacks)functionCallbacks firstColor:(NSColor *)firstColor secondColor:(NSColor *)secondColor
{
	CGColorSpaceRef colorspace;
	CGShadingRef shading;
	CGPoint startPoint = {0, 0};
	CGPoint endPoint = {0, 0};
	CGFunctionRef function;
	float colors[12]; // pointer to color values
	
	// get my context
	CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	NSColor *deviceDependentFirstColor = [firstColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	NSColor *deviceDependentSecondColor = [secondColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	
	// set up colors for gradient
	colors[0] = [deviceDependentFirstColor redComponent];
	colors[1] = [deviceDependentFirstColor greenComponent];
	colors[2] = [deviceDependentFirstColor blueComponent];
	colors[3] = [deviceDependentFirstColor alphaComponent];
	
	colors[4] = [deviceDependentSecondColor redComponent];
	colors[5] = [deviceDependentSecondColor greenComponent];
	colors[6] = [deviceDependentSecondColor blueComponent];
	colors[7] = [deviceDependentSecondColor alphaComponent];
	
	// difference between start and end color for each color components
	colors[8] = (colors[4]-colors[0]);
	colors[9] = (colors[5]-colors[1]);
	colors[10] = (colors[6]-colors[2]);
	colors[11] = (colors[7]-colors[3]);
	
	// draw gradient
	colorspace = CGColorSpaceCreateDeviceRGB();
	size_t components = 1 + CGColorSpaceGetNumberOfComponents(colorspace);
	static const float  domain[2] = {0.0, 1.0};
	static const float  range[10] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1};
	//static const CGFunctionCallbacks callbacks = {0, &bilinearShadedColor, NULL};
	
	// ...
	
	// Create a CGFunctionRef that describes a function taking 1 input and kChannelsPerColor outputs.
	function = CGFunctionCreate(colors, 1, domain, components, range, &functionCallbacks);
	
	startPoint.x = 0;
	startPoint.y = [self bounds].origin.y;
	endPoint.x = 0;
	endPoint.y = NSMaxY([self bounds]);
	
	shading = CGShadingCreateAxial(colorspace, startPoint, endPoint, function, NO, NO);
	
	CGContextSaveGState(currentContext);
	
	[self addClip];
		
	CGContextDrawShading(currentContext, shading);
	CGContextRestoreGState(currentContext);
	
	CGShadingRelease(shading);
	CGFunctionRelease(function);
	CGColorSpaceRelease(colorspace);
}

- (void)customVerticalStrokeWithCallbacks:(CGFunctionCallbacks)functionCallbacks firstColor:(NSColor *)firstColor secondColor:(NSColor *)secondColor
{
	CGColorSpaceRef colorspace;
	CGShadingRef shading;
	CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(0.0, 0.0);
	CGFunctionRef function;
	float colors[12]; // pointer to color values
	
	// get my context
	CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	NSColor *deviceDependentFirstColor = [firstColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	NSColor *deviceDependentSecondColor = [secondColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	
	// set up colors for gradient
	colors[0] = [deviceDependentFirstColor redComponent];
	colors[1] = [deviceDependentFirstColor greenComponent];
	colors[2] = [deviceDependentFirstColor blueComponent];
	colors[3] = [deviceDependentFirstColor alphaComponent];
	
	colors[4] = [deviceDependentSecondColor redComponent];
	colors[5] = [deviceDependentSecondColor greenComponent];
	colors[6] = [deviceDependentSecondColor blueComponent];
	colors[7] = [deviceDependentSecondColor alphaComponent];
	
	// difference between start and end color for each color components
	colors[8] = (colors[4]-colors[0]);
	colors[9] = (colors[5]-colors[1]);
	colors[10] = (colors[6]-colors[2]);
	colors[11] = (colors[7]-colors[3]);
	
	// draw gradient
	colorspace = CGColorSpaceCreateDeviceRGB();
	size_t components = 1 + CGColorSpaceGetNumberOfComponents(colorspace);
	static const float  domain[2] = {0.0, 1.0};
	static const float  range[10] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1};
	//static const CGFunctionCallbacks callbacks = {0, &bilinearShadedColor, NULL};
	
	// ...
	
	CGPathRef bezierPath = [self quartzStrokePath];
	
	// ...
	
	// Create a CGFunctionRef that describes a function taking 1 input and kChannelsPerColor outputs.
	function = CGFunctionCreate(colors, 1, domain, components, range, &functionCallbacks);

	startPoint.x -= floor([self lineWidth] / 2);
	startPoint.y = NSMinY([self bounds]) - floor([self lineWidth] / 2);
	endPoint.x = startPoint.x;
	endPoint.y = NSMaxY([self bounds]) + floor([self lineWidth] /2);
	
	shading = CGShadingCreateAxial(colorspace, startPoint, endPoint, function, YES, NO);
	
	CGContextSaveGState(currentContext);
	
	CGContextAddPath(currentContext, bezierPath);
	CGContextClip (currentContext);
	
	CGContextDrawShading(currentContext, shading);
	CGContextRestoreGState(currentContext);
	
	CGShadingRelease(shading);
	CGFunctionRelease(function);
	CGColorSpaceRelease(colorspace);
}

- (void)horizontalGradientFillWithStartColor:(NSColor *)startColor endColor:(NSColor *)endColor
{
	static const CGFunctionCallbacks callbacks = {0, &linearShadedColor, NULL};
	
	[self customHorizontalFillWithCallbacks:callbacks firstColor:startColor secondColor:endColor];
}

- (void)customHorizontalFillWithCallbacks:(CGFunctionCallbacks)functionCallbacks firstColor:(NSColor *)firstColor secondColor:(NSColor *)secondColor
{
	CGColorSpaceRef colorspace;
	CGShadingRef shading;
	CGPoint startPoint = {0, 0};
	CGPoint endPoint = {0, 0};
	CGFunctionRef function;
	float colors[12]; // pointer to color values
	
	// Get my context
	
	CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	NSColor * deviceDependentFirstColor = [firstColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	NSColor * deviceDependentSecondColor = [secondColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	
	// Set up colors for gradient
	
	colors[0] = [deviceDependentFirstColor redComponent];
	colors[1] = [deviceDependentFirstColor greenComponent];
	colors[2] = [deviceDependentFirstColor blueComponent];
	colors[3] = [deviceDependentFirstColor alphaComponent];
	
	colors[4] = [deviceDependentSecondColor redComponent];
	colors[5] = [deviceDependentSecondColor greenComponent];
	colors[6] = [deviceDependentSecondColor blueComponent];
	colors[7] = [deviceDependentSecondColor alphaComponent];
	
	// Difference between start and end color for each color components
	
	colors[8] = (colors[4] - colors[0]);
	colors[9] = (colors[5] - colors[1]);
	colors[10] = (colors[6] - colors[2]);
	colors[11] = (colors[7] - colors[3]);
	
	// Draw gradient
	
	colorspace = CGColorSpaceCreateDeviceRGB();
	size_t components = 1 + CGColorSpaceGetNumberOfComponents(colorspace);
	
	static const float  domain[2] = {0.0, 1.0};
	static const float  range[10] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1};
	
	// Create a CGFunctionRef that describes a function taking 1 input and kChannelsPerColor outputs.
	
	function = CGFunctionCreate(colors, 1, domain, components, range, &functionCallbacks);
	
	NSRect bounds = NSInsetRect([self bounds], 0.5, 0.5);
		
	startPoint.x = NSMinX(bounds);
	startPoint.y = NSMinY(bounds);
	endPoint.x = NSMaxX(bounds);
	endPoint.y = NSMinY(bounds);
	
	shading = CGShadingCreateAxial(colorspace, startPoint, endPoint, function, NO, NO);
	
	CGContextSaveGState(currentContext);
	
	[self addClip];
	
	CGContextDrawShading(currentContext, shading);
	CGContextRestoreGState(currentContext);
	
	CGShadingRelease(shading);
	CGFunctionRelease(function);
	CGColorSpaceRelease(colorspace);
}

@end
