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
#import "MyFansViewController.h"

@interface HomePageController ()

@end

@implementation HomePageController
@synthesize mTabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userID from:(ViewControllerCalledFrom)calledFrom showIndex:(NSInteger)index {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    eCalledFrom = calledFrom;
    //个人简介
    MyIntroductionViewController *pIntroController = [[MyIntroductionViewController alloc] initWithNibName:@"MyIntroductionView" bundle:nil withUserID:userID from:calledFrom];
    [pIntroController.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor redColor]} forState:UIControlStateNormal];
    [pIntroController.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor blackColor]} forState:UIControlStateNormal];
    [pIntroController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Images/RecipeItemImageSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/RecipeItemImageDeSelected.png"]];
    pIntroController.tabBarItem.title = @"个人简介";
    //我的菜谱
    MyRecipesController *pMyRecipesController = [[MyRecipesController alloc] initWithNibName:@"MyRecipesView" bundle:nil];
    [pMyRecipesController.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor redColor]} forState:UIControlStateNormal];
    [pMyRecipesController.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor blackColor]} forState:UIControlStateNormal];
    [pMyRecipesController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Images/RecipeItemImageSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/RecipeItemImageDeSelected.png"]];
    pMyRecipesController.tabBarItem.title = @"我的菜谱";

    NSArray *viewControllerArray;
    if (eCalledFrom == ViewControllerCalledFromMyIndividual) {
      //我的关注
      MyFollowViewController *pFollowController = [[MyFollowViewController alloc] initWithNibName:@"MyFollowView" bundle:nil];
      [pFollowController.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor redColor]} forState:UIControlStateNormal];
      [pFollowController.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor blackColor]} forState:UIControlStateNormal];
      [pFollowController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Images/RecipeItemImageSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/RecipeItemImageDeSelected.png"]];
      pFollowController.tabBarItem.title = @"我的关注";
      //我的粉丝
      MyFansViewController *pFanController = [[MyFansViewController alloc] initWithNibName:@"MyFansView" bundle:nil];
      [pFanController.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor redColor]} forState:UIControlStateNormal];
      [pFanController.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor blackColor]} forState:UIControlStateNormal];
      [pFanController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Images/RecipeItemImageSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/RecipeItemImageDeSelected.png"]];
      pFanController.tabBarItem.title = @"我的粉丝";

      viewControllerArray = [NSArray arrayWithObjects:pIntroController, pFollowController, pFanController, pMyRecipesController, nil];
    }
    else {
      viewControllerArray = [NSArray arrayWithObjects:pIntroController, pMyRecipesController, nil];
    }

    self.viewControllers = viewControllerArray;
    self.selectedIndex = (NSUInteger) index;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  //设置tab bar背景图
  UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
  [tabBarBgView setImage:[UIImage imageNamed:@"Images/TabBarBackground.png"]];
  [tabBarBgView setContentMode:UIViewContentModeScaleToFill];
  [self.tabBar insertSubview:tabBarBgView atIndex:1];

  [self setLeftButton];

  CGRect viewFrame = self.view.frame;
  [self.view setBackgroundColor:[UIColor redColor]];
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];
  
  if([self respondsToSelector:@selector(edgesForExtendedLayout)])
  {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  else//not need in ios7......
  {
    [self.tabBar setFrame:CGRectMake(0, _screenHeight_NoStBar_NoNavBar_NoTabBar - _stateBarHeight, _screenWidth, _tabBarHeight)]; // don't know why must minus 20px...
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

#pragma mark - Navigation Button

- (void)setLeftButton {
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


- (void)returnToPrev {
  [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft withOffset:_offset animated:YES];
}


#pragma mark - Autorotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {

  return NO;
}

@end
