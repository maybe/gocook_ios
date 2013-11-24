//
//  NewCouponsDetailViewController.m
//  HellCook
//
//  Created by lxw on 13-11-16.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "NewCouponsDetailViewController.h"
#import "ZXingObjC.h"
#import "RollMainViewController.h"
#import "WebViewController.h"

@interface NewCouponsDetailViewController ()

@end

@implementation NewCouponsDetailViewController
@synthesize myTableView,topBtn,contentCell;

- (id)initWithNibName:(NSString *)nibNameOrNil withType:(NSInteger)type withData:(NSMutableDictionary*)dict bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    myType = type;
    data = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    contentCell = [[NewCouponsDetailContentCell alloc] initWithStyle:UITableViewCellStyleDefault withType:myType withData:data reuseIdentifier:@"contentcell"];
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
  btnFrame.size.height = 56;
  [topBtn setFrame:btnFrame];
  if (myType == 0)//抽奖机会
  {
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/RollBtnBackground.png"];
    [topBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/RollBtnBackground.png"];
    [topBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
  }
  else if (myType == 1)//有效优惠券
  {
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/RollBtnBackground.png"];
    [topBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    topBtn.userInteractionEnabled = FALSE;
    //******
    CGRect imageFrame = topBtn.frame;
    imageFrame.origin.x = 75;
    imageFrame.origin.y = 3;
    imageFrame.size.width = 170;
    imageFrame.size.height = topBtn.frame.size.height - 5;
    UIImageView *resultImage = [[UIImageView alloc]initWithFrame:imageFrame];
    [self.view addSubview:resultImage];
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:(NSString*)data[@"coupon"] format:kBarcodeFormatCode128 width:resultImage.frame.size.width height:resultImage.frame.size.width error:nil];
    if (result) {
      resultImage.image = [UIImage imageWithCGImage:[ZXImage imageWithMatrix:result].cgimage];
    } else {
      resultImage.image = nil;
    }
    //******
  }
  else//过期
  {
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/overdue.png"];
    [topBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/overdue.png"];
    [topBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
    topBtn.userInteractionEnabled = FALSE;
  }
  [topBtn addTarget:self action:@selector(topBtnPressed) forControlEvents:UIControlEventTouchUpInside];
  
  CGRect tableFrame = self.myTableView.frame;
  tableFrame.origin.y = btnFrame.size.height;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar - btnFrame.size.height;
  [self.myTableView setFrame:tableFrame];
  myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];

  [self setLeftButton];
  
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
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)topBtnPressed
{
  NSString *couponId = [NSString stringWithFormat:@"%d",[data[@"coupon_id"] intValue]];
  RollMainViewController *pViewController = [[RollMainViewController alloc] initWithNibName:@"RollMainView" withCouponId:couponId bundle:nil];
  [self.navigationController pushViewController:pViewController animated:YES];
}

-(void)showDetail:(UIButton*)btn
{
  NSString *strUrl = [btn associativeObjectForKey:@"url"];
  WebViewController *pViewController = [[WebViewController alloc] initWithNibName:@"WebView" withURL:strUrl bundle:nil];
  [self.navigationController pushViewController:pViewController animated:YES];
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
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [contentCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return contentCell;
}

@end
