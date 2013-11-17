//
//  NewCouponsDetailContentCell.h
//  HellCook
//
//  Created by lxw on 13-11-17.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCouponsDetailContentCell : UITableViewCell
{
  UILabel *contentLabel;
  UIImageView *labelBackgroundView;
  UIButton *bottomBtn;
  CGFloat height;
}

@property (nonatomic,retain) UILabel *contentLabel;
@property (nonatomic,retain) UIImageView *labelBackgroundView;
@property (nonatomic,retain) UIButton *bottomBtn;


-(CGFloat)getCellHeight;
- (id)initWithStyle:(UITableViewCellStyle)style withType:(NSInteger)type withData:(NSMutableDictionary*)dict reuseIdentifier:(NSString *)reuseIdentifier;

@end
