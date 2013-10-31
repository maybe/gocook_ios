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

@interface AppDelegate ()
@property (nonatomic,strong) HCDrawerController * drawerController;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize leftNavController = _leftNavController;
@synthesize centerNavController = _centerNavController;
@synthesize rightNavController = _rightNavController;
@synthesize connectionTimer, done;


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
  
  [[self class] Generalstyle];
  
  [self resetCenterNavController];
  [self resetLeftNavController];
  [self resetRightNavController];
  
  if(HCSystemVersionGreaterOrEqualThan(7.0)){
      self.drawerController = [[HCDrawerController alloc]
                               initWithCenterViewController:_centerNavController
                               leftDrawerViewController:_leftNavController
                               rightDrawerViewController:_rightNavController];
  }
  else{
      self.drawerController = [[HCDrawerController alloc]
                               initWithCenterViewController:_centerNavController
                               leftDrawerViewController:_leftNavController
                               rightDrawerViewController:_rightNavController];
  }
  
  [self.drawerController setShouldStretchDrawer:NO];
  [self.drawerController setShowsShadow:YES];
  //[self.drawerController setMaximumRightDrawerWidth:280.0];
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
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  if(HCSystemVersionGreaterOrEqualThan(7.0)){
      UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                            green:173.0/255.0
                                             blue:234.0/255.0
                                            alpha:1.0];
      [self.window setTintColor:tintColor];
  }
  [self.window setRootViewController:self.drawerController];
  
  self.window.backgroundColor = [UIColor blackColor];
  [self.window makeKeyAndVisible];
  
  //注意启动顺序
  [ConfigHandler sharedInstance];
  [DBHandler sharedInstance];
  [NetManager sharedInstance];// net manager reads host from config
  [User sharedInstance];
  
  //NSString* decrypt = [Encrypt tripleDES:@"111111" encryptOrDecrypt:kCCEncrypt key:@"DAB578EC-6C01-4180-939A-37E6BE8A81AF" initVec:@"117A5C0F"];
  //NSLog(@"%@", decrypt);

  //NSString* encr = [Encrypt EncryptAppReqCMD:1 WithData:@"{\"Account\":\"15000021036\",\"Password\":\"rmHSyDSm1Dk=\"}"];
  //NSLog(@"%@", encr);

  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  
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

+ (void)Generalstyle {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
  //navigationbar
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
}


#pragma mark  setting nav

- (void)resetLeftNavController
{
  AccountController* accountController = [[AccountController alloc] initWithNibName:@"AccountView" bundle:nil];
  _leftNavController = [[HCNavigationController alloc] initWithRootViewController:accountController];
  _leftNavController.navigationBarHidden = NO;
  _leftNavController.view.clipsToBounds = YES;
  _leftNavController.navigationBar.clipsToBounds = YES;
  _leftNavController.view.bounds = CGRectMake(0, 0, _sideWindowWidth, _screenHeight_NoStBar);
}

- (void)resetRightNavController
{
  ShoppingListController* slController = [[ShoppingListController alloc] initWithNibName:@"ShoppingListView" bundle:nil];
  _rightNavController = [[HCNavigationController alloc] initWithRootViewController:slController];
  _rightNavController.navigationBarHidden = NO;
  _rightNavController.view.clipsToBounds = YES;
  _rightNavController.navigationBar.clipsToBounds = YES;
  _rightNavController.view.frame = CGRectMake(40, 0, _sideWindowWidth, _screenHeight_NoStBar);
}

- (void)resetCenterNavController
{
  MainController *mainController = [[MainController alloc] initWithNibName:@"MainView" bundle:nil];
  _centerNavController = [[HCNavigationController alloc] initWithRootViewController:mainController];
  CGRect viewframe = _centerNavController.view.frame;
  viewframe.size.height = _screenHeight;
  [_centerNavController.view setFrame:viewframe];
  _centerNavController.view.autoresizesSubviews = NO;
}


-(void)timerFired:(NSTimer *)timer{
  done=YES;
}

@end
