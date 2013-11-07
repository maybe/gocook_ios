//
//  CouponsViewController.m
//  HellCook
//
//  Created by lxw on 13-11-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "CouponsViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "RollMainViewController.h"
#import "NetManager.h"
#import "LoginController.h"
#import "HCNavigationController.h"

@interface CouponsViewController ()

@end

@implementation CouponsViewController
@synthesize myTableView;
@synthesize netOperation;
@synthesize pCellForHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    curPage = 0;
    statusForValidLottery = 0;
    statusForValidCoupons = 0;
    statusForInvalids = 0;
    myValidLottery = [[NSMutableArray alloc] init];
    myValidCoupons = [[NSMutableArray alloc] init];
    myInvalids = [[NSMutableArray alloc] init];
    
    pCellForHeight = [[CouponViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForHeight"];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"我的优惠券";
  [self setLeftButton];
  
  [self getAllMyCoupons];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)RightButtonClicked:(UIButton*)btn
{
  if (btn.tag == 1)
  {
    RollMainViewController *pViewController = [[RollMainViewController alloc] initWithNibName:@"RollMainView" bundle:nil];
    [self.navigationController pushViewController:pViewController animated:YES];
  }
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
      cellHeight = 90;
      break;
    case 1://有效的抽奖机会
      cellHeight = [pCellForHeight caculateCellHeight:myValidLottery withStatus:statusForValidLottery];
      break;
    case 2://有效的优惠券
      cellHeight = [pCellForHeight caculateCellHeight:myValidCoupons withStatus:statusForValidCoupons];
      break;
    case 3://过期的
      cellHeight = [pCellForHeight caculateCellHeight:myInvalids withStatus:statusForInvalids];
      break;
    default:
      cellHeight = 90;
      break;
  }
  
  return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CouponViewCell";
  
  CouponViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
  {
    cell = [[CouponViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:nil withRow:indexPath.row withStatus:0];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
  {
    RollMainViewController *pViewController = [[RollMainViewController alloc] initWithNibName:@"RollMainView" bundle:nil];
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
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
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
    
  }
  else if (result == 1)
  {
    LoginController* m = [[LoginController alloc]initWithNibName:@"LoginView" bundle:nil];
    m.callerClassName = NSStringFromClass([self class]);
    HCNavigationController* nc = [[HCNavigationController alloc]initWithRootViewController:m];
    if (self.navigationController)
    {
      [self.navigationController presentViewController:nc animated:YES completion:nil];
    }
  }
}

@end
