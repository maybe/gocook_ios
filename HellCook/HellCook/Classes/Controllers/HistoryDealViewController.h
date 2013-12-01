//
//  HistoryDealViewController.h
//  HellCook
//
//  Created by lxw on 13-9-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODRefreshControl;
@interface HistoryDealViewController : UIViewController
{
  UITableView *myTableView;
  NSInteger curPage;
  NSInteger totalPage;
  BOOL bShouldRefresh;
  NSMutableArray *ordersArray;
  
  UIActivityIndicatorView* mLoadingActivity;
  ODRefreshControl *refreshControl;
}

@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;

@end
