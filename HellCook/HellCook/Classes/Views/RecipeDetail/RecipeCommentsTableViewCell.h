//
//  RecipeCommentsTableViewCell.h
//  HellCook
//
//  Created by lxw on 13-8-17.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCommentsTableViewCell : UITableViewCell
{
  UIImageView *avataImageView;
  UILabel *commentLabel;
  UILabel *dateLabel;
  NSInteger mCellHeight;
  
  UIImageView* sepImageView;
}

@property (nonatomic, retain) UIImageView* avataImageView;
@property (nonatomic, retain) UILabel* commentLabel;
@property (nonatomic, retain) UILabel* dateLabel;
@property (nonatomic, retain) UIImageView* sepImageView;

- (void)setData:(NSMutableDictionary*)dict;
- (void)caculateCellHeight:(NSString*)strComment;

@end
