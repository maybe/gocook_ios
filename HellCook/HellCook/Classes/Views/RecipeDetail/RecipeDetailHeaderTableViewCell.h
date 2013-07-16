//
//  RecipeDetailHeaderTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeDetailHeaderTableViewCell : UITableViewCell{
  UILabel* titleLabel;
  UILabel* introLabel;
  UIButton* collectButton;
  UIButton* buyButton;
  UIImageView* imageView;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* introLabel;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIButton* collectButton;
@property (nonatomic, retain) UIButton* buyButton;

- (UILabel*)titleLabel;
- (UILabel*)introLabel;
- (UIImageView*)imageView;
- (UIButton*)collectButton;
- (UIButton*)buyButton;

- (void)setData:(NSMutableDictionary*) dictionary;

@end
