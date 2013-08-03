//
//  MyselfRootViewController.h
//  HellCook
//
//  Created by lxw on 13-8-1.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyIntroductionViewController.h"
#import "MyFollowViewController.h"

@interface MyselfRootViewController : UIViewController
{
  __weak IBOutlet UINavigationItem *navigationItem;
  __weak IBOutlet UITabBar *myTabBar;
  UIView *menuView;
  UILabel *introductionLabel;
  UILabel *followLabel;//关注
  UILabel *fanLabel;
  UILabel *recipeLabel;
  UIButton *introductionBtn;
  UIButton *followBtn;
  UIButton *fanBtn;
  UIButton *recipeBtn;
  
  UIViewController *currentViewController;
  MyIntroductionViewController *myIntroductionViewController;
  MyFollowViewController *myFollowViewController;
}

@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UILabel *introductionLabel;
@property (strong, nonatomic) IBOutlet UILabel *followLabel;
@property (strong, nonatomic) IBOutlet UILabel *fanLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipeLabel;
@property (strong, nonatomic) IBOutlet UIButton *introductionBtn;
@property (strong, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic) IBOutlet UIButton *fanBtn;
@property (strong, nonatomic) IBOutlet UIButton *recipeBtn;

@end
