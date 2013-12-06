//
//  MyIntroductionIntroCell.h
//  HellCook
//
//  Created by lxw on 13-8-6.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIntroductionIntroCell : UITableViewCell
{
  UILabel *introLabel;
  CGFloat mCellHeight;
}

@property (nonatomic, retain) UILabel* introLabel;


- (void)calculateCellHeight:(NSString*)strIntro;
- (CGFloat)GetCellHeight;

@end
