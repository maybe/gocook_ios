//
//  EditProcessMethodCell.m
//  HellCook
//
//  Created by lxw on 13-11-24.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "EditProcessMethodCell.h"

@implementation EditProcessMethodCell
@synthesize titleLabel,methodTextField,confirmBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320-_offset, 270)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //titleLabel
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 320-_offset, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0]];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [titleLabel setText:@"用户指定加工方式："];
    [self addSubview:titleLabel];
    
    //methodTextField
    methodTextField = [[SSTextView alloc] initWithFrame:CGRectMake(20, 45, 280-_offset, 185)];
    [methodTextField setDelegate:self];
    [methodTextField setBackgroundColor: [UIColor whiteColor]];
    methodTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    methodTextField.keyboardType = UIKeyboardTypeDefault;
    methodTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [methodTextField setFont:[UIFont systemFontOfSize:16]];
    methodTextField.returnKeyType = UIReturnKeyDone;
    [methodTextField setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
    [self addSubview:methodTextField];
    
    //confirmBtn
    confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(190, 250, 60, 27)];
    UIImage *btnBakImage = [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"];
    UIImage *strechBakImage = [btnBakImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [btnBakimagePressed stretchableImageWithLeftCapWidth:2 topCapHeight:0];
    [confirmBtn setBackgroundImage:strechBakImage forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:nil action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
  }
  return self;
}


#pragma textview
-(void)textViewDidBeginEditing:(UITextView *)textView
{
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  return YES;
}


@end
