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
#import "HomePageController.h"
#import "User.h"

@interface MyIntroductionViewController ()

@end

@implementation MyIntroductionViewController
@synthesize netOperation;
@synthesize pPicCell,pIntroCell;
@synthesize rightBarButtonItem;
@synthesize bSessionInvalid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userid from:(ViewControllerCalledFrom)calledFrom
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      mUserID = userid;
      bSessionInvalid = FALSE;
      eCalledFrom = calledFrom;
      
      pMyInfo = [[NSMutableDictionary alloc] init];
      pPicCell = [[MyIntroductionPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIntroductionPicCell"];
      pIntroCell = [[MyIntroductionIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIntroductionIntroCell"];
      
      if (eCalledFrom == ViewControllerCalledFromMyIndividual)
      {
        [self getMyIntroductionData];
      }
      else
      {
        [self getOtherIntroData];
      }
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
//  self.tabBarController.navigationItem.title = @"个人简介";
//  [self setRightButton];
  
  [self setLeftButton];
  
  CGRect tableframe = self.myTableView.frame;
  tableframe.size.height = _screenHeight_NoStBar - _navigationBarHeight;
  [self.myTableView setFrame:tableframe];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.tabBarController.navigationItem.title = [[[User sharedInstance] account] username];
  
  if (eCalledFrom == ViewControllerCalledFromMyIndividual)
  {
    [self setRightButton];
  }
  else
  {
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
  }
  
  if (bSessionInvalid)
  {
    bSessionInvalid = FALSE;
    [self getMyIntroductionData];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
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
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundHighlighted.png"]
                               forState:UIControlStateHighlighted];
  [leftBarButtonView setTitle:@"  返回 " forState:UIControlStateNormal];
  [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.tabBarController.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
  if (eCalledFrom == ViewControllerCalledFromMyIndividual)
  {
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft withOffset:_offset animated:YES];
  }
  else
  {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (void)followBtnTapped
{
  if ([pPicCell.followBtn.titleLabel.text isEqual:@"已关注"])
  {
    self.netOperation = [[[NetManager sharedInstance] hellEngine]
                         unwatchWithUserID:mUserID
                         CompletionHandler:^(NSMutableDictionary *resultDic) {
                           [self unwatchDataCallBack:resultDic];
                         }
                         errorHandler:^(NSError *error) {}
                         ];
  }
  else
  {
    self.netOperation = [[[NetManager sharedInstance] hellEngine]
                         watchWithUserID:mUserID
                         CompletionHandler:^(NSMutableDictionary *resultDic) {
                           [self watchDataCallBack:resultDic];
                         }
                         errorHandler:^(NSError *error) {}
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
  if (result == 0)
  {
    [pMyInfo addEntriesFromDictionary:[resultDic valueForKey:@"result_user_info"]];
    
    [self.myTableView reloadData];
  }
  else if (result == 1)
  {
    bSessionInvalid = TRUE;
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController)
    {
      [self.navigationController presentViewController:m animated:YES completion:nil];
    }
  }
}

-(void)getOtherIntroData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getOtherIntroWithUserID:mUserID
                             CompletionHandler:^(NSMutableDictionary *resultDic) {
                                         [self getOtherIntroDataCallBack:resultDic];
                                         }
                                  errorHandler:^(NSError *error) {}
                       ];
}

- (void)getOtherIntroDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    [pMyInfo addEntriesFromDictionary:[resultDic valueForKey:@"result_kitchen_info"]];
    
    [self.myTableView reloadData];
  }
  else if (result == 1)
  {
    bSessionInvalid = TRUE;
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController)
    {
      [self.navigationController presentViewController:m animated:YES completion:nil];
    }
  }
}

- (void)watchDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    [pPicCell.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
  }
  else if (result == 1)
  {
    bSessionInvalid = TRUE;
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController)
    {
      [self.navigationController presentViewController:m animated:YES completion:nil];
    }
  }
}

- (void)unwatchDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    [pPicCell.followBtn setTitle:@"未关注" forState:UIControlStateNormal];
  }
  else if (result == 1)
  {
    bSessionInvalid = TRUE;
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController)
    {
      [self.navigationController presentViewController:m animated:YES completion:nil];
    }
  }
}

@end
