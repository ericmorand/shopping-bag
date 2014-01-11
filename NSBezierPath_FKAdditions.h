//
//  NSBezierPath_FKAdditions.h
//


#import <AppKit/AppKit.h>

typedef enum {
	AMTriangleUp = 0,
	AMTriangleDown,
	AMTriangleLeft,
	AMTriangleRight
} AMTriangleOrientation;

enum {
	FKNoCorner = 0,
    FKBottomLeftCorner = 1,
    FKTopLeftCorner = 2,
    FKTopRightCorner = 4,
    FKBottomRightCorner	= 8,
	FKEveryCorner = 15,
};

@interface NSBezierPath (FKAdditions)

+ (NSBezierPath *)bezierPathWithPlateInRect:(NSRect)rect;
- (void)appendBezierPathWithPlateInRect:(NSRect)rect;

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius cornerMask:(unsigned int)cornerMask;
- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius cornerMask:(unsigned int)cornerMask;

+ (NSBezierPath *)bezierPathWithTriangleInRect:(NSRect)aRect orientation:(AMTriangleOrientation)orientation;
- (void)appendBezierPathWithTriangleInRect:(NSRect)aRect orientation:(AMTriangleOrientation)orientation;

- (void)customVerticalFillWithCallbacks:(CGFunctionCallbacks)functionCallbacks firstColor:(NSColor *)firstColor secondColor:(NSColor *)secondColor;
- (void)customVerticalStrokeWithCallbacks:(CGFunctionCallbacks)functionCallbacks firstColor:(NSColor *)firstColor secondColor:(NSColor *)secondColor;
- (void)linearGradientFillWithStartColor:(NSColor *)startColor endColor:(NSColor *)endColor;
- (void)linearGradientStrokeWithStartColor:(NSColor *)startColor endColor:(NSColor *)endColor;
- (void)bilinearGradientFillWithOuterColor:(NSColor *)outerColor innerColor:(NSColor *)innerColor;

- (void)horizontalGradientFillWithStartColor:(NSColor *)startColor endColor:(NSColor *)endColor;
- (void)customHorizontalFillWithCallbacks:(CGFunctionCallbacks)functionCallbacks firstColor:(NSColor *)firstColor secondColor:(NSColor *)secondColor;

@end
