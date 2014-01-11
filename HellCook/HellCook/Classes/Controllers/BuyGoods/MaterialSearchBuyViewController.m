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
#import "LoginController.h"

@interface MaterialSearchBuyViewController ()

@end

@implementation MaterialSearchBuyViewController
@synthesize myTableView,netOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableArray*)data
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
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

    isOrderSuccess = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  self.navigationItem.title = @"选购商品";
  [self setLeftButton];
  [self setRightButton];

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  viewFrame.size.width = _sideWindowWidth;
  [self.view setFrame:viewFrame];

  CGRect tableFrame = self.myTableView.frame;
  tableFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  tableFrame.size.width = _sideWindowWidth;
  [self.myTableView setFrame:tableFrame];

  HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
  [self.navigationController.view addSubview:HUD];
  HUD.mode = MBProgressHUDModeText;
  HUD.delegate = self;

  [self resetTableHeader];

  [self autoLayout];
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)dealloc {
  [HUD removeFromSuperview];
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

- (void)resetTableHeader {
  CGRect frame = self.myTableView.tableHeaderView.frame;
  frame.size.height = 44;
  self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
  CGFloat tableWidth = self.myTableView.frame.size.width;

  UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(tableWidth / 2 - 106, 8, 212, 28)];
  UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/AddOtherMaterialNormal.png"];
  [uploadButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];

  UIImage *buttonBackgroundImage2 = [UIImage imageNamed:@"Images/AddOtherMaterialHighLight.png"];
  [uploadButton setBackgroundImage:buttonBackgroundImage2 forState:UIControlStateHighlighted];

  [uploadButton addTarget:self action:@selector(addOtherMaterial) forControlEvents:UIControlEventTouchUpInside];

  [self.myTableView.tableHeaderView addSubview:uploadButton];

  UIImage *dotImage = [UIImage imageNamed:@"Images/homeHeaderSeperator.png"];
  UIImageView *dotImageView = [[UIImageView alloc] initWithImage:dotImage];
  [dotImageView setFrame:CGRectMake(0, 43, 320, 1)];

  [self.myTableView.tableHeaderView addSubview:dotImageView];
}

-(void)addOtherMaterial
{
  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入食材名称：" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
  alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) {
    // cancel
  } else if (buttonIndex == 1){
    UITextField *tf = [alertView textFieldAtIndex:0];
    NSString* materialStr = [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![materialStr isEqualToString:@""]) {
      NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"weight",@"unslash",@"select",@"NotBuy",@"state",materialStr,@"material",nil];
      [unslashMaterialArray insertObject:dic atIndex:0];
      [myTableView reloadData];
    }
  }
}

-(void)removeMaterial:(id)sender
{
  UIButton *button = sender;
  NSIndexPath *indexPath = [[self relatedTable:[self relatedCell:button]] indexPathForCell:[self relatedCell:button]];
  [unslashMaterialArray removeObjectAtIndex: indexPath.row];
  [myTableView reloadData];
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
  UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
  [rightBarButtonView addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
  [rightBarButtonView setBackgroundImage:[UIImage imageNamed:@"Images/OrderRightButton.png"] forState:UIControlStateNormal];
  [rightBarButtonView setBackgroundImage:[UIImage imageNamed:@"Images/OrderRightButtonHighLight.png"] forState:UIControlStateHighlighted];
  [rightBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];

  [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void)confirm:(NSNotification *)notification
{
  NSDictionary *dict = (NSDictionary*)notification.object;
  [[unslashMaterialArray objectAtIndex:selectedRowOfCell] addEntriesFromDictionary:dict];
  [[unslashMaterialArray objectAtIndex:selectedRowOfCell] setObject:@"Buy" forKey:@"state"];
  
  NSIndexPath *indexpath = [NSIndexPath indexPathForRow:selectedRowOfCell inSection:0];
  [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)buy
{
  NSMutableString *content = [NSMutableString stringWithString:@"\"Wares\":["];
  NSInteger buyNum = 0;
  for (int i=0; i<[unslashMaterialArray count]; i++)
  {
    if (![unslashMaterialArray[i][@"state"] isEqual:@"NotBuy"])
    {
      NSString *strQuantity;
      if ([(NSString*)unslashMaterialArray[i][@"unit"] isEqualToString:@"kg"])
      {
        strQuantity = [NSString stringWithFormat:@"%.2f",[unslashMaterialArray[i][@"Quantity"] floatValue]/2];
      }
      else
      {
        strQuantity = [NSString stringWithString:unslashMaterialArray[i][@"Quantity"]];
      }
      NSMutableString *oneBill = [NSMutableString stringWithFormat:@"{\"WareId\":%d,\"Quantity\":%@,\"Remark\":\"%@\"},",[unslashMaterialArray[i][@"id"] intValue], strQuantity, unslashMaterialArray[i][@"Remark"]];
      
      [content appendString:oneBill];

      buyNum++;
    }
  }
  
  if (buyNum == 0)
  {
    HUD.labelText = @"未选择买入物品！";
    HUD.detailsLabelText = nil;
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
    return 130;
  }
  else
    return 253;
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
  HUD.labelText = @"正在下单";
  HUD.detailsLabelText = nil;
  [HUD show:YES];

  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       buyGoodsWithDict:data
                       completionHandler:^(NSMutableDictionary *resultDic){
                         [self buyGoodsCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error){
                         HUD.detailsLabelText = nil;
                         HUD.labelText = @"下单超时，请检查网络";
                         [HUD hide:YES afterDelay:1.0];
                       }];
}

-(void)buyGoodsCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  NSString *content;
  if (result == 0)
  {
    content = [NSString stringWithFormat:@"下单成功，订单号%@",resultDic[@"order_id"]];
    HUD.detailsLabelText = content;
    HUD.labelText = nil;
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
    isOrderSuccess = YES;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnShouldRefreshKitchenInfo" object:nil];
  }
  else
  {
    NSInteger errorCode = [[resultDic valueForKey:@"errorcode"] intValue];
    if (errorCode == GC_AuthAccountInvalid) {
      [HUD hide:YES];
      LoginController *m = [[LoginController alloc] initWithNibName:@"LoginView" bundle:nil];
      m.callerClassName = NSStringFromClass([self class]);
      if (self.mm_drawerController) {
        [self.mm_drawerController.navigationController pushViewController:m animated:YES];
      } else {
        [self.navigationController pushViewController:m animated:YES];
      }
    } else {
      content = [NSString stringWithFormat:@"下单失败，错误代码%@",resultDic[@"errorcode"]];
      HUD.labelText = content;
      HUD.detailsLabelText = nil;
      [HUD show:YES];
      [HUD hide:YES afterDelay:2];
    }

    isOrderSuccess = NO;
  }

}

- (void)hudWasHidden:(MBProgressHUD *)hud {
  if (isOrderSuccess) {
    [self.navigationController popToRootViewControllerAnimated:YES];
  }

}

- (UITableView *)relatedTable:(UIView *)view
{
  if ([view.superview isKindOfClass:[UITableView class]])
    return (UITableView *)view.superview;
  else if ([view.superview.superview isKindOfClass:[UITableView class]])
    return (UITableView *)view.superview.superview;
  else
  {
    NSAssert(NO, @"UITableView shall always be found.");
    return nil;
  }
}

- (UITableViewCell *)relatedCell:(UIView *)view
{
  if ([view.superview isKindOfClass:[UITableViewCell class]])
    return (UITableViewCell *)view.superview;
  else if ([view.superview.superview isKindOfClass:[UITableViewCell class]])
    return (UITableViewCell *)view.superview.superview;
  else
  {
    NSAssert(NO, @"UITableViewCell shall always be found.");
    return nil;
  }
}

@end
