//
//  MyselfRootViewController.m
//  HellCook
//
//  Created by lxw on 13-8-1.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyselfRootViewController.h"
#import "User.h"

@interface MyselfRootViewController ()

@end

@implementation MyselfRootViewController
@synthesize menuView,introductionLabel,followLabel,fanLabel,recipeLabel,introductionBtn,followBtn,fanBtn,recipeBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //设置tabbar背景图
  UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:tabBar.bounds];
  [tabBarBgView setImage:[UIImage imageNamed:@"Images/TabBarBackground.png"]];
  [tabBarBgView setContentMode:UIViewContentModeScaleToFill];
  [tabBar insertSubview:tabBarBgView atIndex:1];
  //设置item字体颜色
  for (int i=0; i<[tabBar.items count]; i++)
  {
    [(UITabBarItem*)[tabBar.items objectAtIndex:0] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor redColor] } forState:UIControlStateNormal];
    [(UITabBarItem*)[tabBar.items objectAtIndex:0] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor blackColor] } forState:UIControlStateNormal];
  }
  //设置item背景图
  [[tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"Images/RecipeItemImageSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/RecipeItemImageDeSelected.png"]];
  
  self.navigationItem.title = [[[User sharedInstance] account] username];
  [self setLeftButton];
  [self setRightButton];
  [tabBar setSelectedItem:[tabBar.items objectAtIndex:0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  tabBar = nil;
  navigationItem = nil;
  [super viewDidUnload];
}



#pragma mark - Navi Button

- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundHighlighted.png"]
                               forState:UIControlStateHighlighted];
  [leftBarButtonView setTitle:@"  返回 " forState:UIControlStateNormal];
  [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)setRightButton
{
  UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 30)];
  [rightBarButtonView addTarget:self action:@selector(onEdit) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"]
                                forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"]
                                forState:UIControlStateHighlighted];
  [rightBarButtonView setTitle:@"编辑" forState:UIControlStateNormal];
  [rightBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  
  [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)returnToPrev
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onEdit
{
  
}



#pragma TabBar Delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
  switch ( item.tag )
  {
    case 0://个人简介
      break;
    case 1://关注
      break;
    case 2://粉丝
      break;
    case 3://菜谱
      break;
  }
}

@end
