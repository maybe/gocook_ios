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
    self.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];
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
    [mTitleLabel setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
    [mTitleLabel setFont: [UIFont boldSystemFontOfSize:18]];
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
  [label setFont: [UIFont boldSystemFontOfSize:28]];
  [label setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
  label.lineBreakMode = NSLineBreakByWordWrapping;
  label.numberOfLines = 0;
  [label setBackgroundColor:[UIColor clearColor]];
  [label setText:@""];
  return label;
}

- (TTTAttributedLabel*)createStepContentLabel
{
  TTTAttributedLabel* label = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(64, 0, 224, 0.0)];
  [label setTextColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]];
  [label setFont: [UIFont systemFontOfSize:16]];
  label.lineBreakMode = NSLineBreakByWordWrapping;
  label.numberOfLines = 0;
  [label setBackgroundColor:[UIColor clearColor]];
  [label setText:@""];
  label.lineHeightMultiple = 1.4;
  return label;
}

- (UIImageView*)createStepImage
{
  UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(64, 0, 160, 120)];
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
    
    //图片高度
    UIImageView* imageview = [mStepImageArray objectAtIndex:i];
    if (![imageview isHidden]) {
      mCellHeight += 120;
      mCellHeight += 10;
      mStepOneImageHeight = 120;
    }
    
    //文字高度
    UILabel* label1 = [mStepContentLabelArray objectAtIndex:i];
    //CGSize stepLabelSize = [label1.text sizeWithFont:label1.font constrainedToSize:CGSizeMake(224, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize stepLabelSize = [label1 sizeThatFits:CGSizeMake(label1.frame.size.width, CGFLOAT_MAX)];
    label1.frame = CGRectMake(0.0, 0.0, label1.frame.size.width, stepLabelSize.height);

    mCellHeight += stepLabelSize.height;    
    mStepOneContentHeight = stepLabelSize.height;
    
    UILabel* label2 = [mStepNumberLabelArray objectAtIndex:i];
    CGSize stepNumberSize = [label2.text sizeWithFont:label2.font constrainedToSize:CGSizeMake(224, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    mStepOneNumberHeight = stepNumberSize.height;
    
    mCellHeight += 20;
  }
  
  mCellHeight += 20;
}

- (void)ReformCell
{
  
  //离title高度
  mCellHeight = 10;
  
  //计算title高度
  CGSize titleLabelSize = [mTitleLabel.text sizeWithFont:mTitleLabel.font constrainedToSize:CGSizeMake(256, 1000) lineBreakMode:NSLineBreakByWordWrapping];
  
  mTitleLabelTop = mCellHeight;
  mCellHeight += titleLabelSize.height;
  mTitleLabelHeight = titleLabelSize.height;
  
  CGRect titleRect = CGRectMake(32, mTitleLabelTop, 256, mTitleLabelHeight);
  [mTitleLabel setFrame: titleRect];
  
  mCellHeight += 20;
  
  mStepTop = mCellHeight;
  
  //计算用料高度
  for (int i = 0; i < mStepContentLabelArray.count; i++) {
    
    UILabel* label2 = [mStepNumberLabelArray objectAtIndex:i];
    CGSize stepNumberSize = [label2.text sizeWithFont:label2.font constrainedToSize:CGSizeMake(224, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    mStepOneNumberHeight = stepNumberSize.height;
    [label2 setFrame:CGRectMake(32, mCellHeight - 2, 224, mStepOneNumberHeight)];
    
    //图片高度
    UIImageView* imageview = [mStepImageArray objectAtIndex:i];
    if (![imageview isHidden]) {
      mStepOneImageHeight = 120;
      [imageview setFrame:CGRectMake(64, mCellHeight, 160, mStepOneImageHeight)];
      mCellHeight += 120;
      mCellHeight += 10;
    }
    
    //文字高度
    UILabel* label1 = [mStepContentLabelArray objectAtIndex:i];
    //CGSize stepLabelSize = [label1.text sizeWithFont:label1.font constrainedToSize:CGSizeMake(224, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize stepLabelSize = [label1 sizeThatFits:CGSizeMake(label1.frame.size.width, CGFLOAT_MAX)];
    label1.frame = CGRectMake(0.0, 0.0, label1.frame.size.width, stepLabelSize.height);

    mStepOneContentHeight = stepLabelSize.height;
    [label1 setFrame:CGRectMake(64, mCellHeight, 224, mStepOneContentHeight)];
    
    mCellHeight += stepLabelSize.height;
    
    mCellHeight += 20;
  }
  
  mCellHeight += 20;
  
  
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
    [label1 setText: [NSString stringWithFormat:@"%d", i+1]];
    
    UILabel* label2 = [mStepContentLabelArray objectAtIndex:i];
    [label2 setText:pDic[@"content"]];
    
    UIImageView* image = [mStepImageArray objectAtIndex:i];
    if ([pDic[@"img"] isEqualToString:@""]) {
      [image setImage:nil];
      [image setHidden:YES];
    }
    else {
      
      NetManager* netManager = [NetManager sharedInstance];
      
      NSString* imageurl = @"";
      if ([[pDic[@"img"] substringToIndex:4] isEqual:@"http"]) {
        imageurl = pDic[@"img"];
      } else {
        imageurl = [NSString stringWithFormat: @"http://%@/images/recipe/step/%@", netManager.host, pDic[@"img"]];
      }
      
      [image setImageWithURL:[NSURL URLWithString: imageurl] placeholderImage:nil];
      [image setHidden:NO];
    }
  }
}


@end
