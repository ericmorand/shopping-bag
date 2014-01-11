
#import "NSMutableArray_FKAdditions.h"


@implementation NSMutableArray (NSArray_Extensions)

- (void)insertObjectsFromArray:(NSArray *)anArray atIndex:(int)index
{

    NSObject * anObject = nil;
	
    for ( anObject in anArray )
	{
        [self insertObject:anObject atIndex:index++];
    }
}

@end
