//
//  DebugOptionController.m
//  HellCook
//
//  Created by panda on 4/1/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "DebugOptionController.h"
#import "NetManager.h"
#import "ConfigHandler.h"

@interface DebugOptionController ()

@end

@implementation DebugOptionController
@synthesize ipButton,ipField,navigationItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setLeftButton];
  
  [ipButton addTarget:self action:@selector(changeip) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundHighlighted.png"]
                               forState:UIControlStateHighlighted];
  [leftBarButtonView setTitle:@"返回" forState:UIControlStateNormal];
  [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)changeip
{
  NetManager* netManager = [NetManager sharedInstance];
  netManager.host = ipField.text;
  [netManager InitEngines];//重启
  [[[ConfigHandler sharedInstance] settingDictionary] setObject:netManager.host forKey:@"host"];
  [[ConfigHandler sharedInstance] saveSettings];
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
