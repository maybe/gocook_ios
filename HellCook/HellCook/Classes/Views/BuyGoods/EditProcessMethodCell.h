//
//  EditProcessMethodCell.h
//  HellCook
//
//  Created by lxw on 13-11-24.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTextView.h"
#import "KeyboardHandlerDelegate.h"

@class KeyboardHandler;
@interface EditProcessMethodCell : UITableViewCell<UITextViewDelegate,KeyboardHandlerDelegate>
{
  UILabel *titleLabel;
  SSTextView *methodTextField;
  UIButton *confirmBtn;
  KeyboardHandler *keyboard;
}

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) SSTextView *methodTextField;
@property (nonatomic,retain) UIButton *confirmBtn;

@end
