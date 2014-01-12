//
//  KeyboardHandlerDelegate.h
//  HellCook
//
//  Created by panda on 3/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyboardHandlerDelegate <NSObject>

- (void)keyboardSizeChanged:(CGSize)delta;

@end
