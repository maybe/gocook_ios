//
//  GoodsDetailViewController.h
//  HellCook
//
//  Created by lxw on 13-9-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsDetailBelowCell;
@interface GoodsDetailViewController : UIViewController
{
  UITableView *myTableView;
  NSMutableDictionary *goodsDetailDict;
  GoodsDetailBelowCell *cellForHeight;
}

@property (nonatomic,retain) IBOutlet UITableView *myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableDictionary*)data;

@end
