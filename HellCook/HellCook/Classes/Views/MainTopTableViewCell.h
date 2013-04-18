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
