//
//  SearchGoodsViewController.h
//  HellCook
//
//  Created by lxw on 13-9-4.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODRefreshControl;
@interface SearchGoodsViewController : UIViewController
{
  UITableView *myTableView;
  NSString *myKeywords;
  NSInteger curPage;  
  NSMutableArray *goodsListArray;
     
  BOOL bShouldRefresh;
  NSInteger totalPage;
  UIActivityIndicatorView* mLoadingActivity;
  ODRefreshControl *refreshControl; 
}

@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withKeyword:(NSString*)keyword;

@end
