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
  UILabel *fanLabel;
  UILabel *recipeLabel;
}

@property (nonatomic, retain) UIImageView* avataImageView;
@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain) UILabel* fanLabel;
@property (nonatomic, retain) UILabel* recipeLabel;

@end
