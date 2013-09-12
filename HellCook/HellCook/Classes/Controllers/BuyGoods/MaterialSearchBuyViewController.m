//
//  MaterialSearchBuyViewController.m
//  HellCook
//
//  Created by lxw on 13-9-2.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MaterialSearchBuyViewController.h"
#import "MaterialSearchBuyTableViewCell.h"
#import "SearchGoodsViewController.h"
#import "NetManager.h"

@interface MaterialSearchBuyViewController ()

@end

@implementation MaterialSearchBuyViewController
@synthesize myTableView,netOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableArray*)data
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  // Custom initialization
    selectedRowOfCell = -1;
    unslashMaterialArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[data count]; i++)
    {
      if ([[data objectAtIndex:i][@"select"] isEqual:@"unslash"])
      {
        NSMutableDictionary *materialDict = [NSMutableDictionary dictionaryWithDictionary:[data objectAtIndex:i]];
        [materialDict setObject:@"NotBuy" forKey:@"state"];
        
        [unslashMaterialArray addObject:materialDict];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirm:) name:@"ConfirmGoods" object:nil];
      }
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.navigationItem.title = @"选购商品";
  [self setLeftButton];
  [self setRightButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundHighlighted.png"]
                               forState:UIControlStateHighlighted];
  [leftBarButtonView setTitle:@"  返回 " forState:UIControlStateNormal];
  [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
//  NSArray *viewControllers = [NSArray arrayWithArray:self.navigationController.viewControllers];
//  HomePageController *prevController = [viewControllers objectAtIndex:[viewControllers count]-2];
//  prevController.isMyInfoChanged = isChanged;
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightButton
{
  UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 30)];
  [rightBarButtonView addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"] forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:[UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"] forState:UIControlStateHighlighted];
  [rightBarButtonView setTitle:@"下单" forState:UIControlStateNormal];
  [rightBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];

  [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)confirm:(NSNotification *)notification
{
  NSMutableDictionary *dict = (NSMutableDictionary*)notification.object;
  [[unslashMaterialArray objectAtIndex:selectedRowOfCell] addEntriesFromDictionary:dict];
  [[unslashMaterialArray objectAtIndex:selectedRowOfCell] setObject:@"Buy" forKey:@"state"];
  
  NSIndexPath *indexpath = [NSIndexPath indexPathForRow:selectedRowOfCell inSection:0];
  [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
  
  
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"AfterConfirmGoods" object:self];
}

- (void)buy
{
  NSMutableString *content = [NSMutableString stringWithString:@"\"Wares\":["];
  NSInteger buyNum = 0;
  for (int i=0; i<[unslashMaterialArray count]; i++,buyNum++)
  {
    if (![unslashMaterialArray[i][@"state"] isEqual:@"NotBuy"])
    {
      NSMutableString *oneBill = [NSMutableString stringWithFormat:@"{\"WareId\":%d,\"Quantity\":%@,\"Remark\":\"%@\"},",[unslashMaterialArray[i][@"id"] intValue], unslashMaterialArray[i][@"Quantity"], unslashMaterialArray[i][@"Remark"]];
      
      [content appendString:oneBill];
    }
  }
  
  if (buyNum == 0)
  {
    HUD.labelText = @"未选择买入物品！";
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
  }
  else
  {
    content = [NSMutableString stringWithString:[content substringToIndex:([content length]-1)]];
    [content appendString:@"]"];
    NSMutableDictionary *finalDataDict = [[NSMutableDictionary alloc] init];
    [finalDataDict setObject:content forKey:@"wares"];
    [self buyGoods:finalDataDict];
  }
}

-(void)GotoSearchGoods:(UIButton*)sender
{
  selectedRowOfCell = sender.tag;
  NSString *keyword = [sender associativeObjectForKey:@"keyword"];
  SearchGoodsViewController *pController = [[SearchGoodsViewController alloc] initWithNibName:@"SearchGoodsView" bundle:nil withKeyword:keyword];
  [self.navigationController pushViewController:pController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return unslashMaterialArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([[unslashMaterialArray objectAtIndex:indexPath.row][@"state"] isEqual:@"NotBuy"])
  {
    return 90;
  }
  else
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"NotBuyTableViewCell";
  
  MaterialSearchBuyTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
  {
    cell = [[MaterialSearchBuyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  [cell setData:unslashMaterialArray[indexPath.row] withRow:indexPath.row];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  selectedRowOfCell = indexPath.row;
}


#pragma mark - network
-(void)buyGoods:(NSMutableDictionary*)data
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       buyGoodsWithDict:data
                       completionHandler:^(NSMutableDictionary *resultDic){
                         [self buyGoodsCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error){}];
  
}

-(void)buyGoodsCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  NSString *content;
  if (result == 0)
  {
    content = [NSString stringWithFormat:@"下单成功，订单号%@",resultDic[@"order_id"]];
  }
  else
  {
    content = [NSString stringWithFormat:@"下单失败，错误代码%@",resultDic[@"errorcode"]];
  }
  
  HUD.labelText = content;
  [HUD show:YES];
  [HUD hide:YES afterDelay:2];
}

@end
