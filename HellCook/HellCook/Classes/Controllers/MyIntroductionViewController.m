//
//  MyIntroductionViewController.m
//  HellCook
//
//  Created by lxw on 13-8-3.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyIntroductionViewController.h"
#import "NetManager.h"
#import "LoginController.h"
#import "MyIntroEditViewController.h"
#import "CommonDef.h"
#import "User.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "HCNavigationController.h"

@interface MyIntroductionViewController ()

@end

@implementation MyIntroductionViewController
@synthesize netOperation;
@synthesize pPicCell,pIntroCell;
@synthesize rightBarButtonItem;
@synthesize bShouldRefresh;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userid from:(ViewControllerCalledFrom)calledFrom
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      mUserID = userid;
      bShouldRefresh = YES;
      eCalledFrom = calledFrom;
      
      pMyInfo = [[NSMutableDictionary alloc] init];
      pPicCell = [[MyIntroductionPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIntroductionPicCell"];
      pIntroCell = [[MyIntroductionIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIntroductionIntroCell"];

      // check if need refresh
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnUserInfoChange:) name:@"EVT_OnUserInfoChange" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnLoginSuccess:) name:@"EVT_OnLoginSuccess" object:nil];
    }
    return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self setLeftButton];
  
  CGRect tableFrame = self.myTableView.frame;
  tableFrame.size.height = _screenHeight_NoStBar - _navigationBarHeight;
  [self.myTableView setFrame:tableFrame];
}

- (void)viewDidUnload {
  [self setMyTableView:nil];
  [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  if (eCalledFrom == ViewControllerCalledFromMyIndividual) {
    self.tabBarController.navigationItem.title = [[[User sharedInstance] account] username];
    [self setRightButton];
  } else {
    self.tabBarController.navigationItem.title = @"";
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
  }

  // get data
  if (bShouldRefresh)
  {
    bShouldRefresh = NO;
    if (eCalledFrom == ViewControllerCalledFromMyIndividual)
    {
      [self getMyIntroductionData];
    }
    else
    {
      [self getOtherIntroData];
    }
  }
}

- (void)setRightButton
{
  if (!rightBarButtonItem)
  {
    UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 30)];
    [rightBarButtonView addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"]
                                  forState:UIControlStateNormal];
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"]
                                  forState:UIControlStateHighlighted];
    [rightBarButtonView setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  }
  
  [self.tabBarController.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)edit
{
  MyIntroEditViewController *pController = [[MyIntroEditViewController alloc] initWithNibName:@"MyIntroEditView" bundle:nil data:pMyInfo];
  [self.tabBarController.navigationController pushViewController:pController animated:YES];
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
  
  [self.tabBarController.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
  if (eCalledFrom == ViewControllerCalledFromMyIndividual)
  {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    //[self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft withOffset:_offset animated:YES];
  }
  else
  {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (void)followBtnTapped
{
  if ([pPicCell.followBtn.titleLabel.text isEqual:@"已关注"]) {
    self.netOperation = [[[NetManager sharedInstance] hellEngine]
        unwatchWithUserID:mUserID
        completionHandler:^(NSMutableDictionary *resultDic) {
          [self unwatchDataCallBack:resultDic];
        }
        errorHandler:^(NSError *error) {
        }
    ];
  } else {
    self.netOperation = [[[NetManager sharedInstance] hellEngine]
        watchWithUserID:mUserID
      completionHandler:^(NSMutableDictionary *resultDic) {
        [self watchDataCallBack:resultDic];
      }
      errorHandler:^(NSError *error) {
      }
    ];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
  {
    return 150;
  }
  else
  {
    if ([pMyInfo count] > 0)
    {
      if (pMyInfo[@"intro"]!=[NSNull null])
      {
        [pIntroCell caculateCellHeight:pMyInfo[@"intro"]];
      }
    }
    return [pIntroCell GetCellHeight];
  }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
  {
    if ([pMyInfo count] > 0)
    {
      [pPicCell setData:pMyInfo];
      if (eCalledFrom==ViewControllerCalledFromMyFollow || eCalledFrom==ViewControllerCalledFromMyFan)
      {
        [pPicCell.followBtn setHidden:NO];
        if (pMyInfo[@"watch"]!=[NSNull null])
        {
          if ([pMyInfo[@"watch"] intValue] == -1)
          {
            [pPicCell.followBtn setTitle:@"未关注" forState:UIControlStateNormal];
          }
          else
          {
            [pPicCell.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
          }
        }
        else
        {
          [pPicCell.followBtn setTitle:@"未关注" forState:UIControlStateNormal];
        }
      }
    }
        
    return pPicCell;
  }
  else
  {
    if ([pMyInfo count] > 0)
    {
      if (pMyInfo[@"intro"]!=[NSNull null])
      {
        [pIntroCell caculateCellHeight:pMyInfo[@"intro"]];
      }
    }
    
    return pIntroCell;
  }
}

#pragma mark - Net

-(void)getMyIntroductionData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getMyIntroductionDataWithCompletionHandler:^(NSMutableDictionary *resultDic) {
                         [self getMyIntroductionDataCallBack:resultDic];}
                       errorHandler:^(NSError *error) {}
                       ];
}

- (void)getMyIntroductionDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success)
  {
    [pMyInfo addEntriesFromDictionary:[resultDic valueForKey:@"result_user_info"]];
    [self.myTableView reloadData];
    self.tabBarController.navigationItem.title = [[resultDic valueForKey:@"result_user_info"] valueForKey:@"nickname"];
  }
  else if (result == GC_Failed)
  {
    NSInteger error_code = [[resultDic valueForKey:@"errorcode"] intValue];
    if (error_code == GC_AuthAccountInvalid) {
      LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);
      HCNavigationController* nc = [[HCNavigationController alloc]initWithRootViewController:m];
      if (self.navigationController) {
        [self.navigationController presentViewController:nc animated:YES completion:nil];
      } else if (self.tabBarController.navigationController) {
        [self.tabBarController.navigationController presentViewController:m animated:YES completion:nil];
      }
    }
  }
}

-(void)getOtherIntroData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
            getOtherIntroWithUserID:mUserID
            completionHandler:^(NSMutableDictionary *resultDic) {
              [self getOtherIntroDataCallBack:resultDic];
            }
            errorHandler:^(NSError *error) {
            }
  ];
}

- (void)getOtherIntroDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    [pMyInfo addEntriesFromDictionary:[resultDic valueForKey:@"result_kitchen_info"]];
    [self.myTableView reloadData];
    self.tabBarController.navigationItem.title = [[resultDic valueForKey:@"result_kitchen_info"] valueForKey:@"nickname"];
  }
  else if (result == GC_Failed) {
    // TODO:
  }
}

- (void)watchDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    [pPicCell.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
  }
  else if (result == GC_Failed) {
    NSInteger error_code = [[resultDic valueForKey:@"errorcode"] intValue];
    if (error_code == GC_AuthAccountInvalid) {
      LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);
      HCNavigationController* nc = [[HCNavigationController alloc]initWithRootViewController:m];
      if (self.navigationController) {
        [self.navigationController presentViewController:nc animated:YES completion:nil];
      } else if (self.tabBarController.navigationController) {
        [self.tabBarController.navigationController presentViewController:m animated:YES completion:nil];
      }
    }
  }
}

- (void)unwatchDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    [pPicCell.followBtn setTitle:@"未关注" forState:UIControlStateNormal];
  } else {
    NSInteger error_code = [[resultDic valueForKey:@"errorcode"] intValue];
    if (error_code == GC_AuthAccountInvalid) {
      LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);
      HCNavigationController* nc = [[HCNavigationController alloc]initWithRootViewController:m];
      if (self.navigationController) {
        [self.navigationController presentViewController:nc animated:YES completion:nil];
      } else if (self.tabBarController.navigationController) {
        [self.tabBarController.navigationController presentViewController:m animated:YES completion:nil];
      }
    }
  }
}

#pragma mark - Notification Handler

-(void)OnUserInfoChange:(NSNotification *)notification
{
    bShouldRefresh = YES;
}

- (void)OnLoginSuccess:(NSNotification *)notification {
  NSString *className = (NSString *) notification.object;
  if ([className isEqualToString:NSStringFromClass([self class])]) {
    bShouldRefresh = YES;
  }
}

@end
