//
//  SearchTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "ShoppingListRecipeTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"


@implementation ShoppingListRecipeTableViewCell
@synthesize titleLabel, delButton, buyButton, rightArrow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, 60)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self addSubview: [self delButton]];
    [self addSubview: [self buyButton]];
    
    buyButton.hidden = YES;
    delButton.hidden = YES;
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeRight:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:oneFingerSwipeRight];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOptionButton) name:@"ShoppingListHideOptionButton" object:nil];

  }
  return self;
}

- (void)hideOptionButton
{
  if (buyButton.hidden == NO) {
    buyButton.alpha = 1;
    delButton.alpha = 1;
    
    [UIView animateWithDuration:0.15 animations:^{
      buyButton.alpha = 0;
      delButton.alpha = 0;
    } completion:^(BOOL finished) {
      buyButton.hidden = YES;
      delButton.hidden = YES;
    }];
  }
}

- (id)delButton
{
  if (!delButton) {
    delButton = [[UIButton alloc]initWithFrame:CGRectMake(105, 15, 80, 30)];
    [delButton setTitle:@"删 除" forState:UIControlStateNormal];
    [delButton.titleLabel setFont: [UIFont boldSystemFontOfSize:13]];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [delButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    
    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [delButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    
   // [delButton addTarget:self action:@selector(openLoginWindow) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return delButton;
}

- (id)buyButton
{
  if (!buyButton) {
    buyButton = [[UIButton alloc]initWithFrame:CGRectMake(190, 15, 80, 30)];
    [buyButton setTitle:@"购买食材" forState:UIControlStateNormal];
    [buyButton.titleLabel setFont: [UIFont boldSystemFontOfSize:13]];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [buyButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    
    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [buyButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    
   // [buyButton addTarget:self action:@selector(openRegisterWindow) forControlEvents:UIControlEventTouchUpInside];
  }
  return buyButton;
}

- (void)oneFingerSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
  //CGPoint point = [recognizer locationInView:self];
  //NSLog(@"Swipe up - start location: %f,%f", point.x, point.y);
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ShoppingListHideOptionButton" object:nil];

  buyButton.hidden = NO;
  delButton.hidden = NO;
  buyButton.alpha = 0;
  delButton.alpha = 0;
  
  [UIView animateWithDuration:0.3 animations:^{
    buyButton.alpha = 1;
    delButton.alpha = 1;
  } completion:^(BOOL finished) {
  }];
}

- (void)oneFingerSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
  //CGPoint point = [recognizer locationInView:self];
  //NSLog(@"Swipe up - start location: %f,%f", point.x, point.y);
}


- (void)setData:(NSMutableDictionary*) dictionary
{

}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation ShoppingListMaterialTableViewCell
@synthesize middleLine, titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, 44)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    middleLine = [[UIImageView alloc]initWithFrame:CGRectMake(24, 21, 232, 3)];
    [middleLine setImage: [UIImage imageNamed:@"Images/line.png"]];
    middleLine.hidden = YES;
    
    [self addSubview:middleLine];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeRight:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:oneFingerSwipeRight];
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeLeft:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:oneFingerSwipeLeft];
  }
  return self;
}


- (void)oneFingerSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
  //CGPoint point = [recognizer locationInView:self];
  //NSLog(@"Swipe up - start location: %f,%f", point.x, point.y);
  
  if (middleLine.hidden == YES) {
    middleLine.hidden = NO;
    CGRect rect = middleLine.frame;
    
    CGRect beginFrame = rect;
    beginFrame.size.width = 0;
    middleLine.frame = beginFrame;
    
    [UIView animateWithDuration:0.3 animations:^{
      CGRect endFrame = rect;
      endFrame.size.width = 232;
      middleLine.frame = endFrame;
    } completion:^(BOOL finished) {
    }];
  }
}

- (void)oneFingerSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
  //CGPoint point = [recognizer locationInView:self];
  //NSLog(@"Swipe up - start location: %f,%f", point.x, point.y);
  
  if (middleLine.hidden == NO) {
    CGRect rect = middleLine.frame;
    
    CGRect beginFrame = rect;
    beginFrame.size.width = 232;
    middleLine.frame = beginFrame;
    
    [UIView animateWithDuration:0.2 animations:^{
      CGRect endFrame = rect;
      endFrame.size.width = 0;
      middleLine.frame = endFrame;
    } completion:^(BOOL finished) {
      middleLine.hidden = YES;
    }];
  }
}

- (void)setData:(NSMutableDictionary*) dictionary
{
  
}

@end
