//
//  AppDelegate.h
//  HellCook
//
//  Created by panda on 2/20/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCNavigationController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
  NSTimer *connectionTimer; //timer对象
  BOOL done;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HCNavigationController *leftNavController;
@property (strong, nonatomic) HCNavigationController *centerNavController;
@property (strong, nonatomic) HCNavigationController *rightNavController;
@property (strong, nonatomic) UIImageView *startView;
@property (nonatomic, retain) NSTimer *connectionTimer;
@property BOOL done;

+ (void) Generalstyle;

@end
