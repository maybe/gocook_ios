//
//  MyRecipesContorller.h
//  HellCook
//
//  Created by panda on 8/3/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRecipesController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
  UITableView* tableView;
  NSMutableArray* mMyRecipeArray;
  
  bool isPageEnd;//是否全部加载完毕
  NSInteger curPage;
  NSInteger totalPage;
  UIActivityIndicatorView* mLoadingActivity;
  
  MKNetworkOperation *mNetOperation;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) NSMutableArray* mMyRecipeArray;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingActivity;
@property (strong, nonatomic) MKNetworkOperation *mNetOperation;

@end
