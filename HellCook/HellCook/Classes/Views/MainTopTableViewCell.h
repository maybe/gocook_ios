//
//  MainTopTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTopTableViewCell : UITableViewCell{
  UIView* leftView;
  UIView* rightView;
  
  UIImageView*  leftImageView;
  UIImageView*  rightImageView;
}

@property (nonatomic, retain) UIView* leftView;
@property (nonatomic, retain) UIView* rightView;
@property (nonatomic, retain) UIImageView* leftImageView;
@property (nonatomic, retain) UIImageView* rightImageView;

- (UIView*)leftView;
- (UIView*)rightView;

- (void)setData:(NSDictionary*) dictionary;

@end

@interface MainTopBannerCell : UITableViewCell{
  UIImageView* banner1ImageView;
  UIImageView* banner2ImageView;
  UIImageView* banner3ImageView;

  UIButton* button1;
  UIButton* button2;
  UIButton* button3;
}

@property (nonatomic, retain) UIImageView* banner1ImageView;
@property (nonatomic, retain) UIImageView* banner2ImageView;
@property (nonatomic, retain) UIImageView* banner3ImageView;

@property (nonatomic, retain) UIButton* button1;
@property (nonatomic, retain) UIButton* button2;
@property (nonatomic, retain) UIButton* button3;

@end