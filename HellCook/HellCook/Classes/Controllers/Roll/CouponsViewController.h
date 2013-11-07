//
//  CouponsViewController.h
//  HellCook
//
//  Created by lxw on 13-11-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponViewCell.h"

@interface CouponsViewController : UIViewController
{
  UITableView *myTableView;
  NSInteger curPage;
  NSMutableArray *myValidLottery;//有效的抽奖机会
  NSMutableArray *myValidCoupons;//有效的优惠券
  NSMutableArray *myInvalids;//无效（已过期）的抽奖机会或优惠券
  CouponViewCell *pCellForHeight;
  
  NSInteger statusForValidLottery;//0表示未展开状态，1表示展开状态
  NSInteger statusForValidCoupons;
  NSInteger statusForInvalids;
}

@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic,retain) CouponViewCell *pCellForHeight;

@end
