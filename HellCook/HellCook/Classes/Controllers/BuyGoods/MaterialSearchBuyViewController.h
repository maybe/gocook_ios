//
//  MaterialSearchBuyViewController.h
//  HellCook
//
//  Created by lxw on 13-9-2.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class MBProgressHUD;
@interface MaterialSearchBuyViewController : UIViewController<MBProgressHUDDelegate, UIAlertViewDelegate>
{
  UITableView *myTableView;
  NSMutableArray *unslashMaterialArray;
  NSInteger selectedRowOfCell;
  
  MBProgressHUD *HUD;

  BOOL isOrderSuccess;

  NSInteger removeCellIndex;
}

@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableArray*)data;

@end
