//
//  RollMainViewController.m
//  HellCook
//
//  Created by lxw on 13-11-4.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "RollMainViewController.h"
#import "AppDelegate.h"
#import "LoginController.h"
#import "HCNavigationController.h"
#import "NetManager.h"

@interface RollMainViewController ()

@end

@implementation RollMainViewController
@synthesize backgroundView,contentLabel,delayBtn,confirmBtn,goBackBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil withCouponId:(NSString*)couponid bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    bInRoll = TRUE;
    coupID = [NSString stringWithString:couponid];
  }
  return self;
}

- (void)viewDidLoad
{
  CGRect selfFrame = self.view.frame;
  selfFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:selfFrame];

  [self setLeftButton];
  
  //backgroundView
  backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - _stateBarHeight - _navigationBarHeight, _screenWidth, _screenHeight)];
  [backgroundView setImage:[UIImage imageNamed:@"Images/RollBackground.png"]];
  [backgroundView setContentMode:UIViewContentModeCenter];
  [self.view addSubview:backgroundView];
  //ContentLabel
  contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 30)];
  contentLabel.backgroundColor = [UIColor clearColor];
  contentLabel.font = [UIFont boldSystemFontOfSize:24];
  contentLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
  contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
  contentLabel.numberOfLines = 0;
  [self.view addSubview:contentLabel];
  contentLabel.hidden = YES;
  //confirmBtn
  confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 320, 230, 50)];
  UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/confirm.png"];
  [confirmBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
  UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/confirmHighlighted.png"];
  [confirmBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
  [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:confirmBtn];
  confirmBtn.hidden = YES;
  //delayBtn
  delayBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 230, 50)];
  UIImage *buttonBackgroundImage2 = [UIImage imageNamed:@"Images/delay.png"];
  [delayBtn setBackgroundImage:buttonBackgroundImage2 forState:UIControlStateNormal];
  UIImage *btnBakimagePressed2 = [UIImage imageNamed:@"Images/delayHighlighted.png"];
  [delayBtn setBackgroundImage:btnBakimagePressed2 forState:UIControlStateHighlighted];
  [delayBtn addTarget:self action:@selector(delay) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:delayBtn];
  delayBtn.hidden = YES;
  //goBackBtn
  goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 320, 230, 50)];
  UIImage *buttonBackgroundImage3 = [UIImage imageNamed:@"Images/confirm.png"];
  [goBackBtn setBackgroundImage:buttonBackgroundImage3 forState:UIControlStateNormal];
  UIImage *btnBakimagePressed3 = [UIImage imageNamed:@"Images/confirmHighlighted.png"];
  [goBackBtn setBackgroundImage:btnBakimagePressed3 forState:UIControlStateHighlighted];
  [goBackBtn addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:goBackBtn];
  goBackBtn.hidden = YES;
  
  [self autoLayout];
  [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
  [ApplicationDelegate disableLeftDrawer];
  [ApplicationDelegate disableRightDrawer];
  self.title = @"摇一摇";
  [super viewWillAppear:animated];
  [self becomeFirstResponder];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self resignFirstResponder];
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
  [self resignFirstResponder];
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirm
{
  [self getCoupons:coupID];
}

-(void)delay
{
  [self delayLottery:coupID];
}

#pragma Roll Delegate
- (BOOL)canBecomeFirstResponder
{
  return YES;// default is NO
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  NSLog(@"开始摇动手机");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  if (bInRoll)
  {
    [self getSalesToday];
    bInRoll = FALSE;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示：" message:@"请求当日数据中" delegate:nil cancelButtonTitle:@"CANCEL" otherButtonTitles:nil];
    [alert show];
  }
  
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  NSLog(@"取消");
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


#pragma mark - network
-(void)getSalesToday
{
 self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getSalesOfTodayWithcompletionHandler:^(NSMutableDictionary *resultDic) {
                         [self getSalesTodayDataCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error) {
                       }
                       ];
}

- (void)getSalesTodayDataCallBack:(NSMutableDictionary*) resultDic
{  
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    backgroundView.hidden = YES;
    contentLabel.hidden = NO;
    confirmBtn.hidden = NO;
    delayBtn.hidden = NO;
    
    NSString *strTime = [NSString stringWithString:(NSString*)resultDic[@"time"]];
    NSRange range = [strTime rangeOfString:@" "];
    strTime = [strTime substringToIndex:range.location];
    NSString *content = [NSString stringWithFormat:@"尊敬的用户你好，您是否在%@进行了%d笔交易，共计%.2f元",strTime,[resultDic[@"sale_count"] intValue],[resultDic[@"sale_fee"] floatValue]];
    CGSize contentSize = [content sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(270, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    [contentLabel setFrame:CGRectMake(20, 40, 280, contentSize.height)];
    [contentLabel setText:content];
    [confirmBtn setFrame:CGRectMake(50, 40+contentSize.height+40, 230, 50)];
    [delayBtn setFrame:CGRectMake(50, 40+contentSize.height+40+70, 230, 50)];
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


-(void)getCoupons:(NSString*)couponid
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       getCouponsById:couponid
                    completionHandler:^(NSMutableDictionary *resultDic) {
                         [self getCouponsDataCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error) {
                       }
                       ];
}

- (void)getCouponsDataCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    confirmBtn.hidden = YES;
    delayBtn.hidden = YES;
    goBackBtn.hidden = NO;
    NSMutableArray *couponsArray = resultDic[@"coupons"];
    NSString *content = [[NSString alloc] init];
    for (int i=0; i<[couponsArray count]; i++)
    {
      NSMutableDictionary *dict = [couponsArray objectAtIndex:i];
      if ([dict[@"condition"] intValue]==0 || [dict[@"condition"] intValue]==2)
        continue;
      
      NSString *strExpDay = [NSString stringWithString:(NSString*)dict[@"exp_day"]];
      NSRange range = [strExpDay rangeOfString:@" "];
      strExpDay = [strExpDay substringToIndex:range.location];
      
      NSString *temp = [NSString stringWithFormat:@"祝贺您，您获得价值 %.2f 的 %@，有效期至 %@。券号 %@ 适用门店 %@ \n %@", [dict[@"val"] floatValue],(NSString*)dict[@"name"],strExpDay,(NSString*)dict[@"coupon_id"],(NSString*)dict[@"stores"],(NSString*)dict[@"coupon_remark"]];
      content = [content stringByAppendingString:temp];
      content = [content stringByAppendingString:@"\n\n"];
    }
    
    if ([content isEqual:@""])
    {
      if ([couponsArray count] > 0)
      {
        NSMutableDictionary *dict = [couponsArray objectAtIndex:0];
        content = [content stringByAppendingFormat:@"对不起，您暂时无法抽取优惠券，%@",(NSString*)dict[@"remark"]];
      }
      else
        content = [content stringByAppendingString:@"对不起，您暂时无法抽取优惠券"];
      
    }
    CGSize contentSize = [content sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(270, 2000) lineBreakMode:NSLineBreakByWordWrapping];
    [contentLabel setFrame:CGRectMake(20, 40, 280, contentSize.height)];
    [contentLabel setText:content];
    [goBackBtn setFrame:CGRectMake(50, 40+contentSize.height+40, 230, 50)];
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


-(void)delayLottery:(NSString*)couponid
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       delayLotteryById:couponid
                       completionHandler:^(NSMutableDictionary *resultDic) {
                         [self delayLotteryCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error) {
                       }
                       ];
}

- (void)delayLotteryCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0)
  {
    confirmBtn.hidden = YES;
    delayBtn.hidden = YES;
    goBackBtn.hidden = NO;
    
    NSString *content = [[NSString alloc] init];
    if ([coupID isEqual:@"0"])//第一次延期
    {
      
    }
    else
    {
      content = [content stringByAppendingString:@"\n\n"];
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
