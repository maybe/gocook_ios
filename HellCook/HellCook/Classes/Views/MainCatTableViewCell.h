//
//  MainCatTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCatTableViewCell : UITableViewCell{
  UILabel* titleLabel;
  UIView* imageContainer;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIView* imageContainer;

- (UIView*)titleLabel;
- (UIView*)imageContainer;

@end
