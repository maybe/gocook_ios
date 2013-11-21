//
//  NewCouponsViewController.m
//  HellCook
//
//  Created by lxw on 13-11-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "NewCouponsViewController.h"
#import "LoginController.h"
#import "NetManager.h"
#import "NewCouponCell.h"
#import "ODRefreshControl.h"
#import "RollMainViewController.h"
#import "NewCouponsDetailViewController.h"
#import "BlankCell.h"

@interface NewCouponsViewController ()

@end

@implementation NewCouponsViewController
@synthesize topBtn,myTableView;
@synthesize netOperation;
@synthesize mLoadingActivity,mWaitingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    curPage = 0;
    isPageEnd = FALSE;
    itmesArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"我的优惠券";

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];
  
  CGRect btnFrame = topBtn.frame;
  btnFrame.size.height = 45;
  [topBtn setFrame:btnFrame];
  UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/RollBtnBackground.png"];
  [topBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
  [topBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateHighlighted];
  [topBtn addTarget:self action:@selector(Roll) forControlEvents:UIControlEventTouchUpInside];
  
  CGRect tableFrame = self.myTableView.frame;
  tableFrame.origin.y = btnFrame.size.height;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar - btnFrame.size.height;
  [self.myTableView setFrame:tableFrame];
  [self.myTableView setBackgroundColor:[UIColor clearColor]];

  myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];

  refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
  [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
  
  [self setLeftButton];
  
  [self getAllMyCoupons];
  
  [self autoLayout];
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
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)Roll
{
  RollMainViewController *pViewController = [[RollMainViewController alloc] initWithNibName:@"RollMainView" withCouponId:@"0" bundle:nil];
  [self.navigationController pushViewController:pViewController animated:YES];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)aRefreshControl
{
  curPage = 0;
  isPageEnd = FALSE;
//  [itmesArray removeAllObjects];
    
  [self getAllMyCoupons];
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
  
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  
  return UIInterfaceOrientationMaskPortrait;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  // 下拉到最底部时显示更多数据
  if(scrollView.contentOffset.y + 40 >= ((scrollView.contentSize.height - scrollView.frame.size.height)))
  {
    if (![self.netOperation isExecuting] && !isPageEnd) {
      [self showLoadingView];
      [self getAllMyCoupons];
    }
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return itmesArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
  {
    return 34;
  }
  else
  {
    return 70;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
  {
    static NSString *CellIdentifier = @"BlankCell";
    
    BlankCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
      cell = [[BlankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
  }
  else
  {
    static NSString *CellIdentifier = @"NewCouponCell";
    
    NewCouponCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
      cell = [[NewCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[itmesArray objectAtIndex:(indexPath.row-1)]];
    NSInteger type;
    if ([dict[@"status"] intValue] == 1)//有效
    {
      if ([dict[@"is_delay"] intValue] == 1){//抽奖机会
        type = 0;
      }
      else{//优惠券
        type = 1;
      }
    }
    else{//过期
      type = 2;
    }
    
    [cell setData:dict withType:type];
    
    return cell;
  }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSMutableDictionary *dict = [itmesArray objectAtIndex:indexPath.row];
  NSInteger type;
  if ([dict[@"status"] intValue] == 1)//有效
  {
    if ([dict[@"is_delay"] intValue] == 1){//抽奖机会
      type = 0;
    }
    else{//优惠券
      type = 1;
    }
  }
  else{//过期
    type = 2;
  }
  NewCouponsDetailViewController *pController = [[NewCouponsDetailViewController alloc] initWithNibName:@"NewCouponsDetailView" withType:type withData:dict bundle:nil];
  [self.navigationController pushViewController:pController animated:YES];
}

#pragma mark - network
-(void)getAllMyCoupons
{
  if (isPageEnd)
  {
    if ([refreshControl isRefreshing]) {
      [refreshControl endRefreshing];
    }
    return;
  }
  [mWaitingActivity startAnimating];
  
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getAllMyCouponsByPage:(curPage + 1)
                       completionHandler:^(NSMutableDictionary *resultDic) {
                         [self getAllMyCouponsDataCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error) {
                       }
                       ];
  
  
}

- (void)getAllMyCouponsDataCallBack:(NSMutableDictionary*) resultDic
{
  [mWaitingActivity stopAnimating];
  if ([refreshControl isRefreshing]) {
    [refreshControl endRefreshing];
    [itmesArray removeAllObjects];
  }
  
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success)
  {
    int totalCount = [resultDic[@"total_count"] intValue];
    totalPage = totalCount/10 + (totalCount % 10 > 0 ? 1 : 0);
    int originsize = itmesArray.count;
    int addsize = [(NSArray*)resultDic[@"coupons"] count];
    if (addsize > 0)
    {
      curPage++;
      [itmesArray addObjectsFromArray:resultDic[@"coupons"]];
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
      
      if (curPage >= totalPage)
        isPageEnd = YES;
    
    }
  }
  else if (result == GC_Failed)
  {
    NSInteger errorCode = [[resultDic valueForKey:@"errorcode"] intValue];
    if (errorCode == GC_AuthAccountInvalid) {
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);
      
      if (self.navigationController) {
        [self.mm_drawerController.navigationController pushViewController:m animated:YES];
        
      }
    }
    // TODO: Other Error
  }
}

@end
