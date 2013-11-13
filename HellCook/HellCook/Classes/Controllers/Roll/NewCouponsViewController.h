//
//  NewCouponsViewController.h
//  HellCook
//
//  Created by lxw on 13-11-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCouponsViewController : UIViewController
{
  UIButton *topBtn;
  UITableView *myTableView;
  NSInteger curPage;
  NSInteger totalPage;
  BOOL isPageEnd;
  NSMutableArray *itmesArray;
}

@property (nonatomic,retain) IBOutlet UIButton *topBtn;
@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;

@end
