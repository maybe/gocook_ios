//
//  UIPanNavigationController.m
//
//  Created by Mathematix on 2/22/13.
//  Copyright (c) 2013 BadPanda. All rights reserved.
//

#import <objc/message.h>

#import "UIZoomNavigationController.h"
#import "UIImage+GenerateFromView.h"
#import "RecipeDetailController.h"

#define kPushAnimationDuration  0.4
#define kOverlayViewAlpha       0.5
#define kTransformScale         0.95


static NSString *const snapShotKey = @"snapShotKey";

@interface UIZoomNavigationController ()

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIImageView *leftSnapshotView;

@end

@implementation UIZoomNavigationController

@synthesize backgroundView = _backgroundView;
@synthesize overlayView = _overlayView;
@synthesize leftSnapshotView = _leftSnapshotView;

+ (NSString *)snapshotCachePath {
    return [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/PopSnapshots"];
}

- (void)viewDidLoad {
  self.delegate = self;
  [super viewDidLoad];
}

- (void)loadView {
  [super loadView];
  
  _backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
  _backgroundView.backgroundColor = [UIColor blackColor];
  [self.view addSubview:_backgroundView];
  
  _overlayView = [[UIView alloc] initWithFrame:self.view.frame];
  _overlayView.backgroundColor = [UIColor blackColor];
  [self.view addSubview:_overlayView];
  
  _leftSnapshotView = [[UIImageView alloc] initWithFrame:self.view.frame];
  [_leftSnapshotView setContentMode:UIViewContentModeTop];
  
  [self.view addSubview:_leftSnapshotView];

  [self hideMaskViews:YES];
}

#pragma mark -
#pragma mark - Push Action
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
  if ([self.viewControllers count]> 0 && [viewController respondsToSelector:@selector(isSupportAnimPushPop)])
  {
    BOOL returnValue = ((BOOL (*)(id, SEL))objc_msgSend)(viewController, @selector(isSupportAnimPushPop));
    if (returnValue) {
      UIImage *image = [UIImage imageFromUIView:self.view];
      [self saveSnapshot:image forViewController:self.topViewController];
    }
  }

  if ([viewController respondsToSelector:@selector(isSupportAnimPushPop)])
  {
    [self pushAnim:viewController];
  }
  else
  {
    [super pushViewController:viewController animated:animated];    
  }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
  
  UIViewController* controller;
  if ([self.topViewController respondsToSelector:@selector(isSupportAnimPushPop)])
  {
    [self popAnim];
    return self.topViewController;
  }
  else
  {
    controller = [super popViewControllerAnimated:animated];
    [self removeSnapshotForViewController:controller];
    return controller;
  }
}

#pragma mark -

- (void)pushAnim:(UIViewController *)viewController
{
  UIImage* leftImage = [self snapshotForViewController:self.topViewController];
  [super pushViewController:viewController animated:NO];

  [self showMaskViewsWithImageLeft:leftImage];
  [self.view bringSubviewToFront:viewController.view];

  [self maskViewConfigWithScale:1 alpha:0];

  CGRect frame = viewController.view.frame;
  frame.origin.x = _screenWidth;
  viewController.view.frame = frame;

  [UIView animateWithDuration:kPushAnimationDuration animations:^{
    CGFloat scale = kTransformScale;
    CGFloat alpha = kOverlayViewAlpha;
    [self maskViewConfigWithScale:scale alpha:alpha];

    CGRect frame = viewController.view.frame;
    frame.origin.x = 0;
    viewController.view.frame = frame;
  } completion:^(BOOL finished) {
    [self hideMaskViews:YES];
    [viewController.view setHidden:NO];
  }];
}


- (void)popAnim
{
  UIImage* leftImage = [self snapshotForViewController:self.viewControllers[self.viewControllers.count-2]];

  [self showMaskViewsWithImageLeft:leftImage];

  [self maskViewConfigWithScale:kTransformScale alpha:kOverlayViewAlpha];

  UIView * navigationTransitionView = self.topViewController.view.superview.superview;

  [UIView animateWithDuration:kPushAnimationDuration animations:^{
    CGRect frame = navigationTransitionView.frame;
    frame.origin.x = _screenWidth;
    navigationTransitionView.frame = frame;

    CGFloat scale = 1;
    CGFloat alpha = 0;
    [self maskViewConfigWithScale:scale alpha:alpha];

  } completion:^(BOOL finished) {
    CGRect frame = navigationTransitionView.frame;
    frame.origin.x = 0;
    navigationTransitionView.frame = frame;

    [super popViewControllerAnimated:NO];
    [self hideMaskViews:YES];
    UIViewController* controller = self.topViewController;
    [self removeSnapshotForViewController:controller];
  }];
}

#pragma mark -
- (void)maskViewConfigWithScale:(CGFloat)scale
                          alpha:(CGFloat)alpha {
    _leftSnapshotView.transform = CGAffineTransformMakeScale(scale, scale);
    _overlayView.alpha = alpha;
}

- (void)showMaskViewsWithImageLeft:(UIImage *)imageLeft {
    _leftSnapshotView.image = imageLeft;

    [self hideMaskViews:NO];
    [self.view sendSubviewToBack:_overlayView];
  [self.view sendSubviewToBack:_leftSnapshotView];
    [self.view sendSubviewToBack:_backgroundView];
}

- (void)hideMaskViews:(BOOL)hide {
    _backgroundView.hidden = hide;
    _overlayView.hidden = hide;
    _leftSnapshotView.hidden = hide;

    if (hide)
    {
        _leftSnapshotView.image = nil;
    }
}

#pragma mark - 
#pragma mark - snapshot
- (void)saveSnapshot:(UIImage *)image forViewController:(UIViewController *)controller {
    [controller setAssociativeObject:image forKey:snapShotKey];
}

- (UIImage *)snapshotForViewController:(UIViewController *)controller {
    return [controller associativeObjectForKey:snapShotKey];
}

- (void)removeSnapshotForViewController:(UIViewController *)controller {
    self.leftSnapshotView.hidden = YES;
  
  UIImage *image = [controller associativeObjectForKey:snapShotKey];
  if (image) {
    [controller setAssociativeObject:nil forKey:snapShotKey];
  }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  if ([viewController isKindOfClass:[RecipeDetailController class]])
  {
    [navigationController setNavigationBarHidden:YES animated:animated];
  }
  else
  {
    [navigationController setNavigationBarHidden:NO animated:animated];
  }
}


@end
