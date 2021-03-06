//
//  SearchTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipeStepTableViewCell.h"
#import "UIImageView+ProgressView.h"
#import "Recipe.h"


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
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/AddMaterialLineNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [mAddButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    
    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/AddMaterialLineNormal.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [mAddButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    
    [mAddButton addTarget:nil action:@selector(addStepLine) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:mAddButton];
  }
  return self;
}

@end

@implementation MyRecipeStepTableViewCell
@synthesize stepTextView, delegate, selectButton, defaultImage, upImageView, indexInTable, delButton, selectImageButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 130)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      UIImage *leftBackgroundImage = [UIImage imageNamed:@"Images/WhiteBlock.png"];
      UIImageView*leftImageView = [[UIImageView alloc] initWithImage:leftBackgroundImage];
      [leftImageView setFrame:CGRectMake(10, 10, 175, 120)];
   
      UIImage *rightBackgroundImage = [UIImage imageNamed:@"Images/WhiteBlock.png"];
      UIImageView*rightImageView = [[UIImageView alloc] initWithImage:rightBackgroundImage];
      [rightImageView setFrame:CGRectMake(190, 10, 120, 120)];

      [self addSubview:leftImageView];
      [self addSubview:rightImageView];
      
      stepTextView = [[SSTextView alloc]init];
      [stepTextView setDelegate:self];
      [stepTextView setFrame:CGRectMake(26, 6, 162, 115)];
      [stepTextView setBackgroundColor: [UIColor clearColor]];
      stepTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
      stepTextView.keyboardType = UIKeyboardTypeDefault;
      stepTextView.autocorrectionType = UITextAutocorrectionTypeNo;
      [stepTextView setFont:[UIFont systemFontOfSize:15]];
      stepTextView.returnKeyType = UIReturnKeyDone;
      [stepTextView setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      
      [self addSubview:stepTextView];
      
      
      defaultImage = [UIImage imageNamed:@"Images/NoStepImage.png"];
      upImageView = [[UIImageView alloc]initWithImage:defaultImage];
      [upImageView setContentMode:UIViewContentModeScaleAspectFill];
      [upImageView setClipsToBounds:YES];
      [upImageView setFrame:CGRectMake(195, 15, 110, 105)];
      [self addSubview:upImageView];

      selectImageButton = [[UIButton alloc]init];
      [selectImageButton setFrame:CGRectMake(195, 15, 110, 105)];
      [selectImageButton setBackgroundColor:[UIColor clearColor]];
      [selectImageButton addTarget:[self viewController] action:@selector(onSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:selectImageButton];


      selectButton = [[UIButton alloc]init];
      [selectButton setFrame:CGRectMake(220, 90, 60, 28)];
      
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/rightPageButtonBackgroundNormal.png"];
      UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
      [selectButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
      
      UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/rightPageButtonBackgroundHighlighted.png"];
      UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
      [selectButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
      
      [selectButton setTitle:@"+图片" forState:UIControlStateNormal];
      [selectButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
      
      [selectButton addTarget:[self viewController] action:@selector(onSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
      
      [self addSubview:selectButton];

      delButton = [[UIButton alloc]init];
      [delButton setFrame:CGRectMake(10, 10, 20, 20)];

      UIImage *delButtonBackgroundImage = [UIImage imageNamed:@"Images/DeleteStepNormal.png"];
      [delButton setBackgroundImage:delButtonBackgroundImage forState:UIControlStateNormal];

      UIImage *delButtonBackgroundImagePressed = [UIImage imageNamed:@"Images/DeleteStepHighLight.png"];
      [delButton setBackgroundImage:delButtonBackgroundImagePressed forState:UIControlStateHighlighted];

      [delButton addTarget:[self viewController] action:@selector(onDeleteOneStep:) forControlEvents:UIControlEventTouchUpInside];

      [self addSubview:delButton];

      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignTextViewFirstResponder) name:@"ResignMyRecipeStepTextView" object:nil];

    }
    return self;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
  if (self.delegate) {
    NSIndexPath *indexPath = [[self relatedTable] indexPathForCell: self];
    [delegate changeInputData:textView.text WithIndex:indexPath.row];
  }
  
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView
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

- (void)resignTextViewFirstResponder
{
  [stepTextView resignFirstResponder];
}

- (void)setData:(NSMutableDictionary*) dictionary
{
  [stepTextView setText:dictionary[@"step"]];
  [stepTextView setPlaceholder: [NSString stringWithFormat:@"步骤:%d", self.indexInTable+1]];

  if ([[dictionary allKeys] containsObject:@"imageState"] && [dictionary[@"imageState"] intValue] == RecipeImage_UPLOADED)
  {
    if ([[dictionary allKeys] containsObject: @"pickRealImage"]) {
      [upImageView setImage:dictionary[@"pickRealImage"]];
    } else if ([[dictionary allKeys] containsObject:@"tmpImageUrl"]) {
      [upImageView setImageWithURL:[NSURL URLWithString:[Common getUrl:dictionary[@"tmpImageUrl"] withType:RecipeStepImageUrl]]
                  placeholderImage:[UIImage imageNamed:@"Images/defaultUpload.png"] usingProgressView:nil];
    } else {
      [upImageView setImageWithURL:[NSURL URLWithString:[Common getUrl:dictionary[@"imageUrl"] withType:RecipeStepImageUrl]]
                  placeholderImage:[UIImage imageNamed:@"Images/defaultUpload.png"] usingProgressView:nil];
    }
  } else {
    [upImageView setImage:defaultImage];
    [selectButton setTitle:@"+图片" forState:UIControlStateNormal];
  }
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
