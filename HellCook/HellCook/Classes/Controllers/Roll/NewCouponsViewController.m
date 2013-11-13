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

@interface NewCouponsViewController ()

@end

@implementation NewCouponsViewController
@synthesize topBtn,myTableView;
@synthesize netOperation;

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
  btnFrame.size.height = 80;
  [topBtn setFrame:btnFrame];
  UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/RollBtnBackground.png"];
  [topBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
  UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/RollBtnBackgroundHighlighted.png"];
  [topBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
  
  CGRect tableFrame = self.myTableView.frame;
  tableFrame.origin.y = btnFrame.size.height;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar - btnFrame.size.height;
  [self.myTableView setFrame:tableFrame];
  
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return itmesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"NewCouponCell";
  
  NewCouponCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
  {
    cell = [[NewCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[itmesArray objectAtIndex:indexPath.row]];
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
