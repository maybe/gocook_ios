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
}

@property (nonatomic, retain) UIView* leftView;
@property (nonatomic, retain) UIView* rightView;

- (UIView*)leftView;
- (UIView*)rightView;

@end
