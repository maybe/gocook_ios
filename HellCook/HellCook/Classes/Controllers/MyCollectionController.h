//
//  MyCollectionController.h
//  HellCook
//
//  Created by lxw on 13-7-28.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionController : UIViewController
{
  UITableView *tableView;
  NSInteger curPage;
  NSArray *myCollectionArray;
  
  BOOL mShouldRefresh;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property BOOL mShouldRefresh;

@end
