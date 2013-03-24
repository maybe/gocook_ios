//
//  CustomNavigationBar.m
//  HellCook
//
//  Created by panda on 3/24/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "CustomNavigationBar.h"
@implementation CustomNavigationBar

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize = CGSizeMake(_sideWindowWidth, self.frame.size.height);
    return newSize;
}

@end
