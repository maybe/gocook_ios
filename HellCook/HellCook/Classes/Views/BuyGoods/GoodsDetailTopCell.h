//
//  GoodsDetailTopCell.h
//  HellCook
//
//  Created by lxw on 13-9-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailTopCell : UITableViewCell
{
  UIImageView* imageView;
  UIImage* defaultImage;
}

@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic,retain) UIImage* defaultImage;

-(void)setData:(NSMutableDictionary*)dict;

@end
