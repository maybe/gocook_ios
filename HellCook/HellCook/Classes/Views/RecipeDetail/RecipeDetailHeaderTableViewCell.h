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
  UIButton* likeButton;
  UILabel* likeLabel;
  UIButton* unlikeButton;
  UIImageView* imageView;
  UIButton* authorButton;
  UILabel * authorLabel;
  
  UIButton* shareButton;

  CGFloat mTitleLabelTop;
  CGFloat mIntroLabelTop;
  CGFloat mTitleLabelHeight;
  CGFloat mLikeButtonTop;
  CGFloat mIntroLabelHeight;
  CGFloat mAuthorButtonTop;
  CGFloat mCollButtonTop;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) TTTAttributedLabel* introLabel;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIButton* collectButton;
@property (nonatomic, retain) UIButton* buyButton;
@property (nonatomic, retain) UIButton* likeButton;
@property (nonatomic, retain) UIButton* unlikeButton;
@property (nonatomic, retain) UILabel* likeLabel;
@property (nonatomic, retain) UIButton* authorButton;
@property (nonatomic, retain) UILabel* authorLabel;

- (UILabel*)titleLabel;
- (TTTAttributedLabel*)introLabel;
- (UIButton*)collectButton;
- (UIButton*)buyButton;

@end