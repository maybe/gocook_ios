//
//  TopListTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeDetailBaseTableViewCell.h"
#import "TTTAttributedLabel.h"


@interface RecipeDetailHeaderTableViewCell : RecipeDetailBaseTableViewCell{
  UILabel* titleLabel;
  TTTAttributedLabel* introLabel;
  UIButton* collectButton;
  UIButton* buyButton;
  UIImageView* imageView;

  CGFloat mTitleLabelTop;
  CGFloat mIntroLabelTop;
  CGFloat mTitleLabelHeight;
  CGFloat mIntroLabelHeight;
  CGFloat mCollButtonTop;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) TTTAttributedLabel* introLabel;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIButton* collectButton;
@property (nonatomic, retain) UIButton* buyButton;

- (UILabel*)titleLabel;
- (TTTAttributedLabel*)introLabel;
- (UIButton*)collectButton;
- (UIButton*)buyButton;

@end