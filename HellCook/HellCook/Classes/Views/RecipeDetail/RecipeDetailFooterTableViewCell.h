//
//  RecipeDetailFooterTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeDetailFooterTableViewCell : UITableViewCell{
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
