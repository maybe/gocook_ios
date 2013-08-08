//
//  SearchTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRecipesTableViewCell : UITableViewCell{
  UILabel* titleLabel;
  UILabel* materialLabel;
  UIImageView* imageView;
  UIImageView* maskImageView;
  UIButton* delButton;
  UIButton* modifyButton;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* materialLabel;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIImageView* maskImageView;
@property (nonatomic, retain) UIButton* delButton;
@property (nonatomic, retain) UIButton* modifyButton;


- (UILabel*)titleLabel;
- (UILabel*)materialLabel;
- (UIImageView*)imageView;
- (UIImageView*)maskImageView;

- (void)setAdminButtons;

- (void)setData:(NSMutableDictionary*) dictionary;

@end
