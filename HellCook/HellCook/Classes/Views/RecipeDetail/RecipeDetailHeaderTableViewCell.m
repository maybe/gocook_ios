//
//  RecipeDetailHeaderTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "RecipeDetailHeaderTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"


@implementation RecipeDetailHeaderTableViewCell
@synthesize titleLabel,imageView,buyButton,collectButton,introLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 210)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
      [self addSubview:imageView];
      
      [self addSubview: [self titleLabel]];
      [self addSubview:[self introLabel]];

      [self addSubview: [self collectButton]];
      [self addSubview: [self buyButton]];

    }
    return self;
}


- (UILabel*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 150, 256, CGFLOAT_MAX)];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont: [UIFont boldSystemFontOfSize:17]];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@""];
  }
  return titleLabel;
}

- (UILabel*)introLabel
{
  if (!introLabel) {
    introLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 150, 256, CGFLOAT_MAX)];
    [introLabel setTextColor:[UIColor blackColor]];
    [introLabel setFont: [UIFont systemFontOfSize:14]];
    introLabel.numberOfLines = 0;
    introLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [introLabel setBackgroundColor:[UIColor clearColor]];
    [introLabel setText:@""];
  }
  return introLabel;
}

- (UIButton*)buyButton
{
  if (!buyButton) {
    buyButton = [[UIButton alloc]initWithFrame:CGRectMake(180, 100, 120, 30)];
    [buyButton setTitle:@"购买清单" forState:UIControlStateNormal];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [buyButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    
    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [buyButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    
    //[collectButton addTarget:self action:@selector(openLoginWindow) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return buyButton;
}

- (UIButton*)collectButton
{
  if (!collectButton) {
    collectButton = [[UIButton alloc]initWithFrame:CGRectMake(90, 100, 120, 30)];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/grayStretchBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [collectButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    
    UIImage *buttonBackgroundImagePressed = [UIImage imageNamed:@"Images/grayStretchBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [buttonBackgroundImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [collectButton setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    
    //[collectButton addTarget:self action:@selector(openLoginWindow) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return collectButton;
}

- (void)CalculateCellHeight
{
  //封面高度
  mCellHeight = 200;
  
  //离title高度
  mCellHeight += 38;
  
  //计算title高度
  CGSize titleLabelSize = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(256, 1000) lineBreakMode:NSLineBreakByWordWrapping];
  
  mTitleLabelTop = mCellHeight;
  mCellHeight += titleLabelSize.height;
  mTitleLabelHeight = titleLabelSize.height;
  
  //计算描述信息高度
  CGSize introLabelSize = [introLabel.text sizeWithFont:introLabel.font constrainedToSize:CGSizeMake(256, 1000) lineBreakMode:NSLineBreakByWordWrapping];

  mIntroLabelTop = mCellHeight;
  mCellHeight += introLabelSize.height;
  mIntroLabelHeight = introLabelSize.height;
  
  mCellHeight += 100;
}

- (void)ReformCell
{
  CGRect titleRect = CGRectMake(32, mTitleLabelTop, 256, mTitleLabelHeight);
  [titleLabel setFrame: titleRect];
  
  CGRect introRect = CGRectMake(32, mIntroLabelTop, 256, mIntroLabelHeight);
  [introLabel setFrame: introRect];

  CGRect selfRect = CGRectMake(0, 0, 320, mIntroLabelHeight);
  [self setFrame:selfRect];
}

- (void)setData:(NSDictionary*) dictionary
{
  [titleLabel setText:dictionary[@"recipe_name"]];
  [introLabel setText:dictionary[@"intro"]];
  
  NetManager* netManager = [NetManager sharedInstance];
      
  NSString* imageUrl = [NSString stringWithFormat: @"http://%@/%@", netManager.host, dictionary[@"cover_image"]];
        
  [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}


@end
