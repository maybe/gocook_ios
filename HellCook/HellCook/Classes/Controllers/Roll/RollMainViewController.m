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
#import "AudioToolbox/AudioToolbox.h"
#import "ZXingObjC.h"

@interface RollMainViewController ()

@end

@implementation RollMainViewController
@synthesize backgroundView,contentLabel,delayBtn,confirmBtn,goBackBtn;
@synthesize resultImage;

- (id)initWithNibName:(NSString *)nibNameOrNil withCouponId:(NSString*)couponid bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    bInRoll = TRUE;
    coupID = [NSString stringWithString:couponid];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
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
  
  //******
  resultImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 300, 60)];
  [self.view addSubview:resultImage];
  NSString *data = @"111122233433";
  ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
  ZXBitMatrix *result = [writer encode:data format:kBarcodeFormatCode128 width:self.resultImage.frame.size.width height:self.resultImage.frame.size.width error:nil];
  if (result) {
    self.resultImage.image = [UIImage imageWithCGImage:[ZXImage imageWithMatrix:result].cgimage];
  } else {
    self.resultImage.image = nil;
  }
  //******
  
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
  
  HUD.labelText = @"获取优惠券中，请稍后";
  [HUD show:YES];
  [HUD hide:YES afterDelay:2];
}

-(void)delay
{
  [self delayLottery:coupID];
  
  HUD.labelText = @"请求延期中，请稍后";
  [HUD show:YES];
  [HUD hide:YES afterDelay:2];
}

#pragma Roll Delegate
- (BOOL)canBecomeFirstResponder
{
  return YES;// default is NO
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  NSLog(@"开始摇动手机");
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  if (bInRoll)
  {
    bInRoll = FALSE;
    if ([coupID isEqualToString:@"0"]) {
      [self getSalesToday];
      
      HUD.labelText = @"请求销售额中，请稍后";
      [HUD show:YES];
      [HUD hide:YES afterDelay:2];

    }
    else
    {
      [self getCoupons:coupID];
      
      HUD.labelText = @"获取优惠券中，请稍后";
      [HUD show:YES];
      [HUD hide:YES afterDelay:2];
    }
    
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
    if ([coupID isEqual:@"0"]) {
      delayBtn.hidden = NO;
    }
    
    
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
    backgroundView.hidden = YES;
    contentLabel.hidden = NO;
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
    if ([resultDic[@"delay_rst"] intValue] == 0)//延期成功
    {
      NSString *strExpDay = [NSString stringWithString:(NSString*)resultDic[@"exp_day"]];
      NSRange range = [strExpDay rangeOfString:@" "];
      strExpDay = [strExpDay substringToIndex:range.location];
      content = [content stringByAppendingFormat:@"您有一次延迟抽取优惠券的机会，有效期至%@",strExpDay];
    }
    else if ([resultDic[@"delay_rst"] intValue] == 1)//延期未成功
    {
      content = [content stringByAppendingFormat:@"返回提示信息抱歉，您不符合延期抽取条件。 %@",(NSString*)resultDic[@"remark"]];
    }
    else// 已经延期过
    {
      content = [content stringByAppendingString:@"继续为您保留抽取机会，请您在限定日期之前抽取优惠券"];
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
@end
