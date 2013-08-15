//
//  MyIntroductionPicCell.h
//  HellCook
//
//  Created by lxw on 13-8-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIntroductionPicCell : UITableViewCell
{
  UIImageView* bannerImageView;
  UIImageView* avataImageView;
  UILabel* nameLabel;
  UIButton *followBtn;
}

@property (nonatomic, retain) UIImageView* bannerImageView;
@property (nonatomic, retain) UIImageView* avataImageView;
@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain) UIButton *followBtn;

- (void)setData:(NSMutableDictionary*)dict;

@end
