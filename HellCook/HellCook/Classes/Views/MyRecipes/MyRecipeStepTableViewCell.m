//
//  SearchTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipeStepTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"
#import "KeyboardHandler.h"


@implementation MyRecipeStepTableViewHeader
-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}
@end

@implementation MyRecipeStepTableViewFooter
@synthesize mAddButton;

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    mAddButton = [[UIButton alloc]init];
    mAddButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
    [mAddButton setTitle:@"+加一步" forState:UIControlStateNormal];
    [mAddButton.titleLabel setFont: [UIFont boldSystemFontOfSize:13]];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [mAddButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    
    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [mAddButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    
    [mAddButton addTarget:nil action:@selector(addStepLine) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:mAddButton];
  }
  return self;
}

@end

@implementation MyRecipeStepTableViewCell
@synthesize stepTextView, delegate, selectButton, defaultImage, upImageView, indexInTable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 120)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      UIImage *leftBackgroundImage = [UIImage imageNamed:@"Images/RoundTableCellSingle.png"];
      UIImage *stretchedleftBackground = [leftBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
      UIImageView* pleftImageView = [[UIImageView alloc]initWithImage:stretchedleftBackground];
      [pleftImageView setFrame:CGRectMake(10, 10, 179, 120)];
   
      UIImage *rightBackgroundImage = [UIImage imageNamed:@"Images/RoundTableCellSingle.png"];
      UIImage *stretchedrightBackground = [rightBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
      UIImageView* prightImageView = [[UIImageView alloc]initWithImage:stretchedrightBackground];
      [prightImageView setFrame:CGRectMake(190, 10, 120, 120)];
      
      [self addSubview:pleftImageView];
      [self addSubview:prightImageView];
      
      stepTextView = [[SSTextView alloc]init];
      [stepTextView setDelegate:self];
      [stepTextView setFrame:CGRectMake(15, 17, 170, 105)];
      [stepTextView setBackgroundColor: [UIColor clearColor]];
      stepTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
      stepTextView.keyboardType = UIKeyboardTypeDefault;
      stepTextView.autocorrectionType = UITextAutocorrectionTypeNo;
      [stepTextView setFont:[UIFont systemFontOfSize:15]];
      stepTextView.returnKeyType = UIReturnKeyDone;
      [stepTextView setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      
      [self addSubview:stepTextView];
      
      
      defaultImage = [UIImage imageNamed:@"Images/defaultUpload.png"];
      upImageView = [[UIImageView alloc]initWithImage:defaultImage];
      [upImageView setContentMode:UIViewContentModeScaleAspectFill];
      [upImageView setClipsToBounds:YES];
      [upImageView setFrame:CGRectMake(205, 20, 90, 70)];
      [self addSubview:upImageView];
      
      selectButton = [[UIButton alloc]init];
      [selectButton setFrame:CGRectMake(220, 95, 60, 28)];
      
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/redStretchBackgroundNormal.png"];
      UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
      [selectButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
      
      UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/redStretchBackgroundHighlighted.png"];
      UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
      [selectButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
      
      [selectButton setTitle:@"选择" forState:UIControlStateNormal];
      [selectButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
      
      [selectButton addTarget:[self viewController] action:@selector(loadImagePicker) forControlEvents:UIControlEventTouchUpInside];
      
      [self addSubview:selectButton];
      
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignTextViewFirstResponder) name:@"ResignMyRecipeStepTextView" object:nil];

    }
    return self;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
  if (self.delegate) {
    NSIndexPath *indexPath = [(UITableView *)self.superview indexPathForCell: self];
    [delegate changeInputData:textView.text WithIndex:indexPath.row];
  }
  
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
  NSLog(@"111111");
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
  [stepTextView resignFirstResponder];
}

- (void)setData:(NSMutableDictionary*) dictionary
{
  [stepTextView setText:dictionary[@"step"]];
  stepTextView.placeholder = [NSString stringWithFormat:@"步骤:%d", indexInTable+1];
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