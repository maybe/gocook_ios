//
//  BuyGoodsBelowCell.h
//  HellCook
//
//  Created by lxw on 13-9-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyGoodsBelowCell : UITableViewCell
{
  UILabel *nameLabel;
  UILabel *priceTitleLabel;
  UILabel *priceLabel;
  UILabel *unitLabel;
  UILabel *specLabel;
  UILabel *processTitleLabel;
  UILabel *introTitleLabel;
  UILabel *introLabel;
  UIButton *buyBtn;
  
  NSInteger mCellHeight;
}

@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *priceTitleLabel;
@property (nonatomic,retain) UILabel *priceLabel;
@property (nonatomic,retain) UILabel *unitLabel;
@property (nonatomic,retain) UILabel *specLabel;
@property (nonatomic,retain) UILabel *processTitleLabel;
@property (nonatomic,retain) UILabel *introTitleLabel;
@property (nonatomic,retain) UILabel *introLabel;
@property (nonatomic,retain) UIButton *buyBtn;

@end
