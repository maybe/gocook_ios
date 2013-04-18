//
//  MainTopTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MainTopTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"

@implementation MainTopTableViewCell
@synthesize leftView, rightView, leftImageView, rightImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 116)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      [self addSubview: [self leftView]];
      [self addSubview: [self rightView]];
      
      UIImageView *dotline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Images/homeHeaderSeperator@2x.png"]];
      [dotline setFrame:CGRectMake(0, 115, 320, 1)];
      [self addSubview:dotline];
    }
    return self;
}


- (UIView*)leftView
{
  if (!leftView) {
    leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 13, 145, 90)];
    
    leftImageView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"Images/tmptophot.png"]];
    [leftImageView setContentMode:UIViewContentModeScaleAspectFill];
    [leftImageView setFrame:CGRectMake(0, 0, 145, 90)];
    [leftView addSubview:leftImageView];
    
    UIImageView* maskImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Images/topmask.png"]];
    [maskImageView setFrame:CGRectMake(0, 0, 145, 90)];    
    
    UIView* maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 145, 25)];
    UIColor* maskColor = [UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:29.0f/255.0f alpha:0.8];
    [maskView setBackgroundColor:maskColor];
    [leftView addSubview:maskView];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(28, 67, 90, 20)];
    [label setFont: [UIFont systemFontOfSize:14]];
    [label setText:@"本周最受欢迎"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    label.textColor = [UIColor whiteColor];
    [leftView addSubview:label];
    
    [leftView addSubview:maskImageView];

   // leftView.layer.cornerRadius = 5.0;
  //  leftView.layer.masksToBounds = YES;
//    leftView.layer.borderColor = [UIColor clearColor].CGColor;
//    leftView.layer.borderWidth = 1.0;
//    leftView.layer.shadowOffset = CGSizeMake(0, 3);
//    leftView.layer.shadowOpacity = 0.5;
//    leftView.layer.shadowColor = [UIColor blackColor].CGColor;
    [leftView setClipsToBounds:YES];
    
  }
  return leftView;
}

- (UIView*)rightView
{
  if (!rightView) {
    rightView = [[UIView alloc]initWithFrame:CGRectMake(165, 13, 145, 90)];
    rightImageView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"Images/tmptophot.png"]];
    [rightImageView setContentMode:UIViewContentModeScaleAspectFill];
    [rightImageView setFrame:CGRectMake(0, 0, 145, 90)];
    [rightView addSubview:rightImageView];
    
    UIImageView* maskImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Images/topmask.png"]];
    [maskImageView setFrame:CGRectMake(0, 0, 145, 90)];
    
    UIView* maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 145, 25)];
    UIColor* maskColor = [UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:29.0f/255.0f alpha:0.8];
    [maskView setBackgroundColor:maskColor];
    [rightView addSubview:maskView];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(28, 67, 90, 20)];
    [label setFont: [UIFont systemFontOfSize:14]];
    [label setText:@"本日最受欢迎"];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = [UIColor whiteColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [rightView addSubview:label];
    
    [rightView addSubview:maskImageView];

    
  //  rightView.layer.cornerRadius = 5.0;
//    rightView.layer.masksToBounds = YES;
//    rightView.layer.borderColor = [UIColor clearColor].CGColor;
//    rightView.layer.borderWidth = 1.0;
    [rightView setClipsToBounds:YES];

  }
  return rightView;
}


- (void)setData:(NSDictionary*) dictionary
{  
  NetManager* netManager = [NetManager sharedInstance];
      
  NSString* leftImageUrl = [NSString stringWithFormat: @"http://%@/%@", netManager.host, dictionary[@"tophot_img"]];
      
  [leftImageView setImageWithURL:[NSURL URLWithString:leftImageUrl] placeholderImage:nil];

  NSString* rightImageUrl = [NSString stringWithFormat: @"http://%@/%@", netManager.host, dictionary[@"topnew_img"]];
  
  [rightImageView setImageWithURL:[NSURL URLWithString:rightImageUrl] placeholderImage:nil];
}

@end