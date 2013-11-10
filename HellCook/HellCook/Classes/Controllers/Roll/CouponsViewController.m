//
//  CouponsViewController.m
//  HellCook
//
//  Created by lxw on 13-11-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "CouponsViewController.h"
#import "RollMainViewController.h"
#import "NetManager.h"
#import "LoginController.h"
#import "HCNavigationController.h"
#import "CommonDef.h"
#import "WebViewController.h"
#import "ODRefreshControl.h"

@interface CouponsViewController ()

@end

@implementation CouponsViewController
@synthesize myTableView;
@synthesize netOperation;
@synthesize pCellForHeight,pRollCell,pCellValidLottery,pValidCouponCell,pInvalidCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    curPage = 0;
    isPageEnd = FALSE;
    bComeFromRoll = FALSE;
    statusForValidLottery = 0;
    statusForValidCoupons = 0;
    statusForInvalids = 0;
    myValidLottery = [[NSMutableArray alloc] init];
    myValidCoupons = [[NSMutableArray alloc] init];
    myInvalids = [[NSMutableArray alloc] init];
    
    pRollCell = [[RollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RollCell"];
    pCellValidLottery = [[ValidLotteryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellValidLottery"];
    pValidCouponCell = [[ValidCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ValidCouponCell"];
    pInvalidCell = [[InvalidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellFourth"];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
  }
  return self;
}

- (void)viewDidLoad
{
  self.title = @"我的优惠券";

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];

  CGRect tableFrame = self.myTableView.frame;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.myTableView setFrame:tableFrame];

  [self setLeftButton];
  
  [self getAllMyCoupons];
  HUD.labelText = @"请求优惠券数据中，请稍后";
  [HUD show:YES];
  [HUD hide:YES afterDelay:2];

  [self autoLayout];
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if (bComeFromRoll)
  {
    curPage = 0;
    isPageEnd = FALSE;
    bComeFromRoll = FALSE;
    statusForValidLottery = 0;
    statusForValidCoupons = 0;
    statusForInvalids = 0;
    [myValidLottery removeAllObjects];
    [myValidCoupons removeAllObjects];
    [myInvalids removeAllObjects];
    
    
    [self getAllMyCoupons];
    HUD.labelText = @"请求优惠券数据中，请稍后";
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
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
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)aRefreshControl
{
  if (!isPageEnd) {
    [self getAllMyCoupons];
  }
  else
  {
    if ([refreshControl isRefreshing]) {
      [refreshControl endRefreshing];
    }
  }
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

-(void)RightButtonOfValidLotteryClicked:(UIButton*)btn
{
  int index = btn.tag;
  NSMutableDictionary *dict = [myValidCoupons objectAtIndex:index];
  NSString *couponId = [NSString stringWithFormat:@"%d",[dict[@"coupon_id"] intValue]];
  RollMainViewController *pViewController = [[RollMainViewController alloc] initWithNibName:@"RollMainView" withCouponId:couponId bundle:nil];
  bComeFromRoll = YES;
  [self.navigationController pushViewController:pViewController animated:YES];
}

-(void)RightButtonOfValidCouponClicked:(UIButton*)btn
{
  int index = btn.tag;
  NSMutableDictionary *dict = [myValidCoupons objectAtIndex:index];
  NSString *url = (NSString*)dict[@"url"];
  WebViewController *pViewController = [[WebViewController alloc] initWithNibName:@"WebView" withURL:url bundle:nil];
  [self.navigationController pushViewController:pViewController animated:YES];
}

-(void)RightButtonOfInvalidsClicked:(UIButton*)btn
{
  int index = btn.tag;
  NSMutableDictionary *dict = [myValidCoupons objectAtIndex:index];
  NSString *url = (NSString*)dict[@"url"];
  WebViewController *pViewController = [[WebViewController alloc] initWithNibName:@"WebView" withURL:url bundle:nil];
  [self.navigationController pushViewController:pViewController animated:YES];
}

-(void)ValidCouponShowDetail
{
  statusForValidCoupons = statusForValidCoupons==0?1:0;
  [myTableView reloadData];
//  NSIndexPath *indexpath = [NSIndexPath indexPathForRow:2 inSection:0];
//  [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)InvalidsShowDetail
{
  statusForInvalids = statusForInvalids==0?1:0;
  [myTableView reloadData];
//  NSIndexPath *indexpath = [NSIndexPath indexPathForRow:3 inSection:0];
//  [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)ValidLotteryShowDetail
{
  statusForValidLottery = statusForValidLottery==0?1:0;
  [myTableView reloadData];
//  NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
//  [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat cellHeight;
  switch (indexPath.row) {
    case 0:
      cellHeight = [pRollCell getCellHeight];
      break;
    case 1://有效的抽奖机会
      cellHeight = [pCellValidLottery caculateCellHeight:myValidLottery withStatus:statusForValidLottery];
      break;
    case 2://有效的优惠券
      cellHeight = [pValidCouponCell caculateCellHeight:myValidCoupons withStatus:statusForValidCoupons];
      break;
    case 3://过期的
      cellHeight = [pInvalidCell caculateCellHeight:myInvalids withStatus:statusForInvalids];
      break;
    default:
      cellHeight = 90;
      break;
  }
  
  return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
  {
    return pRollCell;
  }
  else if (indexPath.row == 1)
  {
    [pCellValidLottery setData:myValidLottery withStatus:statusForValidLottery];
    return pCellValidLottery;
  }
  else if (indexPath.row == 2)
  {
    [pValidCouponCell setData:myValidCoupons withStatus:statusForValidCoupons];
    return pValidCouponCell;
  }
  else
  {
    [pInvalidCell setData:myInvalids withStatus:statusForInvalids];
    return pInvalidCell;
  }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
  {
    RollMainViewController *pViewController = [[RollMainViewController alloc] initWithNibName:@"RollMainView" withCouponId:@"0" bundle:nil];
    bComeFromRoll = YES;
    [self.navigationController pushViewController:pViewController animated:YES];
  }
}


#pragma mark - network
-(void)getAllMyCoupons
{
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
  if ([refreshControl isRefreshing]) {
    [refreshControl endRefreshing];
  }
  
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == GC_Success)
  {
    int totalCount = [resultDic[@"total_count"] intValue];
    totalPage = totalCount/10 + (totalCount % 10 > 0 ? 1 : 0);
    int addsize = [(NSArray*)resultDic[@"coupons"] count];
    if (addsize > 0)
    {
      curPage++;
      NSMutableArray *items = [[NSMutableArray alloc] initWithArray:resultDic[@"coupons"]];
      for (int i=0; i<[items count]; i++)
      {
        NSMutableDictionary *currentItem = [items objectAtIndex:i];
        if ([currentItem[@"status"] intValue] == 1)//有效
        {
          if ([currentItem[@"is_delay"] intValue] == 1)//抽奖机会
          {
            [myValidLottery addObject:currentItem];
          }
          else//优惠券
          {
            [myValidCoupons addObject:currentItem];
          }
        }
        else//过期
        {
          [myInvalids addObject:currentItem];
        }
      }
      
      [myTableView reloadData];
    }
    
    if (curPage >= totalPage)
      isPageEnd = YES;
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
