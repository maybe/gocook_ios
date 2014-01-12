//
//  KeyboardHandler.h
//  HellCook
//
//  Created by panda on 3/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyboardHandlerDelegate;

@interface KeyboardHandler : NSObject

- (id)init;

@property(nonatomic, weak) id<KeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end