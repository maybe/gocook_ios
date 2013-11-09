//
//  MyFollowViewController.m
//  HellCook
//
//  Created by lxw on 13-8-3.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyFollowViewController.h"
#import "NetManager.h"
#import "LoginController.h"
#import "MyFollowTableViewCell.h"
#import "HomePageController.h"
#import "ODRefreshControl.h"
#import "HCNavigationController.h"

@interface MyFollowViewController ()

@end

@implementation MyFollowViewController
@synthesize netOperation;
@synthesize mLoadingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      curPage = 0;
      firstLoad = YES;
      isPageEnd = NO;
      myFollowsArray = [[NSMutableArray alloc] init];
      [self initLoadingView];
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tabBarController.navigationItem setRightBarButtonItem:nil];
  refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
  [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.tabBarController.navigationItem.title = @"我的关注";
  
  if (firstLoad)
  {
    firstLoad = NO;
    [self getMyFollowData];
  }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)aRefreshControl
{
  [myFollowsArray removeAllObjects];
  curPage = 0;
  isPageEnd = NO;
  [self.myTableView reloadData];
  [self getMyFollowData];
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
  return myFollowsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"MyFollowTableViewCell";
  
  MyFollowTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
  {
    cell = [[MyFollowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:myFollowsArray[(NSUInteger)indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSMutableDictionary *pFollowDict = [myFollowsArray objectAtIndex:(NSUInteger)indexPath.row];
  NSInteger userid = [pFollowDict[@"user_id"] intValue];
  
  HomePageController* pHomePageController = [[HomePageController alloc] initWithNibName:@"HomePageView" bundle:nil withUserID:userid from:ViewControllerCalledFromMyFollow showIndex:0];
  [self.tabBarController.navigationController pushViewController:pHomePageController animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  // 下拉到最底部时显示更多数据
  if(scrollView.contentOffset.y + 40 >= ((scrollView.contentSize.height - scrollView.frame.size.height)))
  {
    if (![self.netOperation isExecuting] && !isPageEnd) {
      [self showLoadingView];
      [self getMyFollowData];
    }
  }
}



#pragma mark - Net

-(void)getMyFollowData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
      getMyFollowDataByPage:(curPage + 1)
          completionHandler:^(NSMutableDictionary *resultDic) {
            [self getMyFollowDataCallBack:resultDic];
          }
               errorHandler:^(NSError *error) {
               }
  ];
}

- (void)getMyFollowDataCallBack:(NSMutableDictionary*) resultDic
{
  if ([refreshControl isRefreshing]) {
    [refreshControl endRefreshing];
  }

  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success)
  {
    int totalCount = [resultDic[@"total"] intValue];
    totalPage = totalCount/10 + (totalCount % 10 > 0 ? 1 : 0);
    int originsize = myFollowsArray.count;
    int addsize = [(NSArray*)resultDic[@"result_users"] count];
    if (addsize > 0)
    {
      curPage++;
      [myFollowsArray addObjectsFromArray:resultDic[@"result_users"]];
      
      if (originsize == 0)
      {
        [self.myTableView reloadData];
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
      isPageEnd = YES;
    if (isPageEnd)
      [self deleteLoadingView];
  }
  else if (result == GC_Failed)
  {
    if ([refreshControl isRefreshing]){
      [refreshControl endRefreshing];
    }

    NSInteger errorCode = [[resultDic valueForKey:@"errorcode"] intValue];
    if (errorCode == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);

      if (self.navigationController) {
        [self.mm_drawerController.navigationController pushViewController:m animated:YES];
      }
    }
  }
}


@end
