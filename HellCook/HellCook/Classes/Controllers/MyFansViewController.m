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
#import "User.h"

@interface MyFansViewController ()

@end

@implementation MyFansViewController
@synthesize netOperation;
@synthesize mLoadingActivity;
@synthesize titleName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userID AndName:(NSString *)userName
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    curPage = 0;
    firstLoad = YES;
    isPageEnd = NO;
    userId = userID;
    myFansArray = [[NSMutableArray alloc] init];
    titleName = [[NSString alloc] initWithFormat:@"%@的粉丝", userName];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self autoLayout];

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];

  CGRect tableFrame = self.myTableView.frame;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.myTableView setFrame:tableFrame];

  [self setLeftButton];
  
  refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
  [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnShouldRefreshHPFans) name:@"EVT_OnShouldRefreshFollow" object:nil];

  [self initLoadingView];
}

- (void) OnShouldRefreshHPFans
{
  firstLoad = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  if ([[[User sharedInstance] account] user_id] == userId) {
    self.tabBarController.navigationItem.title = @"我的粉丝";
  } else {
    self.tabBarController.navigationItem.title = titleName;
  }

  [self.tabBarController.navigationItem setRightBarButtonItem:nil];
  
  if (firstLoad) {
    firstLoad = NO;
    curPage = 0;
    isPageEnd = NO;
    [myFansArray removeAllObjects];
    [_myTableView reloadData];
    [self getUserFansData];
  }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)aRefreshControl
{
  [myFansArray removeAllObjects];
  curPage = 0;
  isPageEnd = NO;
  [self.myTableView reloadData];
  [self getUserFansData];
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
  return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"MyFansTableViewCell";
  
  MyFansTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
  {
    cell = [[MyFansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:myFansArray[(NSUInteger)indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSMutableDictionary *pFanDict = [myFansArray objectAtIndex:(NSUInteger)indexPath.row];
  NSInteger user_id = [pFanDict[@"user_id"] intValue];
  NSString* user_name = pFanDict[@"name"];

  HomePageController* pHomePageController = [[HomePageController alloc] initWithNibName:@"HomePageView" bundle:nil withUserID:user_id AndName:user_name showIndex:0];
  [self.tabBarController.navigationController pushViewController:pHomePageController animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  // 下拉到最底部时显示更多数据
  if(scrollView.contentOffset.y + 40 >= ((scrollView.contentSize.height - scrollView.frame.size.height)))
  {
    if (![self.netOperation isExecuting] && !isPageEnd) {
      [self showLoadingView];
      [self getUserFansData];
    }
  }
}


#pragma mark - Net

-(void)getUserFansData
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
      getMyFansDataByPage:(curPage + 1)
        WithUserID:userId
        completionHandler:^(NSMutableDictionary *resultDic) {
          [self getUserFansDataCallBack:resultDic];
        }
             errorHandler:^(NSError *error) {
             }
  ];
}

- (void)getUserFansDataCallBack:(NSMutableDictionary*) resultDic
{
  if ([refreshControl isRefreshing]) {
    [refreshControl endRefreshing];
  }

  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0) {
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
      isPageEnd = YES;

    if (isPageEnd)
      [self deleteLoadingView];
  }
  else if (result == 1)
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
