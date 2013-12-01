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
@synthesize myTableView,netOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    curPage = 0;
    ordersArray = [[NSMutableArray alloc] init];
    bShouldRefresh = TRUE;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self autoLayout];

  self.navigationItem.title = @"我的购买";
  [self setLeftButton];

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  viewFrame.size.width = _sideWindowWidth;
  [self.view setFrame:viewFrame];
  self.view.autoresizesSubviews = NO;

  CGRect tableFrame = self.myTableView.frame;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  tableFrame.size.width = _sideWindowWidth;
  [self.myTableView setFrame:tableFrame];

  mLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  [mLoadingActivity setCenter:CGPointMake(_sideWindowWidth/2, 25)];
  [mLoadingActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [mLoadingActivity stopAnimating];
  [self initLoadingView];

  refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
  [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor colorWithRed:120.0 / 255.0 green:120.0 / 255.0 blue:120.0 / 255.0 alpha:1.0];

  [self getHistoryDeal];
}

- (void)initLoadingView {
  CGRect frame = self.myTableView.tableFooterView.frame;
  frame.size.height = 50;
  self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
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
  [self initLoadingView];
  [self.myTableView reloadData];
  [self getHistoryDeal];
}

- (void)setLeftButton {
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
  NSDate *date = [NSDate date];
  NSDate *oldDate = [date dateByAddingTimeInterval:-60*60*24*30*6];
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd"];
  NSString *strDate = [dateFormat stringFromDate:date];
  NSString *strOldDate = [dateFormat stringFromDate:oldDate];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [dict setObject:strOldDate forKey:@"start_day"];
  [dict setObject:strDate forKey:@"end_day"];
  [dict setObject:[NSString stringWithFormat:@"%d",curPage + 1] forKey:@"page"];
  
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getHistoryDealWithDict:dict
                       completionHandler:^(NSMutableDictionary *resultDic){
                         [self getHistoryDealCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error){}];
  
}

- (void)getHistoryDealCallBack:(NSMutableDictionary *)resultDic
{
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
  else if (result == GC_Failed)
  {
    if ([refreshControl isRefreshing]) {
      [refreshControl endRefreshing];
    }
    [self deleteLoadingView];

    NSInteger errorCode = [[resultDic valueForKey:@"errorcode"] intValue];
    if (errorCode == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);
      [self.mm_drawerController.navigationController pushViewController:m animated:YES];
    }
  }
}

@end
