//
//  UIPanNavigationController.m
//
//  Created by Mathematix on 2/22/13.
//  Copyright (c) 2013 BadPanda. All rights reserved.
//

#import <objc/message.h>
#import <objc/runtime.h>

#import "UIZoomNavigationController.h"
#import "UIImage+GenerateFromView.h"
#import "NSObject+AssociativeObject.h"
#import <QuartzCore/QuartzCore.h>

#define kPushAnimationDuration  0.4
#define kOverlayViewAlpha       0.5
#define kTransformScale         0.95
#define kBoundaryWidthRatio     0.25


static NSString *const snapShotKey = @"snapShotKey";

@interface UIZoomNavigationController ()

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIImageView *leftSnapshotView;
@property (nonatomic, retain) UIImageView *centerSnapshotView;

@end

@implementation UIZoomNavigationController

@synthesize backgroundView = _backgroundView;
@synthesize overlayView = _overlayView;
@synthesize leftSnapshotView = _leftSnapshotView;
@synthesize centerSnapshotView = _centerSnapshotView;

+ (NSString *)snapshotCachePath {
    return [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/PopSnapshots"];
}

- (void)viewDidLoad {
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
  
  _centerSnapshotView = [[UIImageView alloc] initWithFrame:self.view.frame];
  [_centerSnapshotView setContentMode:UIViewContentModeTop];

  _centerSnapshotView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_centerSnapshotView.bounds cornerRadius:0.0f].CGPath;
  _centerSnapshotView.layer.shadowColor = [UIColor blackColor].CGColor;
  _centerSnapshotView.layer.shadowOpacity = 0.65f;
  _centerSnapshotView.layer.shadowRadius = 5.0f;
  _centerSnapshotView.layer.shadowOffset = CGSizeMake(0.0f, 0);
  _centerSnapshotView.clipsToBounds = NO;
  [self.view addSubview:_centerSnapshotView];
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
    [controller.view setHidden:NO];
    return controller;
  }
}

//- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    NSArray *popedController = [super popToViewController:viewController animated:animated];
//    for (UIViewController *vc in popedController) {
//        [self removeSnapshotForViewController:vc];
//    }
//    [self removeSnapshotForViewController:self.topViewController];
//    return popedController;
//}
//
//- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
//    NSArray *popedController = [super popToRootViewControllerAnimated:animated];
//    for (UIViewController *vc in popedController) {
//        [self removeSnapshotForViewController:vc];
//    }
//    [self removeSnapshotForViewController:self.topViewController];
//    return popedController;
//}



#pragma mark -
- (void)maskViewConfigWithScale:(CGFloat)scale
                           left:(CGFloat)left
                          alpha:(CGFloat)alpha {
    CGRect frame = _centerSnapshotView.frame;
    frame.origin.x = left;
    
    _leftSnapshotView.transform = CGAffineTransformMakeScale(scale, scale);
    _centerSnapshotView.frame = frame;
    _overlayView.alpha = alpha;
}

- (void)showMaskViewsWithImageLeft:(UIImage *)imageLeft imageCenter:(UIImage *)imageCenter {
    _leftSnapshotView.image = imageLeft;
    _centerSnapshotView.image = imageCenter;
    
    [self hideMaskViews:NO];
    [self.view bringSubviewToFront:_backgroundView];
    [self.view bringSubviewToFront:_leftSnapshotView];
    [self.view bringSubviewToFront:_overlayView];
    [self.view bringSubviewToFront:_centerSnapshotView];
}

- (void)hideMaskViews:(BOOL)hide {
    _backgroundView.hidden = hide;
    _overlayView.hidden = hide;
    _leftSnapshotView.hidden = hide;
    _centerSnapshotView.hidden = hide;
    
    if (hide)
    {
        _leftSnapshotView.image = nil;
        _centerSnapshotView.image = nil;
    }
}

- (void)pushAnim:(UIViewController *)viewController
{
  UIImage* leftImage = [self snapshotForViewController:self.topViewController];
  [self.topViewController.view setHidden:YES];
  
  [super pushViewController:viewController animated:NO];
  UIImage *centerImage = [UIImage imageFromUIView:self.view];
  [viewController.view setHidden:YES];
  
  [self showMaskViewsWithImageLeft:leftImage imageCenter:centerImage];
  
  [self maskViewConfigWithScale:1 left:320 alpha:0];
  
  [UIView animateWithDuration:kPushAnimationDuration animations:^{
    CGFloat left  = 0;
    CGFloat scale = kTransformScale;
    CGFloat alpha = kOverlayViewAlpha;
    [self maskViewConfigWithScale:scale left:left alpha:alpha];
  } completion:^(BOOL finished) {
    [self hideMaskViews:YES];
    [viewController.view setHidden:NO];
  }];
}


- (void)popAnim
{
  UIImage *centerImage = [UIImage imageFromUIView:self.view];

  [super popViewControllerAnimated:NO];
  
  UIImage* leftImage = [self snapshotForViewController:self.topViewController];
  
  [self showMaskViewsWithImageLeft:leftImage imageCenter:centerImage];

  [self maskViewConfigWithScale:kTransformScale left:0 alpha:kOverlayViewAlpha];

  [UIView animateWithDuration:kPushAnimationDuration animations:^{
    CGFloat left = self.view.frame.size.width;
    CGFloat scale = 1;
    CGFloat alpha = 0;
    [self maskViewConfigWithScale:scale left:left alpha:alpha];
  } completion:^(BOOL finished) {
    [self hideMaskViews:YES];
    UIViewController* controller = self.topViewController;
    [self removeSnapshotForViewController:controller];
    [self.topViewController.view setHidden:NO];
  }];
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


#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
