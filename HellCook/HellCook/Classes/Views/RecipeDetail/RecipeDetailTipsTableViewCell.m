//
//  RecipeDetailHeaderTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "RecipeDetailTipsTableViewCell.h"

@implementation RecipeDetailTipsTableViewCell
@synthesize titleLabel,imageView,tipsLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    [self addSubview: [self titleLabel]];
    [self addSubview:[self tipsLabel]];

    self.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];

  }
  return self;
}


- (UILabel*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 150, 256, 10)];
    [titleLabel setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
    [titleLabel setFont: [UIFont boldSystemFontOfSize:18]];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"小贴士"];
  }

  return titleLabel;
}

- (TTTAttributedLabel*)tipsLabel
{
  if (!tipsLabel) {
    tipsLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(32, 150, 256, 0.0)];
    tipsLabel.numberOfLines = 0;
    tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipsLabel.font = [UIFont systemFontOfSize:15.0];
    tipsLabel.lineHeightMultiple = 1.4;
    [tipsLabel setTextColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]];
  }
  return tipsLabel;
}

- (void)CalculateCellHeight
{
  //离title高度
  mCellHeight = 10;

  //计算title高度
  CGSize titleLabelSize = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(256, 1000) lineBreakMode:NSLineBreakByWordWrapping];

  mTitleLabelTop = mCellHeight;
  mCellHeight += titleLabelSize.height;
  mTitleLabelHeight = titleLabelSize.height;

  mCellHeight += 20;

  //计算描述信息高度
  //CGSize introLabelSize = [introLabel.text sizeWithFont:introLabel.font constrainedToSize:CGSizeMake(256, 1000) lineBreakMode:NSLineBreakByWordWrapping];
  CGSize introLabelSize = [tipsLabel sizeThatFits:CGSizeMake(tipsLabel.frame.size.width, CGFLOAT_MAX)];
  tipsLabel.frame = CGRectMake(0.0, 0.0, tipsLabel.frame.size.width, introLabelSize.height);

  mIntroLabelTop = mCellHeight;
  mCellHeight += introLabelSize.height;
  mIntroLabelHeight = introLabelSize.height;

  mCellHeight += 20;
}

- (void)ReformCell
{
  CGRect titleRect = CGRectMake(32, mTitleLabelTop, 256, mTitleLabelHeight);
  [titleLabel setFrame: titleRect];

  CGRect introRect = CGRectMake(32, mIntroLabelTop, 256, mIntroLabelHeight);
  [tipsLabel setFrame: introRect];

  CGRect selfRect = CGRectMake(0, 0, 320, mCellHeight);
  [self setFrame:selfRect];
}

- (void)setData:(NSDictionary*) dictionary
{
  [tipsLabel setText:dictionary[@"tips"]];
}


@end
