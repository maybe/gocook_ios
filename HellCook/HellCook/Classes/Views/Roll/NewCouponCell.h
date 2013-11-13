//
//  NewCouponCell.h
//  HellCook
//
//  Created by lxw on 13-11-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCouponCell : UITableViewCell
{
  UIImageView *backgroundView;
  UILabel *contentLabel;
  CGFloat height;
  UIImageView *rightView;
}

@property(nonatomic,retain)UIImageView* backgroundView;
@property(nonatomic,retain)UILabel *contentLabel;
@property(nonatomic,retain)UIImageView* rightView;

-(CGFloat)getCellHeight;
- (void)setData:(NSMutableDictionary*)data withType:(NSInteger)type;
//type=0表示延期抽取机会，type=1表示有效优惠券，type=2表示过期的

@end
