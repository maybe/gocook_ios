//
//  RecipeDetailHeaderTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "RecipeDetailHeaderTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"

@implementation RecipeDetailHeaderTableViewCell
@synthesize titleLabel,imageView,buyButton,collectButton,introLabel,authorButton,authorLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setFrame:CGRectMake(0, 0, 320, 210)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [self addSubview:imageView];

    [self addSubview: [self titleLabel]];
    [self addSubview:[self introLabel]];

    authorButton = [[UIButton alloc]initWithFrame:CGRectMake(168, 0, 120, 25)];
    [authorButton setTitle:@"" forState:UIControlStateNormal];
    [authorButton addTarget:nil action:@selector(onClickAuthor:) forControlEvents:UIControlEventTouchUpInside];

    authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(168, 0, 120, 20)];
    [authorLabel setText:@""];
    [authorLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [authorLabel setTextAlignment:NSTextAlignmentRight];
    authorLabel.textColor = [UIColor colorWithRed:108.0f/255.0f green:146.0f/255.0f blue:75.0f/255.0f alpha:1];

    [self addSubview: [self collectButton]];
    [self addSubview: [self buyButton]];
    [self addSubview:authorLabel];
    [self addSubview:authorButton];

    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    backView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];
    self.backgroundView = backView;

  }
  return self;
}


- (UILabel*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 150, 256, CGFLOAT_MAX)];
    [titleLabel setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
    [titleLabel setFont: [UIFont boldSystemFontOfSize:22]];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@""];
  }
  return titleLabel;
}

- (TTTAttributedLabel*)introLabel
{
  if (!introLabel) {
    introLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(32, 150, 256, 0.0)];
    introLabel.numberOfLines = 0;
    introLabel.lineBreakMode = NSLineBreakByWordWrapping;
    introLabel.font = [UIFont systemFontOfSize:16.0];
    introLabel.lineHeightMultiple = 1.4;
    [introLabel setBackgroundColor:[UIColor clearColor]];
    [introLabel setTextColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]];
  }
  return introLabel;
}

- (UIButton*)buyButton
{
  if (!buyButton) {
    buyButton = [[UIButton alloc]initWithFrame:CGRectMake(180, 100, 120, 34)];
    [buyButton setTitle:@"+ 购买清单" forState:UIControlStateNormal];
    [buyButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/BuyButton.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [buyButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

    [buyButton addTarget:nil action:@selector(addToShoppingList) forControlEvents:UIControlEventTouchUpInside];
  }

  return buyButton;
}

- (UIButton*)collectButton
{
  if (!collectButton) {
    collectButton = [[UIButton alloc]initWithFrame:CGRectMake(90, 100, 120, 34)];
    [collectButton setTitle:@"未收藏" forState:UIControlStateNormal];
    [collectButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/CollectButton.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [collectButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];

    [collectButton addTarget:nil action:@selector(collectRecipe:) forControlEvents:UIControlEventTouchUpInside];
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

  mCellHeight += 12;

  //计算描述信息高度
  //CGSize introLabelSize = [introLabel.text sizeWithFont:introLabel.font constrainedToSize:CGSizeMake(256, 1000) lineBreakMode:NSLineBreakByWordWrapping];
  CGSize introLabelSize = [introLabel sizeThatFits:CGSizeMake(introLabel.frame.size.width, CGFLOAT_MAX)];
  introLabel.frame = CGRectMake(0.0, 0.0, introLabel.frame.size.width, introLabelSize.height);

  mIntroLabelTop = mCellHeight;
  mCellHeight += introLabelSize.height;
  mIntroLabelHeight = introLabelSize.height;

  mAuthorButtonTop = mCellHeight + 5;

  mCollButtonTop = mCellHeight + 50;

  mCellHeight += 120;
}

- (void)ReformCell
{
  CGRect titleRect = CGRectMake(32, mTitleLabelTop, 256, mTitleLabelHeight);
  [titleLabel setFrame: titleRect];

  CGRect introRect = CGRectMake(32, mIntroLabelTop, 256, mIntroLabelHeight);
  [introLabel setFrame: introRect];

  [authorButton setFrame:CGRectMake(168, mAuthorButtonTop, 120, 25)];
  [authorLabel setFrame:CGRectMake(168, mAuthorButtonTop, 120, 20)];

  [collectButton setFrame:CGRectMake(30, mCollButtonTop, 120, 34)];
  [buyButton setFrame:CGRectMake(168, mCollButtonTop, 120, 34)];

  CGRect selfRect = CGRectMake(0, 0, 320, mCellHeight);
  [self setFrame:selfRect];
}

- (void)setData:(NSDictionary*) dictionary
{
  [titleLabel setText:dictionary[@"recipe_name"]];
  [introLabel setText:dictionary[@"intro"]];
  if (dictionary)
  {
    if ([dictionary[@"collect"] intValue] == 0)
    {
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/CollectedButton.png"];
      UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
      [collectButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
      [collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
      [collectButton setAssociativeObject:@"已收藏" forKey:@"title"];
    }
    else{
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/CollectButton.png"];
      UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
      [collectButton setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
      [collectButton setTitle:@"未收藏" forState:UIControlStateNormal];
      [collectButton setAssociativeObject:@"未收藏" forKey:@"title"];
    }
  }

  [authorLabel setText: dictionary[@"author_name"]];
  [authorButton setAssociativeObject:dictionary[@"author_id"] forKey:@"author_id"];
  [authorButton setAssociativeObject:dictionary[@"author_name"] forKey:@"author_name"];

  NetManager* netManager = [NetManager sharedInstance];

  NSString* imageUrl = [NSString stringWithFormat: @"http://%@/%@", netManager.host, dictionary[@"cover_image"]];

  [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}


@end