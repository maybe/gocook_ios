//
//  MyFollowViewController.h
//  HellCook
//
//  Created by lxw on 13-8-3.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODRefreshControl;
@interface MyFollowViewController : UIViewController
{
  NSInteger curPage;
  NSMutableArray *myFollowsArray;
  NSInteger totalPage;
  UIActivityIndicatorView* mLoadingActivity;
  bool firstLoad; //第一次显示需要刷新
  bool isPageEnd;//是否全部加载完毕
  ODRefreshControl *refreshControl;
  NSInteger userId;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userID;

@end
