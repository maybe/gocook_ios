//
//  MaterialSearchBuyTableViewCell.h
//  HellCook
//
//  Created by lxw on 13-9-2.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialSearchBuyTableViewCell : UITableViewCell
{
  UILabel *nameLabel;
  UILabel *stateLabel;
  UIButton *goBuyBtn;
  
  UILabel *goodsLabel;
  UILabel *specLabel;
  UILabel *amountLabel;
  UILabel *priceLabel;
  UILabel *processLabel;
  
  UIImageView* sepImageView;
  
  NSString *keyword;
}

@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *stateLabel;
@property (nonatomic,retain) UIButton *goBuyBtn;
@property (nonatomic, retain)UIImageView* sepImageView;
@property (nonatomic,retain) UILabel *goodsLabel;
@property (nonatomic,retain) UILabel *specLabel;
@property (nonatomic,retain) UILabel *amountLabel;
@property (nonatomic,retain) UILabel *priceLabel;
@property (nonatomic,retain) UILabel *processLabel;

- (void)setData:(NSMutableDictionary*)dict withRow:(NSInteger)row;

@end
