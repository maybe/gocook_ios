//
//  HomePageController.m
//  HellCook
//
//  Created by panda on 8/4/13.
//  Copyright (c) 2013 panda. All ws reserved.
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userID AndName:(NSString *)userName showIndex:(NSInteger)index {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    //个人简介
    MyIntroductionViewController *pIntroController = [[MyIntroductionViewController alloc] initWithNibName:@"MyIntroductionView" bundle:nil withUserID:userID AndName:userName];
    [pIntroController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Images/IntroductionSelectTab.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/IntroductionNormalTab.png"]];
    pIntroController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, -1, -6, 0);
    //我的菜谱
    MyRecipesController *pMyRecipesController = [[MyRecipesController alloc] initWithNibName:@"MyRecipesView" bundle:nil withUserID:userID AndName:userName];
    [pMyRecipesController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Images/MyRecipesSelectTab.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/MyRecipesNormalTab.png"]];
    pMyRecipesController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, -1);

    NSArray *viewControllerArray;
    //我的关注
    MyFollowViewController *pFollowController = [[MyFollowViewController alloc] initWithNibName:@"MyFollowView" bundle:nil withUserID:userID AndName:userName];
    [pFollowController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Images/MyFollowSelectTab.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/MyFollowNormalTab.png"]];
    pFollowController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //我的粉丝
    MyFansViewController *pFanController = [[MyFansViewController alloc] initWithNibName:@"MyFansView" bundle:nil withUserID:userID AndName:userName];
    [pFanController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Images/MyFanSelectTab.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Images/MyFanNormalTab.png"]];
    pFanController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    viewControllerArray = [NSArray arrayWithObjects:pIntroController, pFollowController, pFanController, pMyRecipesController, nil];

    self.viewControllers = viewControllerArray;
    self.selectedIndex = (NSUInteger) index;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setLeftButton];

  CGRect viewFrame = self.view.frame;
  [self.view setBackgroundColor:[UIColor redColor]];
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];


  if (!HCSystemVersionGreaterOrEqualThan(7))
  {
    [self.tabBar setFrame:CGRectMake(0, _screenHeight_NoStBar_NoNavBar_NoTabBar - _stateBarHeight, _screenWidth, _tabBarHeight)]; // don't know why must minus 20px...
  }

  [self autoLayout];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

#pragma mark - Navigation Button

- (void)setLeftButton {
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
      [UIImage imageNamed:@"Images/BackButtonNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
      [UIImage imageNamed:@"Images/BackButtonHighLight.png"]
                               forState:UIControlStateHighlighted];

  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];

  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}


- (void)returnToPrev {
  // [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark - Autorotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {

  return NO;
}

@end
