//
//  MyRecipesContorller.h
//  HellCook
//
//  Created by panda on 8/3/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class ODRefreshControl;
@interface MyRecipesController : UIViewController<UITableViewDelegate,UITableViewDataSource, MBProgressHUDDelegate, UIAlertViewDelegate>
{
  MBProgressHUD *HUD;
  UITableView* tableView;
  NSMutableArray* mMyRecipeArray;
  
  bool firstLoad; //第一次显示需要刷新
  bool isPageEnd;//是否全部加载完毕
  NSInteger curPage;
  NSInteger totalPage;
  UIActivityIndicatorView* mLoadingActivity;
  MKNetworkOperation *mNetOperation;
  ODRefreshControl *refreshControl;

  NSInteger userId;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) NSMutableArray* mMyRecipeArray;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingActivity;
@property (strong, nonatomic) MKNetworkOperation *mNetOperation;
@property NSInteger userId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userID;

@end
