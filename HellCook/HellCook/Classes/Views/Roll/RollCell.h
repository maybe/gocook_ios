//
//  RollCell.h
//  HellCook
//
//  Created by lxw on 13-11-9.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RollCell : UITableViewCell
{
  UIImageView* backgroundView;
  UILabel *rollLabel;
  CGFloat height;
}

@property(nonatomic,retain)UIImageView* backgroundView;
@property(nonatomic,retain)UILabel *rollLabel;

-(CGFloat)getCellHeight;

@end
