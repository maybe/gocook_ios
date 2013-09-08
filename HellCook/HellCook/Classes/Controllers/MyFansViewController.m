//
//  MyFansViewController.m
//  HellCook
//
//  Created by lxw on 13-8-8.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyFansViewController.h"
#import "NetManager.h"
#import "LoginController.h"
#import "MyFansTableViewCell.h"
#import "HomePageController.h"
#import "ODRefreshControl.h"

@interface MyFansViewController ()

@end

@implementation MyFansViewController
@synthesize netOperation;
@synthesize mLoadingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    curPage = 0;
    bShouldRefresh = TRUE;
    bSessionInvalid = FALSE;
    myFansArray = [[NSMutableArray alloc] init];
    [self initLoadingView];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self setLeftButton];
  
  refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
  [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
  
  [self getMyFansData];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.tabBarController.navigationItem.title = @"我的粉丝";
  
  [self.tabBarController.navigationItem setRightBarButtonItem:nil];
  
  if (bSessionInvalid)
  {
    bSessionInvalid = FALSE;
    [self getMyFansData];
  }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
  [myFansArray removeAllObjects];
  curPage = 0;
  bShouldRefresh = YES;
  [self.myTableView reloadData];
  [self getMyFansData];
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
  [leftBarButtonView setTitle:@"  返回 " forState:UIControlStateNormal];
  [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.tabBarController.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft withOffset:_offset animated:YES];
}


- (void)initLoadingView
{
  CGRect frame = self.myTableView.tableFooterView.frame;
  frame.size.height = 50;
  self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
  //CGFloat tablewidth = self.tableView.frame.size.width;
  mLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  [mLoadingActivity setCenter:CGPointMake(160, 25)];
  [mLoadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [self.myTableView.tableFooterView addSubview:mLoadingActivity];
  [mLoadingActivity stopAnimating];
}

- (void)showLoadingView
{
  CGRect frame = self.myTableView.tableFooterView.frame;
  frame.size.height = 50;
  [self.myTableView.tableFooterView setFrame:frame];
  [mLoadingActivity startAnimating];
}

- (void)deleteLoadingView
{
  CGRect frame = self.myTableView.tableFooterView.frame;
  frame.size.height = 3;
  [mLoadingActivity stopAnimating];
  [mLoadingActivity setHidden:YES];
  self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return myFansArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"MyFansTableViewCell";
  
  MyFansTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
  {
    cell = [[MyFansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:myFansArray[indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSMutableDictionary *pFanDict = [myFansArray objectAtIndex:indexPath.row];
  NSInteger userid = [pFanDict[@"user_id"] intValue];
  
  HomePageController* pHomePageController = [[HomePageController alloc] initWithNibName:@"HomePageView" bundle:nil withUserID:userid from:ViewControllerCalledFromMyFan showIndex:0];
  [self.tabBarController.navigationController pushViewController:pHomePageController animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  // 下拉到最底部时显示更多数据
  if(scrollView.contentOffset.y + 40 >= ((scrollView.contentSize.height - scrollView.frame.size.height)))
  {
    if (![self.netOperation isExecuting] && bShouldRefresh) {
      [self showLoadingView];
      [self getMyFansData];
    }
  }
}


#pragma mark - Net

-(void)getMyFansData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
      getMyFansDataByPage:(curPage + 1)
        completionHandler:^(NSMutableDictionary *resultDic) {
          [self getMyFansDataCallBack:resultDic];
        }
             errorHandler:^(NSError *error) {
             }
  ];
}

- (void)getMyFansDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    int totalCount = [resultDic[@"total"] intValue];
    totalPage = totalCount/10 + (totalCount % 10 > 0 ? 1 : 0);
    int originsize = myFansArray.count;
    int addsize = [(NSArray*)resultDic[@"result_users"] count];
    if (addsize > 0)
    {
      curPage++;
      [myFansArray addObjectsFromArray:resultDic[@"result_users"]];
      
      if (originsize == 0)
      {
        [self.myTableView reloadData];
        if ([refreshControl isRefreshing]){
          [refreshControl endRefreshing];
        }
      }
      else
      {
        NSMutableArray* indexpathArray = [[NSMutableArray alloc]init];
        for (int i = 0; i<addsize; i++)
        {
          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+originsize inSection:0];
          [indexpathArray addObject:indexPath];
        }
        
        [self.myTableView beginUpdates];
        [self.myTableView insertRowsAtIndexPaths:indexpathArray withRowAnimation:UITableViewRowAnimationNone];
        [self.myTableView endUpdates];
      }
    }
    
    if (curPage >= totalPage)
      bShouldRefresh = FALSE;
    if (!bShouldRefresh)
      [self deleteLoadingView];
  }
  else if (result == 1)
  {
    if ([refreshControl isRefreshing]){
      [refreshControl endRefreshing];
    }
    
    bSessionInvalid = TRUE;
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    if (self.navigationController)
    {
      [self.navigationController presentViewController:m animated:YES completion:nil];
    }
  }
}

@end
