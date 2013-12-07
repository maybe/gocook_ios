//
//  AppDelegate.m
//  HellCook
//
//  Created by panda on 2/20/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "MainController.h"
#import "ShoppingListController.h"
#import "AccountController.h"
#import "NetManager.h"
#import "User.h"
#import "ConfigHandler.h"
#import "DBHandler.h"
#import "HCNavigationController.h"
#import "Encrypt.h"
#import "HCDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "RootNavigationController.h"

@interface AppDelegate ()
@property (nonatomic,strong) HCDrawerController * drawerController;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize leftNavController = _leftNavController;
@synthesize centerNavController = _centerNavController;
@synthesize rightNavController = _rightNavController;
@synthesize connectionTimer, done, mainRefreshTime;

typedef void (^MMDrawerGestureCompletionBlock)(MMDrawerController * drawerController, UIGestureRecognizer * gesture);

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  /*  //等待2秒进入首页
  self.connectionTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
  [[NSRunLoop currentRunLoop] addTimer:self.connectionTimer forMode:NSDefaultRunLoopMode];
  do{
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
  }while (!done);
  */
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  [[self class] GeneralStyle];
  
  [self resetCenterNavController];
  [self resetLeftNavController];
  [self resetRightNavController];

  self.drawerController = [[HCDrawerController alloc]
                               initWithCenterViewController:_centerNavController
                               leftDrawerViewController:_leftNavController
                               rightDrawerViewController:_rightNavController];
  
  [self.drawerController setShouldStretchDrawer:NO];
  [self.drawerController setShowsShadow:YES];
  self.drawerController.view.autoresizesSubviews = NO;
  self.drawerController.view.autoresizingMask = UIViewAutoresizingNone;
  [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
  [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
  self.drawerController.closeDrawerGestureModeMask ^= MMCloseDrawerGestureModePanningDrawerView;
  
  [self.drawerController
   setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
       MMDrawerControllerDrawerVisualStateBlock block;
       block = [[MMExampleDrawerVisualStateManager sharedManager]
                drawerVisualStateBlockForDrawerSide:drawerSide];
       if(block){
           block(drawerController, drawerSide, percentVisible);
       }
   }];

  [self.drawerController setGestureCompletionBlock:^(MMDrawerController *drawerController, UIGestureRecognizer *gesture) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnDrawerGestureCompletion" object:[NSNumber numberWithInteger:drawerController.openSide]];
  }];

  RootNavigationController* rootNC = [[RootNavigationController alloc] initWithRootViewController:self.drawerController];
  CGRect rootNCViewFrame = rootNC.view.frame;
  rootNCViewFrame.size.height = _screenHeight;
  rootNC.view.frame = rootNCViewFrame;
  rootNC.view.autoresizesSubviews = NO;
  rootNC.view.clipsToBounds = YES;
  rootNC.delegate = rootNC;

  if(HCSystemVersionGreaterOrEqualThan(7.0)){
      UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                            green:173.0/255.0
                                             blue:234.0/255.0
                                            alpha:1.0];
      [self.window setTintColor:tintColor];
  }
  [self.window setRootViewController: rootNC];
  
  self.window.backgroundColor = [UIColor blackColor];
  [self.window makeKeyAndVisible];
  
  //注意启动顺序
  [ConfigHandler sharedInstance];
  [DBHandler sharedInstance];
  [NetManager sharedInstance];// net manager reads host from config
  [User sharedInstance];

  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark  general style

+ (void)GeneralStyle {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
  //navigation bar
  UINavigationBar *navigationBar = [UINavigationBar appearance];
  if (HCSystemVersionGreaterOrEqualThan(7.0)) {
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBarH.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
  }
  else {
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
  }
  
  [[UINavigationBar appearance] setTitleTextAttributes: @{
                              UITextAttributeTextColor: [UIColor whiteColor],
                        UITextAttributeTextShadowColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8],
                       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.5f)],
   }];

  [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
  [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
  [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
}

- (void)disableLeftDrawer {
  self.drawerController.leftDrawerViewController = nil;
}

- (void)disableRightDrawer {
  self.drawerController.rightDrawerViewController = nil;
}

- (void)enableLeftDrawer {
  if (!self.drawerController.leftDrawerViewController)
    [self.drawerController setLeftDrawerViewController:_leftNavController];
}

- (void)enableRightDrawer {
  if (!self.drawerController.rightDrawerViewController)
    [self.drawerController setRightDrawerViewController:_rightNavController];
}




#pragma mark  setting nav

- (void)resetLeftNavController
{
  AccountController* accountController = [[AccountController alloc] initWithNibName:@"AccountView" bundle:nil];
  _leftNavController = [[HCNavigationController alloc] initWithRootViewController:accountController];
  _leftNavController.navigationBarHidden = NO;
  //_leftNavController.view.autoresizesSubviews = NO;
  _leftNavController.view.frame = CGRectMake(0, 0, _sideWindowWidth, _screenHeight);
}

- (void)resetRightNavController
{
  ShoppingListController* slController = [[ShoppingListController alloc] initWithNibName:@"ShoppingListView" bundle:nil];
  _rightNavController = [[HCNavigationController alloc] initWithRootViewController:slController];
  //_rightNavController.view.autoresizesSubviews = NO; // fix HUD not centered bug
  _rightNavController.view.frame = CGRectMake(0, 0, _sideWindowWidth, _screenHeight);
  [_rightNavController viewWillAppear:NO]; // hack by panda
}

- (void)resetCenterNavController
{
  MainController *mainController = [[MainController alloc] initWithNibName:@"MainView" bundle:nil];
  _centerNavController = [[HCNavigationController alloc] initWithRootViewController:mainController];
  CGRect viewFrame = _centerNavController.view.frame;
  viewFrame.size.height = _screenHeight;
  _centerNavController.view.frame = viewFrame;
  _centerNavController.view.autoresizesSubviews = NO;
  _centerNavController.view.clipsToBounds = YES;
  _centerNavController.delegate = _centerNavController;

  // temp drop here
  [mainController getIOSMainData];
  NSDate* cur_date = [NSDate date];
  mainRefreshTime = [cur_date timeIntervalSince1970];
}


-(void)timerFired:(NSTimer *)timer{
  done=YES;
}

@end
