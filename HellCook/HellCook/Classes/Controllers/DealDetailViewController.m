//
//  DealDetailViewController.m
//  HellCook
//
//  Created by lxw on 13-9-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "DealDetailViewController.h"

@interface DealDetailViewController ()

@end

@implementation DealDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableDictionary*)data
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    dataDict = [NSMutableDictionary dictionaryWithDictionary:data];
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self setLeftButton];
  CGRect bounds = self.view.frame;
  myScrollView = [[UIScrollView alloc] initWithFrame:bounds];
  myScrollView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:myScrollView];
  
  int height = 5;
  //timeLabel
  timeLabel = [[UILabel alloc] init];
  [timeLabel setFrame:CGRectMake(10, height, 320-_offset, 16)];
  timeLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  timeLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  timeLabel.backgroundColor = [UIColor clearColor];
  timeLabel.font = [UIFont systemFontOfSize:16];
  [timeLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [timeLabel setText:[NSString stringWithFormat:@"时间：%@",dataDict[@"create_time"]]];
  [myScrollView addSubview:timeLabel];
  height += 21;
  //orderLabel
  orderLabel = [[UILabel alloc] init];
  [orderLabel setFrame:CGRectMake(10, height, 320-_offset, 16)];
  orderLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  orderLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  orderLabel.backgroundColor = [UIColor clearColor];
  orderLabel.font = [UIFont systemFontOfSize:16];
  [orderLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [orderLabel setText:[NSString stringWithFormat:@"订单号：%@",dataDict[@"code"]]];
  [myScrollView addSubview:orderLabel];
  height += 25;
  //titleLabel
  titleLabel = [[UILabel alloc] init];
  [titleLabel setFrame:CGRectMake(10, height, 320-_offset, 16)];
  titleLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  titleLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.font = [UIFont systemFontOfSize:16];
  [titleLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [titleLabel setText:@"购买的商品："];
  [myScrollView addSubview:titleLabel];
  height += 22;
  //detail
  double total = 0;
  NSMutableArray *waresArray = [NSMutableArray arrayWithArray:dataDict[@"order_wares"]];
  for (int i=0; i<[waresArray count];i++)
  {
    NSMutableDictionary *ordersDict = [NSMutableDictionary dictionaryWithDictionary:waresArray[i]];
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height, 320-_offset, 16)];
    namelabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    namelabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.font = [UIFont systemFontOfSize:16];
    [namelabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [namelabel setText:ordersDict[@"name"]];
    [myScrollView addSubview:namelabel];
    height += 18;
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height, 320-_offset, 16)];
    priceLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    priceLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont systemFontOfSize:16];
    [priceLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [priceLabel setText:[NSString stringWithFormat:@"%@%@ × ￥%.2f/%@",ordersDict[@"quantity"],ordersDict[@"unit"],[ordersDict[@"price"] floatValue],ordersDict[@"unit"]]];
    [myScrollView addSubview:priceLabel];
    height += 18;
    UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height, 320-_offset, 16)];
    costLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    costLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    costLabel.backgroundColor = [UIColor clearColor];
    costLabel.font = [UIFont systemFontOfSize:16];
    [costLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [costLabel setText:[NSString stringWithFormat:@"=￥%.2f",[ordersDict[@"cost"] floatValue]]];
    [myScrollView addSubview:costLabel];
    height += 22;
    total += [ordersDict[@"cost"] floatValue];
  }
  height += 8;
  //totalLabel
  totalLabel = [[UILabel alloc] init];
  [totalLabel setFrame:CGRectMake(10, height, 320-_offset, 16)];
  totalLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  totalLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  totalLabel.backgroundColor = [UIColor clearColor];
  totalLabel.font = [UIFont systemFontOfSize:16];
  [totalLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [totalLabel setText:[NSString stringWithFormat:@"总计：￥%.2f",total]];
  [myScrollView addSubview:totalLabel];
  
  if (height + 20 > bounds.size.height)
  {
    bounds.size.height = height + 20;
    myScrollView.contentSize = bounds.size;
  }
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
