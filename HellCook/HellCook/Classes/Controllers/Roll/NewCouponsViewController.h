//
//  NewCouponsViewController.h
//  HellCook
//
//  Created by lxw on 13-11-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODRefreshControl;
@interface NewCouponsViewController : UIViewController
{
  UIButton *topBtn;
  UITableView *myTableView;
  NSInteger curPage;
  NSInteger totalPage;
  BOOL isPageEnd;
  NSMutableArray *itmesArray;
  
  ODRefreshControl *refreshControl;
  UIActivityIndicatorView* mLoadingActivity;
  UIActivityIndicatorView* mWaitingActivity;
}

@property (nonatomic,retain) IBOutlet UIButton *topBtn;
@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingActivity;
@property (nonatomic, retain)IBOutlet UIActivityIndicatorView* mWaitingActivity;

@end