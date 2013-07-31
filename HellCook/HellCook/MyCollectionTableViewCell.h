//
//  MyCollectionTableViewCell.h
//  HellCook
//
//  Created by lxw on 13-7-28.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionTableViewCell : UITableViewCell
{
  UILabel* titleLabel;
  UILabel* materialLabel;
  UIImageView* imageView;
  UIImageView* maskImageView;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* materialLabel;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIImageView* maskImageView;

- (UILabel*)titleLabel;
- (UILabel*)materialLabel;
- (UIImageView*)imageView;
- (UIImageView*)maskImageView;


- (void)setData:(NSMutableDictionary*) dictionary;

@end
