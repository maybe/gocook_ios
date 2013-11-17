//
//  NewCouponsDetailViewController.h
//  HellCook
//
//  Created by lxw on 13-11-16.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCouponsDetailContentCell.h"

@interface NewCouponsDetailViewController : UIViewController
{
  UITableView *myTableView;
  int myType;
  UIButton *topBtn;
    
  NSMutableDictionary *data;
  NewCouponsDetailContentCell *contentCell;
}

@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (nonatomic,retain) IBOutlet UIButton *topBtn;
@property (nonatomic,retain) NewCouponsDetailContentCell *contentCell;


- (id)initWithNibName:(NSString *)nibNameOrNil withType:(NSInteger)type withData:(NSMutableDictionary*)dict bundle:(NSBundle *)nibBundleOrNil;
//type=0表示延期抽取机会，type=1表示有效优惠券，type=2表示过期的

@end
