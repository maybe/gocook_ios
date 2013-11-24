//
//  HomePageController.h
//  HellCook
//
//  Created by panda on 8/4/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomePageController : UITabBarController {
  UITabBar *mTabBar;
}

@property(retain, nonatomic) UITabBar *mTabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userID AndName:(NSString *)userName showIndex:(NSInteger)index;

@end
