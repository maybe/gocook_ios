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
  
  //设置tabbar背景图
  UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:myTabBar.bounds];
  [tabBarBgView setImage:[UIImage imageNamed:@"Images/TabBarBackground.png"]];
  [tabBarBgView setContentMode:UIViewContentModeScaleToFill];
  [myTabBar insertSubview:tabBarBgView atIndex:1];
  //设置item字体颜色
  for (int i=0; i<[myTabBar.items count]; i++)
  {
    [(UITabBarItem*)[myTabBar.items objectAtIndex:0] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor redColor] } forState:UIControlStateNormal];
    [(UITabBarItem*)[myTabBar.items objectAtIndex:0] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor blackColor] } forState:UIControlStateNormal];
  }
  //设置item背景图
  [[myTabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"Images/RecipeItemImageSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/RecipeItemImageDeSelected.png"]];
  
  self.navigationItem.title = [[[User sharedInstance] account] username];
  [self setLeftButton];
  [self setRightButton];
  [myTabBar setSelectedItem:[myTabBar.items objectAtIndex:0]];
  [self changeToMyIntroductionViewController];

  CGRect viewframe = self.view.frame;
  viewframe.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewframe];
    
  [myTabBar setFrame:CGRectMake(0, _screenHeight - _tabBarHeight - _navigationBarHeight - _stateBarHeight, _screenWidth, _tabBarHeight)];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  myTabBar = nil;
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
  [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft withOffset:_offset animated:YES];
}

-(void)onEdit
{
  
}

- (void)changeToMyIntroductionViewController
{
  if (myIntroductionViewController == nil)
  {
    myIntroductionViewController =
    [[MyIntroductionViewController alloc] initWithNibName:@"MyIntroductionView" bundle:nil];
  }
  [self.view insertSubview:myIntroductionViewController.view belowSubview:myTabBar];
  
  if (currentViewController != nil)
    [currentViewController.view removeFromSuperview];
  currentViewController = myIntroductionViewController;
}

- (void)changeToMyFollowViewController
{
  if (myFollowViewController == nil)
  {
    myFollowViewController =
    [[MyFollowViewController alloc] initWithNibName:@"MyFollowView" bundle:nil];
  }
  [self.view insertSubview:myFollowViewController.view belowSubview:myTabBar];
  
  if (currentViewController != nil)
    [currentViewController.view removeFromSuperview];
  currentViewController = myFollowViewController;
}


#pragma TabBar Delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
  switch ( item.tag )
  {
    case 0://个人简介
    {
      [self changeToMyIntroductionViewController];
      break;
    }
    case 1://关注
    {
      [self changeToMyFollowViewController];
      break;
    }
      break;
    case 2://粉丝
      break;
    case 3://菜谱
      break;
  }
  
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
  
  return NO;
}

@end
