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
//type=0表示M6券，1广告，2延期获取，3网络商家券，-1使用过的券

@end
