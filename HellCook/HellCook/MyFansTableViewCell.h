//
//  MyFansTableViewCell.h
//  HellCook
//
//  Created by lxw on 13-8-9.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFansTableViewCell : UITableViewCell
{
  UIImageView *avataImageView;
  UILabel *nameLabel;
  
  UIImageView* sepImageView;
}

@property (nonatomic, retain) UIImageView* avataImageView;
@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain)UIImageView* sepImageView;

- (void)setData:(NSMutableDictionary*)dict;



@end
