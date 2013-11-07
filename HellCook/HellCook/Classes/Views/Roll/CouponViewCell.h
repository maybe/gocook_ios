//
//  CouponViewCell.h
//  HellCook
//
//  Created by lxw on 13-11-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponViewCell : UITableViewCell
{
  UIImageView* backgroundView;
  UILabel *rollLabel;
  UILabel *contentLabel;
  UIButton *rightBtn;
  UIButton *bottomBtn;
  CGFloat height;
  NSMutableArray *rightBtnsArray;
}

@property(nonatomic,retain)UIImageView* backgroundView;
@property(nonatomic,retain)UILabel *rollLabel;
@property(nonatomic,retain)UILabel *contentLabel;
@property(nonatomic,retain)UIButton *rightBtn;
@property(nonatomic,retain)UIButton *bottomBtn;

- (void)setData:(NSMutableDictionary*)dict withRow:(NSInteger)row withStatus:(NSInteger)status;
//status=0表示未展开状态，status=1表示展开状态

-(CGFloat)getCellHeight;
-(CGFloat)caculateCellHeight:(NSMutableArray*)data withStatus:(NSInteger)status;

@end
