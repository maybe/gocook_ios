//
//  EditProcessMethodCell.h
//  HellCook
//
//  Created by lxw on 13-11-24.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTextView.h"

@interface EditProcessMethodCell : UITableViewCell<UITextViewDelegate>
{
  UILabel *titleLabel;
  SSTextView *methodTextField;
  UIButton *confirmBtn;
}

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) SSTextView *methodTextField;
@property (nonatomic,retain) UIButton *confirmBtn;

@end
