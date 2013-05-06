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
#import "UIZoomNavigationController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize revealSideViewController = _revealSideViewController;
@synthesize leftNavController = _leftNavController;
@synthesize centerNavController = _centerNavController;
@synthesize rightNavController = _rightNavController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  [[self class] Generalstyle];
  
  [self resetCenterNavController];
  [self resetLeftNavController];
  [self resetRightNavController];
  
  [self resetRevealSideviewController];
  
  self.window.rootViewController = _revealSideViewController;
  
  self.window.backgroundColor = [UIColor blackColor];
  [self.window makeKeyAndVisible];
  
  [ConfigHandler sharedInstance];
  [NetManager sharedInstance];
  [DBHandler sharedInstance];
  [User sharedInstance];
  
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
  [navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
  
  [[UINavigationBar appearance] setTitleTextAttributes: @{
                              UITextAttributeTextColor: [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0],
                        UITextAttributeTextShadowColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8],
                       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.5f)],
   }];
}


#pragma mark  setting nav

- (void)resetLeftNavController
{
  AccountController* accountController = [[AccountController alloc] initWithNibName:@"AccountView" bundle:nil];
  _leftNavController = [[UINavigationController alloc] initWithRootViewController:accountController];
  _leftNavController.navigationBarHidden = NO;
  _leftNavController.view.clipsToBounds = YES;
  _leftNavController.navigationBar.clipsToBounds = YES;
  _leftNavController.view.bounds = CGRectMake(0, 0, _sideWindowWidth, _screenHeight_NoStBar);
}

- (void)resetRightNavController
{
  ShoppingListController* slController = [[ShoppingListController alloc] initWithNibName:@"ShoppingListView" bundle:nil];
  _rightNavController = [[UINavigationController alloc] initWithRootViewController:slController];
  _rightNavController.navigationBarHidden = NO;
  _rightNavController.view.clipsToBounds = YES;
  _rightNavController.navigationBar.clipsToBounds = YES;
  _rightNavController.view.frame = CGRectMake(40, 0, _sideWindowWidth, _screenHeight_NoStBar);
}

- (void)resetCenterNavController
{
  MainController *mainController = [[MainController alloc] initWithNibName:@"MainView" bundle:nil];
  _centerNavController = [[UIZoomNavigationController alloc] initWithRootViewController:mainController];
  CGRect viewframe = _centerNavController.view.frame;
  viewframe.size.height = _screenHeight;
  [_centerNavController.view setFrame:viewframe];
  _centerNavController.view.autoresizesSubviews = NO;
}

- (void)resetRevealSideviewController
{
  _revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:_centerNavController];
  _revealSideViewController.delegate = self;
  
  [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionLeft |PPRevealSideDirectionRight];
  [self.revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionContentView | PPRevealSideInteractionNavigationBar];
  [self.revealSideViewController setOption:PPRevealSideOptionsResizeSideView];
  
  [self.revealSideViewController preloadViewController:_leftNavController forSide:PPRevealSideDirectionLeft withOffset:_offset];
  [self.revealSideViewController preloadViewController:_rightNavController forSide:PPRevealSideDirectionRight withOffset:_offset];
}

@end
