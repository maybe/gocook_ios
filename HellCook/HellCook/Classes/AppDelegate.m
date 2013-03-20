//
//  AppDelegate.m
//  HellCook
//
//  Created by panda on 2/20/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize revealSideViewController = _revealSideViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainViewController *main = [[MainViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
    
    self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
    [self.revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionContentView | PPRevealSideInteractionNavigationBar];
    
    self.window.rootViewController = self.revealSideViewController;
    
    HC_RELEASE(main);
    HC_RELEASE(nav);
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[self class] Generalstyle];
    
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

+ (void)Generalstyle {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    //navigationbar
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    
}

@end
