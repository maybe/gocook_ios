//
//  MyFansViewController.h
//  HellCook
//
//  Created by lxw on 13-8-8.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODRefreshControl;
@interface MyFansViewController : UIViewController
{
  NSInteger curPage;
  NSMutableArray *myFansArray;
  NSInteger totalPage;
  UIActivityIndicatorView* mLoadingActivity;
  bool firstLoad; //第一次显示需要刷新
  bool isPageEnd;//是否全部加载完毕
  ODRefreshControl *refreshControl;
  NSInteger userId;
  NSString* titleName;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingActivity;
@property (nonatomic, retain) NSString* titleName;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userID AndName:(NSString *)userName;

@end
