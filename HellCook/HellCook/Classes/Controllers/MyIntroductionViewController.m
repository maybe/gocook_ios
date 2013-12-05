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
#import "User.h"
#import "UIImageView+WebCache.h"

@interface MyIntroductionViewController ()

@end

@implementation MyIntroductionViewController
@synthesize netOperation;
@synthesize pPicCell,pIntroCell;
@synthesize rightBarButtonItem;
@synthesize bShouldRefresh;
@synthesize titleName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userID AndName:(NSString *)userName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      userId = userID;
      bShouldRefresh = YES;

      titleName = [[NSString alloc] initWithFormat:@"%@", userName];

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

  [self autoLayout];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  self.tabBarController.navigationItem.title = titleName;
  if ([[[User sharedInstance] account] user_id] == userId) {
    [self setRightButton];
  } else {
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
  }

  // get data
  if (bShouldRefresh)
  {
    bShouldRefresh = NO;
    if ([[[User sharedInstance] account] user_id] == userId)
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
    UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
    [rightBarButtonView addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/EditNormalButton.png"]
                                  forState:UIControlStateNormal];
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/EditSelectButton.png"]
                                  forState:UIControlStateHighlighted];
    [rightBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  }
  
  [self.tabBarController.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)edit
{
  if ([pMyInfo count] != 0) {
    MyIntroEditViewController *pController = [[MyIntroEditViewController alloc] initWithNibName:@"MyIntroEditView" bundle:nil data:pMyInfo];
    [self.tabBarController.navigationController pushViewController:pController animated:YES];
  }
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
  if (self.navigationController.viewControllers.count == 1)
  {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
        unwatchWithUserID:userId
        completionHandler:^(NSMutableDictionary *resultDic) {
          [self unwatchDataCallBack:resultDic];
        }
        errorHandler:^(NSError *error) {
        }
    ];
  } else {
    self.netOperation = [[[NetManager sharedInstance] hellEngine]
        watchWithUserID:userId
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
    return 140;
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
      if ([[[User sharedInstance] account] user_id] != userId)
      {
        [pPicCell.followBtn setHidden:NO];
        if (pMyInfo[@"watch"]!=[NSNull null])
        {
          if ([pMyInfo[@"watch"] intValue] == E_NotMyWatch)
          {
            [pPicCell.followBtn setTitle:@"未关注" forState:UIControlStateNormal];

            [pPicCell.followBtn setBackgroundImage:[UIImage imageNamed:@"Images/AddMaterialLineNormal.png"] forState:UIControlStateNormal];
            [pPicCell.followBtn setBackgroundImage:[UIImage imageNamed:@"Images/AddMaterialLineHighLight.png"] forState:UIControlStateHighlighted];
          }
          else
          {
            [pPicCell.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [pPicCell.followBtn setBackgroundImage:[UIImage imageNamed:@"Images/GreenButtonNormal136.png"] forState:UIControlStateNormal];
            [pPicCell.followBtn setBackgroundImage:[UIImage imageNamed:@"Images/GreenButtonHighLight136.png"] forState:UIControlStateHighlighted];
          }
        }
        else
        {
          [pPicCell.followBtn setTitle:@"未关注" forState:UIControlStateNormal];
          [pPicCell.followBtn setBackgroundImage:[UIImage imageNamed:@"Images/AddMaterialLineNormal.png"] forState:UIControlStateNormal];
          [pPicCell.followBtn setBackgroundImage:[UIImage imageNamed:@"Images/AddMaterialLineHighLight.png"] forState:UIControlStateHighlighted];
        }
        [pPicCell.followBtn setHidden:NO];
      } else {
        [pPicCell.followBtn setHidden:YES];
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
    if (pMyInfo[@"intro"] == [NSNull null]) {
      pMyInfo[@"intro"] = @"暂时无个人信息哦～";
    }

    [self.myTableView reloadData];
    self.tabBarController.navigationItem.title = [[resultDic valueForKey:@"result_user_info"] valueForKey:@"nickname"];
  }
  else if (result == GC_Failed)
  {
    NSInteger error_code = [[resultDic valueForKey:@"errorcode"] intValue];
    if (error_code == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);

      if (self.navigationController) {
        [self.mm_drawerController.navigationController pushViewController:m animated:YES];
      }
    }
  }
}

-(void)getOtherIntroData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
            getOtherIntroWithUserID:userId
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
    if (pMyInfo[@"intro"] == [NSNull null]) {
      pMyInfo[@"intro"] = @"暂时无个人信息哦～";
    }

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

    [pPicCell.followBtn setBackgroundImage:[UIImage imageNamed:@"Images/GreenButtonNormal136.png"] forState:UIControlStateNormal];
    [pPicCell.followBtn setBackgroundImage:[UIImage imageNamed:@"Images/GreenButtonHighLight136.png"] forState:UIControlStateHighlighted];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnShouldRefreshKitchenInfo" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnShouldRefreshFollow" object:nil];
  }
  else if (result == GC_Failed) {
    NSInteger error_code = [[resultDic valueForKey:@"errorcode"] intValue];
    if (error_code == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);

      if (self.navigationController) {
        [self.mm_drawerController.navigationController pushViewController:m animated:YES];
      }
    }
  }
}

- (void)unwatchDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success) {
    [pPicCell.followBtn setTitle:@"未关注" forState:UIControlStateNormal];
    [pPicCell.followBtn setBackgroundImage:[UIImage imageNamed:@"Images/AddMaterialLineNormal.png"] forState:UIControlStateNormal];
    [pPicCell.followBtn setBackgroundImage:[UIImage imageNamed:@"Images/AddMaterialLineHighLight.png"] forState:UIControlStateHighlighted];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnShouldRefreshKitchenInfo" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnShouldRefreshFollow" object:nil];
  } else {
    NSInteger error_code = [[resultDic valueForKey:@"errorcode"] intValue];
    if (error_code == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);

      if (self.navigationController) {
        [self.mm_drawerController.navigationController pushViewController:m animated:YES];
      }
    }
  }
}

#pragma mark - Notification Handler

-(void)OnUserInfoChange:(NSNotification *)notification
{
  if ([[[User sharedInstance] account] user_id] == userId)
  {
    NSDictionary * dictionary = (NSDictionary*)notification.object;
    if ([[dictionary allKeys] containsObject:@"avatar"]) {
      UIImage *uploadImage = dictionary[@"avatar"];
      [pPicCell.avataImageView setImage:uploadImage];
      UserAccount *account = [[User sharedInstance] account];
      pMyInfo[@"avatar"] = account.avatar;
      [pPicCell.avataImageView setImageWithURL:[NSURL URLWithString:account.avatar] placeholderImage:uploadImage];
      pPicCell.placeHolderImage = uploadImage;

    }
    if ([[dictionary allKeys] containsObject:@"nickname"]) {
      pMyInfo[@"nickname"] = dictionary[@"nickname"];
      pPicCell.nameLabel.text = dictionary[@"nickname"];
    }
    if ([[dictionary allKeys] containsObject:@"intro"]) {
      pMyInfo[@"intro"] = dictionary[@"intro"];
      pIntroCell.introLabel.text = dictionary[@"intro"];
    }
  }
}

- (void)OnLoginSuccess:(NSNotification *)notification {
  NSString *className = (NSString *) notification.object;
  if ([className isEqualToString:NSStringFromClass([self class])]) {
    bShouldRefresh = YES;
  }
}

@end
