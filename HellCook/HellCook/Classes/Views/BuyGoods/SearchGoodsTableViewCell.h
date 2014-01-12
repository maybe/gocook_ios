//
//  SearchGoodsTableViewCell.h
//  HellCook
//
//  Created by lxw on 13-9-4.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchGoodsTableViewCell : UITableViewCell
{
  UILabel *nameLabel;
  UILabel *specLabel;
  UILabel *unitLabel;
  UILabel *priceLabel;
  UIImageView* sepImageView;
  UIImageView *rightImageView;
}

@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *specLabel;
@property (nonatomic,retain) UILabel *unitLabel;
@property (nonatomic,retain) UILabel *priceLabel;
@property (nonatomic, retain) UIImageView* sepImageView;
@property (nonatomic, retain) UIImageView* rightImageView;

- (void)setData:(NSMutableDictionary*)dict;

@end
