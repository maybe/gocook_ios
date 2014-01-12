//
//  UIViewController+AutoLayout.h
//  HellCook
//
//  Created by panda on 3/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "UIViewController+AutoLayout.h"

@implementation UIViewController(AutoLayout)

- (void)autoLayout
{
  if (HCSystemVersionGreaterOrEqualThan(7)) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
  }
}

@end