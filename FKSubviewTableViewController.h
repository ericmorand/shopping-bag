//
//  FKSubviewTableViewController.h
//  FKKit
//

#import <AppKit/AppKit.h>

@class FKTableView;

@interface FKSubviewTableViewController : NSObject
{
    @private
    
    FKTableView	*		subviewTableView;	// Weak reference
    NSTableColumn *		subviewTableColumn;	// Weak reference
    
    id					delegate;
}

+ (id)controllerWithViewColumn:(NSTableColumn *) vCol;

- (id)delegate;

- (void)setSubviewTableView:(FKTableView *)aView;
- (void)setSubviewTableColumn:(NSTableColumn *)aColumn;
- (void)setDelegate:(id)anObject;

- (void)reloadTableView;

@property (assign,setter=setSubviewTableView:) FKTableView	*		subviewTableView;
@property (assign,setter=setSubviewTableColumn:) NSTableColumn *		subviewTableColumn;
@end

@protocol FKSubviewTableViewControllerDataSource

- (NSView *)tableView:(FKTableView *)tableView viewForRow:(int)row;

@end
