//
//  RollMainViewController.h
//  HellCook
//
//  Created by lxw on 13-11-4.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RollMainViewController : UIViewController
{
  UIImageView* backgroundView;
  BOOL bInRoll;
  UILabel *contentLabel;
  UIButton *confirmBtn;
  UIButton *delayBtn;
  UIButton *goBackBtn;
  NSString *coupID;
}

@property(nonatomic,retain)UIImageView* backgroundView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic,retain)UILabel *contentLabel;
@property (nonatomic,retain)UIButton *confirmBtn;
@property (nonatomic,retain)UIButton *delayBtn;
@property (nonatomic,retain)UIButton *goBackBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil withCouponId:(NSString*)couponid bundle:(NSBundle *)nibBundleOrNil;

@end
