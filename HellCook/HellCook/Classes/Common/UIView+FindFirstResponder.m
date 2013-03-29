//
//  NSObject+UIView_FindFirstResponder.m
//  HellCook
//
//  Created by panda on 3/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "UIView+FindFirstResponder.h"

@implementation UIView(FindFirstResponder)

- (UIView *)findFirstResponder
{
  if (self.isFirstResponder) {
    return self;
  }
  
  for (UIView *subView in self.subviews) {
    UIView *firstResponder = [subView findFirstResponder];
    
    if (firstResponder != nil) {
      return firstResponder;
    }
  }
  
  return nil;
}

@end