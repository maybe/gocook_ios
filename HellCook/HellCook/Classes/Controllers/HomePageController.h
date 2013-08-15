//
//  HomePageController.h
//  HellCook
//
//  Created by panda on 8/4/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageController : UITabBarController
{
  UITabBar* mTabBar;
  BOOL bMyself;
}

@property (retain, nonatomic) UITabBar* mTabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isMyself:(BOOL)isMyself withUserID:(NSInteger)userID fromMyFollow:(BOOL)fromFollow;

@end
