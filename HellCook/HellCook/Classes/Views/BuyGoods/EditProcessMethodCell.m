//
//  EditProcessMethodCell.m
//  HellCook
//
//  Created by lxw on 13-11-24.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "EditProcessMethodCell.h"
#import "UIView+FindFirstResponder.h"
#import "KeyboardHandler.h"

@implementation EditProcessMethodCell
@synthesize titleLabel,methodTextField,confirmBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320-_offset, 220)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //titleLabel
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 320-_offset, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0]];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [titleLabel setText:@"用户指定加工方式："];
    [self addSubview:titleLabel];
    
    //methodTextField
    methodTextField = [[SSTextView alloc] initWithFrame:CGRectMake(20, 45, 280-_offset, 95)];
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
    confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(190, 160, 64, 29)];
    UIImage *btnBakImage = [UIImage imageNamed:@"Images/AddMaterialLineNormal.png"];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/AddMaterialLineHighLight.png"];
    [confirmBtn setBackgroundImage:btnBakImage forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setAssociativeObject:@"" forKey:@"content"];
    [confirmBtn addTarget:nil action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];

    //keyboard
    keyboard = [[KeyboardHandler alloc] init];
    keyboard.delegate = self;
  }
  return self;
}


#pragma textview
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
  [confirmBtn setAssociativeObject:methodTextField.text forKey:@"content"];
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
  [confirmBtn setAssociativeObject:methodTextField.text forKey:@"content"];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  return YES;
}

- (void)resignTextViewFirstResponder
{
  [methodTextField resignFirstResponder];
}


#pragma mark - Keyboard

- (void)keyboardSizeChanged:(CGSize)delta
{
  UIView* frView = [[self relatedTable] findFirstResponder];
  if ([frView isKindOfClass:[UITextField class]] || [frView isKindOfClass:[SSTextView class]]) {
    if ([frView isKindOfClass:[SSTextView class]]) {
      frView = frView.superview;
    }
    if (delta.height > 0) {
      CGPoint realOrigin = [frView convertPoint:frView.frame.origin toView:nil];
      if (realOrigin.y + frView.frame.size.height  > _screenHeight - delta.height) {
        CGFloat deltaHeight = realOrigin.y + frView.frame.size.height - ( _screenHeight - delta.height) -30;
        CGRect frame = [self relatedTable].frame;
        frame.origin.y -= deltaHeight;
        if (-frame.origin.y > delta.height) {
          frame.origin.y = - delta.height;
        }
        [self relatedTable].frame = frame;
      }
    }
    else{
      CGRect frame = [self relatedTable].frame;
      frame.origin.y =  0;
      [self relatedTable].frame = frame;
    }
  }
}

- (UITableView *)relatedTable
{
  if ([self.superview isKindOfClass:[UITableView class]])
    return (UITableView *)self.superview;
  else if ([self.superview.superview isKindOfClass:[UITableView class]])
    return (UITableView *)self.superview.superview;
  else
  {
    NSAssert(NO, @"UITableView shall always be found.");
    return nil;
  }
}

@end
