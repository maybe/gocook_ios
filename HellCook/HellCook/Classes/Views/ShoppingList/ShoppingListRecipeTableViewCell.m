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
#import "ShoppingListController.h"


@implementation ShoppingListRecipeTableViewCell
@synthesize titleLabel, delButton, buyButton, rightArrow, cellDictionary;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, 60)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self addSubview: [self titleLabel]];
        
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
    
    [delButton addTarget:self action:@selector(delOneRecipe:) forControlEvents:UIControlEventTouchUpInside];
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
    
    [buyButton addTarget:nil action:@selector(gotoMaterialSearchBuy) forControlEvents:UIControlEventTouchUpInside];
  }
  return buyButton;
}


- (void)delOneRecipe:(id)sender
{
  [self hideOptionButton];
  
  [((ShoppingListController*)[self viewController]) delOneRecipeFromShoppingList:sender];
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

- (UILabel*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 14, 168, 30)];
    [titleLabel setTextColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]];
    [titleLabel setFont: [UIFont boldSystemFontOfSize:22]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@""];
  }
  return titleLabel;
}

- (void)setData:(NSMutableDictionary*) dictionary
{
  [titleLabel setText: dictionary[@"name"]];
  [self setAssociativeObject:dictionary[@"recipeid"] forKey:@"recipeid"];
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

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation ShoppingListMaterialTableViewCell
@synthesize middleLine, titleLabel, weightLabel, cellDictionary;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, 44)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self addSubview: [self titleLabel]];
    [self addSubview: [self weightLabel]];
    
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
    
    cellDictionary[@"select"] = @"slash";

    NSIndexPath *indexPath = [[self relatedTable] indexPathForCell: self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShoppingListSlashMaterialItem" object:[NSNumber numberWithInt:indexPath.row]];
        
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
    
    cellDictionary[@"select"] = @"unslash";

    NSIndexPath *indexPath = [[self relatedTable] indexPathForCell: self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShoppingListUnSlashMaterialItem" object:[NSNumber numberWithInt:indexPath.row]];
    
    [UIView animateWithDuration:0.2 animations:^{
      CGRect endFrame = rect;
      endFrame.size.width = 0;
      middleLine.frame = endFrame;
    } completion:^(BOOL finished) {
      middleLine.hidden = YES;
    }];
  }
}

- (UILabel*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(36, 8, 140, 30)];
    [titleLabel setTextColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]];
    [titleLabel setFont: [UIFont systemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@""];
  }
  return titleLabel;
}

- (UILabel*)weightLabel
{
  if (!weightLabel) {
    weightLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 8, 90, 30)];
    [weightLabel setTextColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]];
    [weightLabel setFont: [UIFont systemFontOfSize:16]];
    [weightLabel setBackgroundColor:[UIColor clearColor]];
    [weightLabel setText:@""];
  }
  return weightLabel;
}

- (void)setData:(NSMutableDictionary*) dictionary
{
  cellDictionary = dictionary;
  [titleLabel setText: dictionary[@"material"]];
  [weightLabel setText:dictionary[@"weight"]];
  
  if (dictionary[@"select"] && [dictionary[@"select"] isEqualToString:@"slash"]) {
    CGRect rect = middleLine.frame;
    rect.size.width = 232;
    [middleLine setFrame:rect];
    middleLine.alpha = 1;
    middleLine.hidden = false;
  } else {
    middleLine.hidden = true;
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
