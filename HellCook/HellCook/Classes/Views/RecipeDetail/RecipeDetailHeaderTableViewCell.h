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
  UIButton* authorButton;
  UILabel * authorLabel;

  CGFloat mTitleLabelTop;
  CGFloat mIntroLabelTop;
  CGFloat mTitleLabelHeight;
  CGFloat mIntroLabelHeight;
  CGFloat mAuthorButtonTop;
  CGFloat mCollButtonTop;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) TTTAttributedLabel* introLabel;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIButton* collectButton;
@property (nonatomic, retain) UIButton* buyButton;
@property (nonatomic, retain) UIButton* authorButton;
@property (nonatomic, retain) UILabel* authorLabel;

- (UILabel*)titleLabel;
- (TTTAttributedLabel*)introLabel;
- (UIButton*)collectButton;
- (UIButton*)buyButton;

@end