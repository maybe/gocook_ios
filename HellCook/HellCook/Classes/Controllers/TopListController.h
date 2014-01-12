//
//  TopListController.h
//  HellCook
//
//  Created by panda on 5/5/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TopListType) {
  TLT_TopHot,
  TLT_TopNew,
};

#define TOPLISTMAXPAGE 5

@interface TopListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
  UITableView* tableView;
  NSMutableArray* topArray;
  TopListType topListType;
  bool isPageEnd;//是否全部加载完毕
  NSInteger curPage;
  UIActivityIndicatorView* loadingActivity;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) NSMutableArray* topArray;
@property TopListType topListType;
@property (nonatomic, retain) UIActivityIndicatorView* loadingActivity;


@end
