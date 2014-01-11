//
//  FKSubviewTableViewCell.h
//  FKKit
//

#import <AppKit/AppKit.h>


@interface FKSubviewTableViewCell : NSCell
{
    @private

    NSView *	view;	// Weak reference
}

- (void)setView:(NSView *)aView;

@property (assign,getter=view,setter=setView:) NSView *	view;
@end
