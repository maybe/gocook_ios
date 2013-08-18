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
  
  UIButton *avatarBtn;
  UIButton *nameBtn;
}

@property (nonatomic, retain) UIImageView* avataImageView;
@property (nonatomic, retain) UILabel* commentLabel;
@property (nonatomic, retain) UILabel* dateLabel;
@property (nonatomic, retain) UIImageView* sepImageView;
@property (nonatomic, retain) UIButton *avatarBtn;
@property (nonatomic, retain) UIButton *nameBtn;

- (void)setData:(NSMutableDictionary*)dict;
- (void)caculateCellHeight:(NSString*)strComment;
- (CGFloat)getCellHeight;

@end
