#import <Foundation/NSError.h>
#import "FKURLProtocol.h"

//#import "Product.h"

	
@implementation NSURLRequest (FKURLProtocol)

- (NSDictionary *)specialVars
{
	return [NSURLProtocol propertyForKey:[FKURLProtocol specialProtocolVarsKey] inRequest:self];
}

@end

@implementation NSMutableURLRequest (FKURLProtocol)

- (void)setSpecialVars:(NSDictionary *)specialVars
{	
	NSDictionary * specialVarsCopy = [specialVars copy];
	
	[NSURLProtocol setProperty:specialVarsCopy forKey:[FKURLProtocol specialProtocolVarsKey] inRequest:self];
	
	[specialVarsCopy release];
}

@end

@implementation FKURLProtocol

+ (NSString *)specialProtocolScheme
{
	return @"special";
}

+ (NSString *)specialProtocolVarsKey
{
	return @"specialVarsKey";
}

+ (void)registerSpecialProtocol
{
	static BOOL inited = NO;
	
	if ( ! inited )
	{
		[NSURLProtocol registerClass:[FKURLProtocol class]];
		
		inited = YES;
	}
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)theRequest
{	
	NSString * theScheme = [[theRequest URL] scheme];
	
	NSLog (@" theScheme = %@", theScheme);
	
	BOOL canInit = NO;
	
	canInit = ( [theScheme caseInsensitiveCompare:[FKURLProtocol specialProtocolScheme]] == NSOrderedSame );
		
	return canInit;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{	
	//NSLog (@"startLoading");
	
	NSURLRequest * request = [self request];
	NSDictionary * specialVars = [request specialVars];
	NSManagedObjectContext * managedObjectContext = nil;
	
	if ( specialVars )
	{
		managedObjectContext = [specialVars objectForKey:@"MOC"];
	}
	
	NSString * theString = [[[request URL] path] substringFromIndex:1];
	
	NSURL * URIRep = [NSURL URLWithString:theString];
	
	//NSLog (@"URIRep = %@", URIRep);
	
	/*NSManagedObjectID * anObjectID = [[managedObjectContext persistentStoreCoordinator] managedObjectIDForURIRepresentation:URIRep];
	Product * aProduct = nil;
	NSImage * objectImage = nil;
	NSData * imageData = nil;
	
	if ( nil != anObjectID )
	{
		aProduct = (Product *)[managedObjectContext objectWithID:anObjectID];
		objectImage = [aProduct barcodeImage];
		
		if ( nil != objectImage )
		{
			imageData = [objectImage JPEGRepresentationUsingCompression:0.75];
		}
	}
	
	NSURLResponse * response = [[NSURLResponse alloc] initWithURL:[request URL] MIMEType:@"image/jpeg" expectedContentLength:-1 textEncodingName:nil];
		
	id<NSURLProtocolClient> client = [self client];

	[client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
	[client URLProtocol:self didLoadData:imageData];
	[client URLProtocolDidFinishLoading:self];
	
	[response release];*/
		
	//NSLog (@"FIN startLoading");
}

- (void)stopLoading {}


@end

