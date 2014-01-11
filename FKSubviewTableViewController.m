//
//  FKSubviewTableViewController.m
//  FKKit
//

#import "FKSubviewTableViewController.h"
#import "FKSubviewTableViewCell.h"


@implementation FKSubviewTableViewController

- (id)initWithViewColumn:(NSTableColumn *)aColumn
{
	self = [super init];
	
    if ( self )
    {
        [self setSubviewTableColumn:aColumn];
        [self setSubviewTableView:(FKTableView *)[subviewTableColumn tableView]];
        
		[subviewTableView setDataSource:self];
        [subviewTableView setDelegate:self];
        
		[subviewTableColumn setDataCell:[[[FKSubviewTableViewCell alloc] init] autorelease]];
        
        [subviewTableColumn setEditable:NO];
    }
    
    return self;
}

- (void)dealloc
{
    [self setSubviewTableView:nil];
    [self setSubviewTableColumn:nil];
    [self setDelegate:nil];
    
    [super dealloc];
}

+ (id)controllerWithViewColumn:(NSTableColumn *)aColumn {return [[[self alloc] initWithViewColumn:aColumn] autorelease];}

#pragma mark -
#pragma mark GETTERS

- (id)delegate {return delegate;}

- (BOOL)isValidDelegateForSelector:(SEL)command
{
    return ( ( [self delegate] != nil ) && [[self delegate] respondsToSelector:command] );
}

#pragma mark -
#pragma mark SETTERS

- (void)setSubviewTableView:(FKTableView *)aView
{
	subviewTableView = aView;
}

- (void)setSubviewTableColumn:(NSTableColumn *)aColumn
{
	subviewTableColumn = aColumn;
}

- (void)setDelegate:(id)anObject
{
    NSParameterAssert([anObject conformsToProtocol:@protocol(FKSubviewTableViewControllerDataSource)]);
    
	delegate = anObject;
}

#pragma mark -
#pragma mark MISC

- (void)reloadTableView
{
    while ( [[subviewTableView subviews] count] > 0 )
    {
		[[[subviewTableView subviews] lastObject] removeFromSuperviewWithoutNeedingDisplay];
    }
    
    [subviewTableView reloadData];
}

#pragma mark -
#pragma mark NSTableViewDelegate

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		return [[self delegate] selectionShouldChangeInTableView:tableView];
    }
    else
    {
		return YES;
    }
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		[[self delegate] performSelector:_cmd withObject:tableView withObject:tableColumn];
    }
}

- (void)tableView:(NSTableView *)tableView didDragTableColumn:(NSTableColumn *)tableColumn
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		[[self delegate] performSelector:_cmd withObject:tableView withObject:tableColumn];
    }
}

- (void)tableView:(NSTableView *)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		[[self delegate] performSelector:_cmd withObject:tableView withObject:tableColumn];
    }
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		return [[self delegate] tableView:tableView shouldEditTableColumn:tableColumn row:row];
    }
    else
    {
		return YES;
    }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		return [[self delegate] tableView:tableView shouldSelectRow:row];
    }
    else
    {
		return YES;
    }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		return [[self delegate] tableView:tableView shouldSelectTableColumn:tableColumn];
    }
    else
    {
		return YES;
    }
}

- (void)tableView:(FKTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
    if ( tableColumn == subviewTableColumn )
    {
        if ( [self isValidDelegateForSelector:@selector(tableView:viewForRow:)] )
		{
			[(FKSubviewTableViewCell *)cell setView:[[self delegate] tableView:tableView viewForRow:row]];
		}
    }
    else
    {
        if ( [self isValidDelegateForSelector:_cmd] )
		{
			[[self delegate] tableView:tableView willDisplayCell:cell forTableColumn:tableColumn row:row];
		}
    }
}

- (void)tableViewColumnDidMove:(NSNotification *)notification
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		[[self delegate] performSelector:_cmd withObject:notification];
    }
}

- (void)tableViewColumnDidResize:(NSNotification *)notification
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		[[self delegate] performSelector:_cmd withObject:notification];
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		[[self delegate] performSelector:_cmd withObject:notification];
    }
}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		[[self delegate] performSelector:_cmd withObject:notification];
    }
}

#pragma mark -
#pragma mark NSTableDataSource

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    int count = 0;
    
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		count = [[self delegate] numberOfRowsInTableView:tableView];
    }

    return count;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		return [[self delegate] tableView:tableView acceptDrop:info row:row dropOperation:operation];
    }
    else
    {
		return NO;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
    id anObject = nil;

    if ( ( tableColumn != subviewTableColumn ) && [self isValidDelegateForSelector:_cmd] )
    {
		anObject = [[self delegate] tableView:tableView objectValueForTableColumn:tableColumn row:row];
    }

    return anObject;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)obj forTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
    if ( ( tableColumn != subviewTableColumn ) && [self isValidDelegateForSelector:_cmd] )
    {
		[[self delegate] tableView:tableView setObjectValue:obj forTableColumn:tableColumn row:row];
    }
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)operation
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		return [[self delegate] tableView:tableView validateDrop:info proposedRow:row proposedDropOperation:operation];
    }
    else
    {
		return NO;
    }
}

- (BOOL)tableView:(NSTableView *)tableView writeRows:(NSArray *)rows toPasteboard:(NSPasteboard *)pboard
{
    if ( [self isValidDelegateForSelector:_cmd] )
    {
		return [[self delegate] tableView:tableView writeRows:rows toPasteboard:pboard];
    }
    else
    {
		return NO;
    }
}

@synthesize subviewTableView;
@synthesize subviewTableColumn;
@end
