#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSURLRequest.h>
#import <Foundation/NSURLProtocol.h>


@interface FKURLProtocol : NSURLProtocol
{
}

+ (NSString*) specialProtocolScheme;
+ (NSString*) specialProtocolVarsKey;
+ (void) registerSpecialProtocol;

@end

@interface NSURLRequest (FKURLProtocol)

- (NSDictionary *)specialVars;

@end

@interface NSMutableURLRequest (FKURLProtocol)

- (void)setSpecialVars:(NSDictionary *)caller;

@end

