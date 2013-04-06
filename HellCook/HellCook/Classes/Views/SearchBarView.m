//
//  SearchBarView.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "SearchBarView.h"
#import "QuartzCore/QuartzCore.h"

@implementation SearchBarView
@synthesize backImageView,searchField,maskView;

- (id)initWithFrame:(CGRect)frame
{  
  if(self=[super initWithFrame:frame]){
    [self InitLayout];
  }
  return self;
}

- (void)InitLayout
{
  UIImage* backImage = [UIImage imageNamed:@"Images/searchbox.png"];
  backImageView = [[UIImageView alloc]initWithImage: backImage];
  [backImageView setFrame:CGRectMake(10, 7, backImage.size.width, backImage.size.height)];
  
  [self setBackgroundColor:[UIColor colorWithRed:222.0f/255.0f green:222.0f/255.0f blue:222.0f/255.0f alpha:1.0f]];

  self.layer.shadowOffset = CGSizeMake(0, 1);
  self.layer.shadowOpacity = 0.1;
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  
  UIImage* searchIcon = [UIImage imageNamed:@"Images/searchIcon.png"];
  UIImageView* searchIconView = [[UIImageView alloc]initWithImage:searchIcon];
  [searchIconView setFrame:CGRectMake(20, 14, 16, 16)];
  
  searchField = [[UITextField alloc]initWithFrame:CGRectMake(40, 13, 260, 22)];
  [searchField setPlaceholder:@"搜索菜谱"];
  [searchField setBackgroundColor: [UIColor clearColor]];
  [searchField setDelegate:self];
  searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  searchField.keyboardType = UIKeyboardTypeDefault;
  searchField.autocorrectionType = UITextAutocorrectionTypeNo;
  [searchField setFont:[UIFont systemFontOfSize:14]];
  searchField.returnKeyType = UIReturnKeySearch;
  
  [self addSubview:backImageView];
  [self addSubview:searchIconView];
  [self addSubview:searchField];
  
  
  maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
  UIColor* maskColor = [UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:29.0f/255.0f alpha:0.5];
  [maskView setBackgroundColor:maskColor];
  UIButton* maskButton = [[UIButton alloc]initWithFrame:maskView.frame];
  [maskButton addTarget:nil action:@selector(hideMaskView) forControlEvents:UIControlEventTouchUpInside];
  [maskView addSubview:maskButton];
}

- (void)hideMaskView
{
  if ([maskView superview]==nil)
    return;
  
  [searchField resignFirstResponder];
  [UIView animateWithDuration:0.3 animations:^{
    maskView.alpha = 0.0;
  } completion:^(BOOL finished) {
    [maskView removeFromSuperview];
  }];
}

- (void)showMaskView
{
  if ([maskView superview]!=nil)
    return;
  
  [self.superview addSubview:maskView];
  maskView.alpha = 0.0;
  [self.superview bringSubviewToFront:self];
  [UIView animateWithDuration:0.2 animations:^{
    maskView.alpha = 1;
  } completion:^(BOOL finished) {
    
  }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  [self showMaskView];
  return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  [self hideMaskView];
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self hideMaskView];
  if ([[self viewController] respondsToSelector:@selector(goSearch)]) {
    [[self viewController] performSelector:@selector(goSearch)];
  }
  return YES;
}


//to get the next responder controller
- (UIViewController*)viewController {
  for (UIView* next = [self superview]; next; next = next.superview) {
    UIResponder* nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
      return (UIViewController*)nextResponder;
    }
  }
  return nil;
}

@end
