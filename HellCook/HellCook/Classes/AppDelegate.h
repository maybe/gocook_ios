//
//  AppDelegate.h
//  HellCook
//
//  Created by panda on 2/20/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppKey @"4111016334"
#define kredirectURI @"http://www.sina.com"
#define wAppKey @"wx7f107feec858046e"

@class HCNavigationController;
@class ShareController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
  NSTimer *connectionTimer; //timer对象
  BOOL done;
  NSTimeInterval mainRefreshTime;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HCNavigationController *leftNavController;
@property (strong, nonatomic) HCNavigationController *centerNavController;
@property (strong, nonatomic) HCNavigationController *rightNavController;
@property (strong, nonatomic) ShareController *shareController;
@property (strong, nonatomic) UIImageView *startView;
@property (nonatomic, retain) NSTimer *connectionTimer;
@property BOOL done;
@property NSTimeInterval mainRefreshTime;

+ (void)GeneralStyle;

- (void)disableLeftDrawer;
- (void)disableRightDrawer;
- (void)enableLeftDrawer;
- (void)enableRightDrawer;

- (void)showShareView;
- (void)hideShareView;
@end
