//
//  TopListTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeDetailBaseTableViewCell.h"

@interface RecipeDetailMaterialTableViewCell : RecipeDetailBaseTableViewCell{
  UILabel* mTitleLabel;
  // UILabel* mTemplateMaterialLabel;
  NSMutableArray* mLineArray;
  NSMutableArray* mMaterialLabelArray;
  NSMutableArray* mWeightLabelArray;
  UIButton* buyButton;
  UIButton* shoppingListButton;

  CGFloat mTitleLabelTop;
  CGFloat mTitleLabelHeight;
  
  CGFloat mMaterialTop;
  //CGFloat mMaterialOneHeight;
}

@property (nonatomic, retain) UILabel* mTitleLabel;
@property (nonatomic, retain) NSMutableArray* mMaterialLabelArray;
@property (nonatomic, retain) NSMutableArray* mWeightLabelArray;
@property (nonatomic, retain) NSMutableArray* mLineArray;
@property (nonatomic, retain) UIButton* buyButton;
@property (nonatomic, retain) UIButton* shoppingListButton;

- (UILabel*)mTitleLabel;
- (UILabel*)createMaterialLabel;
- (UIImageView*)createLine;

@end
