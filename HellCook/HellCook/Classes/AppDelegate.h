//
//  AppDelegate.h
//  HellCook
//
//  Created by panda on 2/20/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIZoomNavigationController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, PPRevealSideViewControllerDelegate>
{
  NSTimer *connectionTimer; //timer对象
  BOOL done;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@property (strong, nonatomic) UINavigationController *leftNavController;
@property (strong, nonatomic) UIZoomNavigationController *centerNavController;
@property (strong, nonatomic) UINavigationController *rightNavController;
@property (strong, nonatomic) UIImageView *startView;
@property (nonatomic, retain) NSTimer *connectionTimer;
@property BOOL done;

+ (void) Generalstyle;

@end
