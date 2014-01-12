//
//  MyIntroAvatarView.h
//  HellCook
//
//  Created by lxw on 13-8-11.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIntroAvatarView : UIView
{
  UIImageView* bannerImageView;
  UIImageView* avataImageView;
  UIButton *uploadBtn;
  NSMutableDictionary *data;
  
  UIImage* defaultImage;
}

@property (nonatomic, retain) UIImageView* bannerImageView;
@property (nonatomic, retain) UIImageView* avataImageView;
@property (nonatomic, retain) UIButton *uploadBtn;
@property (nonatomic,retain) UIImage* defaultImage;

- (id)initWithFrame:(CGRect)frame withData:(NSMutableDictionary*)dict;
- (void)setData:(NSMutableDictionary*)dict;
- (void)setNewImage:(UIImage*)newImage;

@end
