//
//  MyIntroductionViewController.m
//  HellCook
//
//  Created by lxw on 13-8-3.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyIntroductionViewController.h"
#import "MyIntroductionPicCell.h"
#import "MyIntroductionIntroCell.h"
#import "NetManager.h"
#import "LoginController.h"

@interface MyIntroductionViewController ()

@end

@implementation MyIntroductionViewController
@synthesize netOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      pMyInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  CGRect tableframe = self.myTableView.frame;
  tableframe.size.height = _screenHeight_NoStBar - _navigationBarHeight;
  [self.myTableView setFrame:tableframe];

  [self getMyIntroductionData];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
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
    static NSString *CellIdentifier = @"MyIntroductionIntroCell";
    
    MyIntroductionIntroCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
      cell = [[MyIntroductionIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if ([pMyInfo count] > 0)
    {
      if (pMyInfo[@"intro"]!=[NSNull null])
      {
        [cell caculateCellHeight:pMyInfo[@"intro"]];
      }
    }
    return [cell GetCellHeight];
  }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
  {
    static NSString *CellIdentifier = @"MyIntroductionPicCell";
    
    MyIntroductionPicCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
      cell = [[MyIntroductionPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([pMyInfo count] > 0)
    {
      [cell setData:pMyInfo];
    }
        
    return cell;
  }
  else
  {
    static NSString *CellIdentifier = @"MyIntroductionIntroCell";
    
    MyIntroductionIntroCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
      cell = [[MyIntroductionIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([pMyInfo count] > 0)
    {
      if (pMyInfo[@"intro"]!=[NSNull null])
      {
        [cell caculateCellHeight:pMyInfo[@"intro"]];
      }
    }
    
    return cell;
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
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController)
    {
      [self.navigationController presentViewController:m animated:YES completion:nil];
    }
  }
}

@end
