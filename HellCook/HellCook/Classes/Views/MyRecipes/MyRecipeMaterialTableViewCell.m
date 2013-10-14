//
//  SearchTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MyRecipeMaterialTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"
#import "KeyboardHandler.h"


@implementation MyRecipeMaterialTableViewHeader
-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    UIImageView* bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/TableCellSeparater.png"]];
    [bottomLine setFrame:CGRectMake(0, 43, 320, 1)];
    [self addSubview: bottomLine];
  }
  return self;
}
@end

@implementation MyRecipeMaterialTableViewFooter
@synthesize mAddButton;

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    mAddButton = [[UIButton alloc]init];
    mAddButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
    [mAddButton setTitle:@"+加一行" forState:UIControlStateNormal];
    [mAddButton.titleLabel setFont: [UIFont boldSystemFontOfSize:13]];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [mAddButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    
    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [mAddButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    
    [mAddButton addTarget:nil action:@selector(addMaterialLine) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:mAddButton];
  }
  return self;
}

@end

@implementation MyRecipeMaterialTableViewCell
@synthesize materialTextField, weightTextField, middleLine, bottomLine, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 44)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      materialTextField = [[UITextField alloc]init];
      [materialTextField setDelegate:self];
      [materialTextField setFrame:CGRectMake(10, 10, 140, 32)];
      [materialTextField setBackgroundColor: [UIColor clearColor]];
      materialTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
      materialTextField.keyboardType = UIKeyboardTypeDefault;
      materialTextField.autocorrectionType = UITextAutocorrectionTypeNo;
      [materialTextField setFont:[UIFont systemFontOfSize:15]];
      materialTextField.returnKeyType = UIReturnKeyDone;
      [materialTextField setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      
      weightTextField = [[UITextField alloc]init];
      [weightTextField setDelegate:self];
      [weightTextField setFrame:CGRectMake(170, 10, 140, 32)];
      [weightTextField setBackgroundColor: [UIColor clearColor]];
      weightTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
      weightTextField.keyboardType = UIKeyboardTypeDefault;
      weightTextField.autocorrectionType = UITextAutocorrectionTypeNo;
      [weightTextField setFont:[UIFont systemFontOfSize:15]];
      weightTextField.returnKeyType = UIReturnKeyDone;
      [weightTextField setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      
      middleLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/TableCellSeparater.png"]];
      [middleLine setFrame:CGRectMake(159, 0, 1, 43)];
      
      bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/TableCellSeparater.png"]];
      [bottomLine setFrame:CGRectMake(0, 43, 320, 1)];
      
      [self addSubview:materialTextField];
      [self addSubview:weightTextField];
      [self addSubview:middleLine];
      [self addSubview:bottomLine];
      
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignTextFieldFirstResponder) name:@"ResignMyRecipeMaterialTextField" object:nil];

    }
    return self;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  int type = 0;
  if (textField == weightTextField) {
    type = 1;
  }
  
  if (self.delegate) {
    NSIndexPath *indexPath = [[self relatedTable] indexPathForCell: self];
    [delegate changeInputData:textField.text On:type WithIndex:indexPath.row];
  }
  
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

- (void)resignTextFieldFirstResponder
{
  [materialTextField resignFirstResponder];
  [weightTextField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
}

- (void)setData:(NSMutableDictionary*) dictionary
{
  [materialTextField setText:dictionary[@"material"]];
  [weightTextField setText:dictionary[@"weight"]];
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
