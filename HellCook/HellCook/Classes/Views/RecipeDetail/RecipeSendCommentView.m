//
//  RecipeSendCommentView.m
//  HellCook
//
//  Created by lxw on 13-8-18.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "RecipeSendCommentView.h"
#import "QuartzCore/QuartzCore.h"

@implementation RecipeSendCommentView
@synthesize contentTextView, sendBtn;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setBackgroundColor: [UIColor whiteColor]];
    [self setFrame:CGRectMake(0, 0, 320, 40)];
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //contentTextView
    contentTextView = [[SSTextView alloc] initWithFrame:CGRectMake(5, 4, 255, 30)];
    [contentTextView setBackgroundColor: [UIColor clearColor]];
    contentTextView.placeholder = @"评论";
    contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    contentTextView.keyboardType = UIKeyboardTypeDefault;
    contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [contentTextView setFont:[UIFont systemFontOfSize:14]];
    contentTextView.returnKeyType = UIReturnKeyDone;
    [contentTextView setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
    //sendBtn
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(265, 6, 50, 28)];
    [sendBtn setBackgroundColor:[UIColor clearColor]];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"Images/rightPageButtonBackgroundNormal.png"] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"Images/rightPageButtonBackgroundHighlighted.png"] forState:UIControlStateHighlighted];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:nil action:@selector(tapSend) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:contentTextView];
    [self addSubview:sendBtn];
  }
  return self;
}

- (void)hideTextView
{
  [contentTextView resignFirstResponder];
}

- (void)emptyTextView
{
  contentTextView.text = @"";
}


@end
