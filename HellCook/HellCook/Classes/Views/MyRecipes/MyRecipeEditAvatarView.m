//
//  RegisterAvatarView.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipeEditAvatarView.h"

@implementation MyRecipeEditAvatarView
@synthesize selectButton,upImageView,defaultImage,selectImageButton;

- (id)initWithFrame:(CGRect)frame
{  
  if(self=[super initWithFrame:frame]){
    [self InitLayout];
  }
  return self;
}

- (void)InitLayout
{
  [self setBackgroundColor:[UIColor whiteColor]];
  defaultImage = [UIImage imageNamed:@"Images/defaultUpload.png"];
  upImageView = [[UIImageView alloc]initWithImage:defaultImage];
  [upImageView setContentMode:UIViewContentModeScaleAspectFill];
  [upImageView setClipsToBounds:YES];
  [upImageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
  [self addSubview:upImageView];
  
  selectImageButton = [[UIButton alloc]init];
  [selectImageButton setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
  [selectImageButton setBackgroundColor:[UIColor clearColor]];
  [selectImageButton addTarget:[self viewController] action:@selector(onSelectImageButton) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:selectImageButton];
  
  selectButton = [[UIButton alloc]init];
  [selectButton setFrame:CGRectMake(self.frame.size.width/2-30, 100, 60, 28)];

  UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/redStretchBackgroundNormal.png"];
  UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [selectButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
  
  UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/redStretchBackgroundHighlighted.png"];
  UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [selectButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
  
  [selectButton setTitle:@"未选择" forState:UIControlStateNormal];
  [selectButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];

  [selectButton addTarget:[self viewController] action:@selector(onSelectButton:) forControlEvents:UIControlEventTouchUpInside];
  
  [self addSubview:selectButton];
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
