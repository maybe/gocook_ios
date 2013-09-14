//
//  HistoryDealViewController.m
//  HellCook
//
//  Created by lxw on 13-9-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "HistoryDealViewController.h"
#import "NetManager.h"
#import "LoginController.h"
#import "HistoryDealTableViewCell.h"
#import "DealDetailViewController.h"
#import "ODRefreshControl.h"

@interface HistoryDealViewController ()

@end

@implementation HistoryDealViewController
@synthesize myTableView,netOperation,mWaitingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    curPage = 1;
    ordersArray = [[NSMutableArray alloc] init];
    bShouldRefresh = TRUE;
    [self initLoadingView];
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor colorWithRed:120.0 / 255.0 green:120.0 / 255.0 blue:120.0 / 255.0 alpha:1.0];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.navigationItem.title = @"我的购买";
  [self setLeftButton];
  
  [self getHistoryDeal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initLoadingView {
  CGRect frame = self.myTableView.tableFooterView.frame;
  frame.size.height = 50;
  self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
  mLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  [mLoadingActivity setCenter:CGPointMake(160, 25)];
  [mLoadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [self.myTableView.tableFooterView addSubview:mLoadingActivity];
  [mLoadingActivity stopAnimating];
}

- (void)showLoadingView {
  CGRect frame = self.myTableView.tableFooterView.frame;
  frame.size.height = 50;
  [self.myTableView.tableFooterView setFrame:frame];
  [mLoadingActivity startAnimating];
}

- (void)deleteLoadingView {
  CGRect frame = self.myTableView.tableFooterView.frame;
  frame.size.height = 3;
  [mLoadingActivity stopAnimating];
  [mLoadingActivity setHidden:YES];
  self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)aRefreshControl {
  [ordersArray removeAllObjects];
  curPage = 0;
  bShouldRefresh = YES;
  [self.myTableView reloadData];
  [self getHistoryDeal];
}

- (void)setLeftButton {
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

- (void)returnToPrev {
  if ([self.netOperation isExecuting]) {
    [self.netOperation cancel];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  return ordersArray.count;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 85;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"HistoryDealTableViewCell";
  
  HistoryDealTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[HistoryDealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:ordersArray[indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  DealDetailViewController *pController = [[DealDetailViewController alloc] initWithNibName:@"DealDetailView" bundle:nil withData:ordersArray[indexPath.row]];
  [self.navigationController pushViewController:pController animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  // 下拉到最底部时显示更多数据
  if (scrollView.contentOffset.y + 40 >= ((scrollView.contentSize.height - scrollView.frame.size.height))) {
    if (![self.netOperation isExecuting] && bShouldRefresh) {
      [self showLoadingView];
      [self getHistoryDeal];
    }
  }
}


- (void)getHistoryDeal
{
  [mWaitingActivity startAnimating];
  
  NSDate *date = [NSDate date];
  NSDate *oldDate = [date dateByAddingTimeInterval:-60*60*24*30*6];
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd"];
  NSString *strDate = [dateFormat stringFromDate:date];
  NSString *strOldDate = [dateFormat stringFromDate:oldDate];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [dict setObject:strDate forKey:@"start_day"];
  [dict setObject:strOldDate forKey:@"end_day"];
  [dict setObject:[NSString stringWithFormat:@"%d",curPage] forKey:@"page"];
  
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getHistoryDealWithDict:dict
                       completionHandler:^(NSMutableDictionary *resultDic){
                         [self getHistoryDealCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error){}];
  
}

- (void)getHistoryDealCallBack:(NSMutableDictionary *)resultDic
{
  [mWaitingActivity stopAnimating];
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    int totalCount = [resultDic[@"total_count"] intValue];
    totalPage = totalCount / 10 + (totalCount % 10 > 0 ? 1 : 0);
    int originSize = ordersArray.count;
    int addsize = [(NSArray *) resultDic[@"orders"] count];
    if (addsize > 0)
    {
      curPage++;
      [ordersArray addObjectsFromArray:resultDic[@"orders"]];
      
      if (originSize == 0)
      {
        [self.myTableView reloadData];
        if ([refreshControl isRefreshing]){
          [refreshControl endRefreshing];
        }
      }
      else
      {
        NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < addsize; i++)
        {
          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + originSize inSection:0];
          [indexPathArray addObject:indexPath];
        }
        
        [self.myTableView beginUpdates];
        [self.myTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
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
    if ([refreshControl isRefreshing]) {
      [refreshControl endRefreshing];
    }
    [self deleteLoadingView];
    
    LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
    m.callerClassName = NSStringFromClass([self class]);
    if (self.navigationController) {
      [self.navigationController presentViewController:m animated:YES completion:nil];
    }
  }
}

@end
