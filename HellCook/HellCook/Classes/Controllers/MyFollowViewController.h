//
//  MyFollowViewController.h
//  HellCook
//
//  Created by lxw on 13-8-3.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFollowViewController : UIViewController
{
  NSInteger curPage;
  NSMutableArray *myFollowsArray;
  BOOL bShouldRefresh;
  NSInteger totalPage;
  UIActivityIndicatorView* mLoadingActivity;
  BOOL bSessionInvalid;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingActivity;

@end
