//
//  RecipeDetailHeaderTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeDetailBaseTableViewCell.h"
#import "TTTAttributedLabel.h"


@interface RecipeDetailTipsTableViewCell : RecipeDetailBaseTableViewCell{
  UILabel* titleLabel;
  TTTAttributedLabel* tipsLabel;

  CGFloat mTitleLabelTop;
  CGFloat mIntroLabelTop;
  CGFloat mTitleLabelHeight;
  CGFloat mIntroLabelHeight;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) TTTAttributedLabel* tipsLabel;

- (UILabel*)titleLabel;
- (TTTAttributedLabel*)tipsLabel;

@end
