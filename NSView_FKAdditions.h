//
//  NSView_FKAdditions.h
//  ShoppingBag
//
//  Created by Eric on 15/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSView (FKAdditions)

- (void)setFrameX:(float)aFloat;
- (void)setFrameY:(float)aFloat;
- (void)setFrameWidth:(float)aFloat;
- (void)setFrameHeight:(float)aFloat;

- (void)centerInScrollView:(NSScrollView *)scrollView;

// actualLayoutView retourne la vue a utiliser pour faire du "layout".
// Dans la plupart des cas, cette methode retourne le "receiver" lui-meme,
// mais certains cas particuliers (les instances de NSTableView par exemple)
// sont contenus dans une "scroll view" et c'est cette derniere qui est alors
// retournee par la methode.

- (NSView *)actualLayoutView;

@end
