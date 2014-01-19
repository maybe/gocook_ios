//
//  MyCollectionController.h
//  HellCook
//
//  Created by lxw on 13-7-28.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODRefreshControl;
@interface MyCollectionController : UIViewController
{
  UITableView *tableView;
  NSInteger curPage;
  NSMutableArray *myCollectionArray;

  ODRefreshControl *refreshControl;
  UILabel * emptyLabel;

  BOOL bShouldRefresh;
  NSInteger totalPage;
  UIActivityIndicatorView* mLoadingActivity;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingActivity;

@end
