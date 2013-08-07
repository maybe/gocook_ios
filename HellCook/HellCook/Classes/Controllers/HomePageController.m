//
//  HomePageController.m
//  HellCook
//
//  Created by panda on 8/4/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "HomePageController.h"
#import "MyIntroductionViewController.h"
#import "MyFollowViewController.h"
#import "MyRecipesController.h"

@interface HomePageController ()

@end

@implementation HomePageController
@synthesize mTabBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //设置tabbar背景图
  UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
  [tabBarBgView setImage:[UIImage imageNamed:@"Images/TabBarBackground.png"]];
  [tabBarBgView setContentMode:UIViewContentModeScaleToFill];
  [self.tabBar insertSubview:tabBarBgView atIndex:1];
  
  MyIntroductionViewController* pIntroController = [[MyIntroductionViewController alloc] initWithNibName:@"MyIntroductionView" bundle:nil];
  [pIntroController.tabBarItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor redColor] } forState:UIControlStateNormal];
  [pIntroController.tabBarItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor blackColor] } forState:UIControlStateNormal];
  [pIntroController.tabBarItem  setFinishedSelectedImage:[UIImage imageNamed:@"Images/RecipeItemImageSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/RecipeItemImageDeSelected.png"]];
  pIntroController.tabBarItem.title = @"个人介绍";
  
  MyFollowViewController* pFollowController = [[MyFollowViewController alloc] initWithNibName:@"MyFollowView" bundle:nil];
  [pFollowController.tabBarItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor redColor] } forState:UIControlStateNormal];
  [pFollowController.tabBarItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor blackColor] } forState:UIControlStateNormal];
  [pFollowController.tabBarItem  setFinishedSelectedImage:[UIImage imageNamed:@"Images/RecipeItemImageSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/RecipeItemImageDeSelected.png"]];
  pFollowController.tabBarItem.title = @"我的粉丝";

  MyRecipesController* pMyRecipesController = [[MyRecipesController alloc] initWithNibName:@"MyRecipesView" bundle:nil];
  [pMyRecipesController.tabBarItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor redColor] } forState:UIControlStateNormal];
  [pMyRecipesController.tabBarItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor blackColor] } forState:UIControlStateNormal];
  [pMyRecipesController.tabBarItem  setFinishedSelectedImage:[UIImage imageNamed:@"Images/RecipeItemImageSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/RecipeItemImageDeSelected.png"]];
  pMyRecipesController.tabBarItem.title = @"我的菜谱";
  
  NSArray *viewControllerArray = [NSArray arrayWithObjects:pIntroController, pFollowController, pMyRecipesController, nil];
  self.viewControllers = viewControllerArray;
    
  //self.navigationItem.title = [[[User sharedInstance] account] username];
  
  [self setLeftButton];
  [self setRightButton];
  
  CGRect viewframe = self.view.frame;
  [self.view setBackgroundColor:[UIColor redColor]];
  viewframe.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewframe];
  
  [self.tabBar setFrame:CGRectMake(0, _screenHeight_NoStBar_NoNavBar_NoTabBar - _stateBarHeight, _screenWidth, _tabBarHeight)]; // don't know why must minus 20px...
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


#pragma mark - Autorotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
  
  return NO;
}

@end
