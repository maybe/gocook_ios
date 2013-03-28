//
//  AppDelegate.h
//  HellCook
//
//  Created by panda on 2/20/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, PPRevealSideViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@property (strong, nonatomic) UINavigationController *leftNavController;
@property (strong, nonatomic) UINavigationController *centerNavController;
@property (strong, nonatomic) UINavigationController *rightNavController;


+ (void) Generalstyle;

@end
