//
//  MainCatTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "RecipeDetailStepsTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"


@implementation RecipeDetailStepsTableViewCell
@synthesize mTitleLabel, mTemplateStepContentLabel, mStepContentLabelArray, mStepImageArray, mStepNumberLabelArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, 210)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self addSubview: [self mTitleLabel]];
    mTemplateStepContentLabel = [self createStepContentLabel];
    
    mStepNumberLabelArray = [[NSMutableArray alloc]init];
    mStepContentLabelArray = [[NSMutableArray alloc]init];
    mStepImageArray = [[NSMutableArray alloc]init];
  }
  return self;
}


- (UILabel*)mTitleLabel
{
  if (!mTitleLabel) {
    mTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 150, 256, 10)];
    [mTitleLabel setTextColor:[UIColor blackColor]];
    [mTitleLabel setFont: [UIFont boldSystemFontOfSize:17]];
    mTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    mTitleLabel.numberOfLines = 0;
    [mTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mTitleLabel setText:@"做法"];
  }
  return mTitleLabel;
}

- (UILabel*)createStepNumberLabel
{
  UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(64, 0, 224, 10)];
  [label setTextColor:[UIColor blackColor]];
  [label setFont: [UIFont boldSystemFontOfSize:17]];
  label.lineBreakMode = NSLineBreakByWordWrapping;
  label.numberOfLines = 0;
  [label setBackgroundColor:[UIColor clearColor]];
  [label setText:@""];
  return label;
}

- (UILabel*)createStepContentLabel
{
  UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(64, 0, 224, 10)];
  [label setTextColor:[UIColor blackColor]];
  [label setFont: [UIFont systemFontOfSize:14]];
  label.lineBreakMode = NSLineBreakByWordWrapping;
  label.numberOfLines = 0;
  [label setBackgroundColor:[UIColor clearColor]];
  [label setText:@""];
  return label;
}

- (UIImageView*)createStepImage
{
  UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(64, 0, 120, 90)];
  [imageView setContentMode:UIViewContentModeScaleAspectFill];
  [imageView setClipsToBounds:YES];
  imageView.layer.borderWidth = 0.0;

  return imageView;
}

- (void)CalculateCellHeight
{
  //离title高度
  mCellHeight = 10;
  
  //计算title高度
  CGSize titleLabelSize = [mTitleLabel.text sizeWithFont:mTitleLabel.font constrainedToSize:CGSizeMake(256, 1000) lineBreakMode:NSLineBreakByWordWrapping];
  
  mTitleLabelTop = mCellHeight;
  mCellHeight += titleLabelSize.height;
  mTitleLabelHeight = titleLabelSize.height;
  
  mCellHeight += 20;
  
  mStepTop = mCellHeight;
  
  //计算用料高度
  for (int i = 0; i < mStepContentLabelArray.count; i++) {
    
    UIImageView* imageview = [mStepImageArray objectAtIndex:i];
    if (![imageview isHidden]) {
      mCellHeight += 90;
      mStepOneImageHeight = 90;
    }
    
    UILabel* label1 = [mStepContentLabelArray objectAtIndex:i];
    CGSize stepLabelSize = [label1.text sizeWithFont:label1.font constrainedToSize:CGSizeMake(224, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    mCellHeight += 10;
    mCellHeight += stepLabelSize.height;
    mCellHeight += 10;
    
    mStepOneContentHeight = stepLabelSize.height;
    
    UILabel* label2 = [mStepNumberLabelArray objectAtIndex:i];
    CGSize stepNumberSize = [label2.text sizeWithFont:label2.font constrainedToSize:CGSizeMake(224, 1000) lineBreakMode:NSLineBreakByWordWrapping];

    mStepOneNumberHeight = stepNumberSize.height;
  }
  
  mCellHeight += 20;
}

- (void)ReformCell
{
  CGRect titleRect = CGRectMake(32, mTitleLabelTop, 256, mTitleLabelHeight);
  [mTitleLabel setFrame: titleRect];
  
  //计算用料高度
  for (int i = 0; i < mStepContentLabelArray.count; i++) {
    
    CGFloat image_y = mStepTop + (mStepOneImageHeight + mStepOneContentHeight + 30) * i;
    CGFloat number_y = image_y;
    CGFloat content_y = 0;
    UIImageView* imageview = [mStepImageArray objectAtIndex:i];
    if ([imageview isHidden]) {
      content_y = image_y;
    }
    else {
      content_y = image_y + mStepOneImageHeight + 10;
    }
    
    [imageview setFrame:CGRectMake(64, image_y, 120, mStepOneImageHeight)];
    
    UILabel* label1 = [mStepNumberLabelArray objectAtIndex:i];
    [label1 setFrame:CGRectMake(32, number_y, 224, mStepOneNumberHeight)];
    
    UILabel* label2 = [mStepContentLabelArray objectAtIndex:i];
    [label2 setFrame:CGRectMake(64, content_y, 224, mStepOneContentHeight)];
  }
  
  CGRect selfRect = CGRectMake(0, 0, 320, mCellHeight);
  [self setFrame:selfRect];
}


- (void)setData:(NSMutableDictionary*) dictionary
{
  NSArray* stepArray = dictionary[@"steps"];
  
  int stepCount = stepArray.count;
  if (mStepContentLabelArray.count < stepCount) {
    int labelcount = mStepContentLabelArray.count;
    for (int i = 0; i < stepCount - labelcount; i++) {
      UILabel* label1 = [self createStepContentLabel];
      UILabel* label2 = [self createStepNumberLabel];
      UIImageView* image = [self createStepImage];
      
      [mStepContentLabelArray addObject: label1];
      [mStepNumberLabelArray addObject:label2];
      [mStepImageArray addObject:image];
      
      [self addSubview:label1];
      [self addSubview:label2];
      [self addSubview:image];
    }
  }
  else if (mStepContentLabelArray.count > stepCount) {
    int labelcount = mStepContentLabelArray.count;
    for (int i = 0; i < labelcount - stepCount; i++) {
      [[mStepImageArray lastObject] removeFromSuperview];
      [[mStepContentLabelArray lastObject] removeFromSuperview];
      [[mStepNumberLabelArray lastObject] removeFromSuperview];

      [mStepImageArray removeLastObject];
      [mStepContentLabelArray removeLastObject];
      [mStepNumberLabelArray removeLastObject];
    }
  }
  
  for (int i = 0; i < stepCount; i++) {
    NSDictionary* pDic = [stepArray objectAtIndex:i];
    
    UILabel* label1 = [mStepNumberLabelArray objectAtIndex:i];
    [label1 setText: [NSString stringWithFormat:@"%d", i]];
    
    UILabel* label2 = [mStepContentLabelArray objectAtIndex:i];
    [label2 setText:pDic[@"content"]];
    
    UIImageView* image = [mStepImageArray objectAtIndex:i];
    if ([pDic[@"img"] isEqualToString:@""]) {
      [image setImage:nil];
      [image setHidden:YES];
    }
    else {
      [image setImageWithURL:[NSURL URLWithString: pDic[@"img"]] placeholderImage:nil];
      [image setHidden:NO];
    }
  }
}


@end
