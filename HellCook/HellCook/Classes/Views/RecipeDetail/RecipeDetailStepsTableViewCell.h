//
//  TopListTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeDetailBaseTableViewCell.h"

@interface RecipeDetailStepsTableViewCell : RecipeDetailBaseTableViewCell{
  UILabel* mTitleLabel;
  UILabel* mTemplateStepContentLabel;
  NSMutableArray* mStepNumberLabelArray;
  NSMutableArray* mStepContentLabelArray;
  NSMutableArray* mStepImageArray;
  
  CGFloat mTitleLabelTop;
  CGFloat mTitleLabelHeight;
  
  CGFloat mStepTop;
  CGFloat mStepOneContentHeight;
  CGFloat mStepOneImageHeight;
  CGFloat mStepOneNumberHeight;
}

@property (nonatomic, retain) UILabel* mTitleLabel;
@property (nonatomic, retain) UILabel* mTemplateStepContentLabel;
@property (nonatomic, retain) NSMutableArray* mStepNumberLabelArray;
@property (nonatomic, retain) NSMutableArray* mStepContentLabelArray;
@property (nonatomic, retain) NSMutableArray* mStepImageArray;

- (UILabel*)mTitleLabel;
- (UILabel*)createStepNumberLabel;
- (UILabel*)createStepContentLabel;
- (UIImageView*)createStepImage;

@end
