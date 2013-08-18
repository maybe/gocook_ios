//
//  RecipeSendCommentView.h
//  HellCook
//
//  Created by lxw on 13-8-18.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTextView.h"

@interface RecipeSendCommentView : UIView
{
  SSTextView* contentTextView;
  UIButton *sendBtn;
}

@property (nonatomic, retain) SSTextView* contentTextView;
@property (nonatomic, retain) UIButton *sendBtn;

@end
