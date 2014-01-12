//
//  MyFollowTableViewCell.h
//  HellCook
//
//  Created by lxw on 13-8-7.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFollowTableViewCell : UITableViewCell
{
  UIImageView *avataImageView;
  UILabel *nameLabel;
  UILabel *fansLabel;
  UILabel *recipeLabel;
  
  UIImageView* sepImageView;
}

@property (nonatomic, retain) UIImageView* avataImageView;
@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain) UILabel* fansLabel;
@property (nonatomic, retain) UILabel* recipeLabel;
@property (nonatomic, retain)UIImageView* sepImageView;

- (void)setData:(NSMutableDictionary*)dict;

@end
