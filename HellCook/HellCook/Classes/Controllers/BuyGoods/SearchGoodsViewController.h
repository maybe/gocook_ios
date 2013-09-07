//
//  SearchGoodsViewController.h
//  HellCook
//
//  Created by lxw on 13-9-4.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchGoodsViewController : UIViewController
{
  UITableView *myTableView;
  NSString *myKeywords;
  NSInteger curPage;
}

@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withKeyword:(NSString*)keyword;

@end
