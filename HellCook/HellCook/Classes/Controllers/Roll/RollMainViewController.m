//
//  RollMainViewController.m
//  HellCook
//
//  Created by lxw on 13-11-4.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "RollMainViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface RollMainViewController ()

@end

@implementation RollMainViewController
@synthesize backgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      //backgroundView
      backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
      [backgroundView setImage:[UIImage imageNamed:@"Images/RollBackground.png"]];
      [backgroundView setContentMode:UIViewContentModeScaleToFill];
      [self.view addSubview:backgroundView];
    }
    return self;
}

- (void)viewDidLoad
{
  [self autoLayout];
  [super viewDidLoad];
  [self setLeftButton];
}

- (void) viewWillAppear:(BOOL)animated
{
  self.title = @"摇一摇";
  [super viewWillAppear:animated];
  [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self resignFirstResponder];
}

- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/BackButtonNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/BackButtonHighLight.png"]
                               forState:UIControlStateHighlighted];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
  [self resignFirstResponder];
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma Roll Delegate
- (BOOL)canBecomeFirstResponder
{
  return YES;// default is NO
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  NSLog(@"开始摇动手机");
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示：" message:@"您摇动了手机，想干嘛？" delegate:nil cancelButtonTitle:@"CANCEL" otherButtonTitles:nil];
  [alert show];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  NSLog(@"取消");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {

  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {

  return UIInterfaceOrientationMaskPortrait;
}
@end
