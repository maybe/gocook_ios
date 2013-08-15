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

@interface MyIntroductionViewController ()

@end

@implementation MyIntroductionViewController
@synthesize netOperation;
@synthesize pPicCell,pIntroCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isMyself:(BOOL)isMyself withUserID:(NSInteger)userid fromMyFollow:(BOOL)fromFollow
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      mUserID = userid;
      bMyself = isMyself;
      bFromFollow = fromFollow;
      bSessionInvalid = FALSE;
      
      pMyInfo = [[NSMutableDictionary alloc] init];
      pPicCell = [[MyIntroductionPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIntroductionPicCell"];
      pIntroCell = [[MyIntroductionIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIntroductionIntroCell"];
      
      if (bMyself)
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
  [self setRightButton];
  CGRect tableframe = self.myTableView.frame;
  tableframe.size.height = _screenHeight_NoStBar - _navigationBarHeight;
  [self.myTableView setFrame:tableframe];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
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
  
  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
  
  [self.tabBarController.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)edit
{
  MyIntroEditViewController *pController = [[MyIntroEditViewController alloc] initWithNibName:@"MyIntroEditView" bundle:nil data:pMyInfo];
  [self.tabBarController.navigationController pushViewController:pController animated:YES];
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
      if (!bMyself && bFromFollow)
      {
        [pPicCell.followBtn setHidden:NO];
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
    [pPicCell.followBtn setTitle:@"已取消关注" forState:UIControlStateNormal];
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
