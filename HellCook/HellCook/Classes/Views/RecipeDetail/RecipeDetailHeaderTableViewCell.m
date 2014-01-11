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
@synthesize titleLabel,imageView,collectButton,introLabel,authorButton,authorLabel,likeButton,unlikeButton,likeLabel,collectImageButton;

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

    [self addSubview:[self likeButton]];
    [self addSubview:[self unlikeButton]];

    unlikeButton.hidden = YES;

    likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    [likeLabel setText:@""];
    [likeLabel setBackgroundColor:[UIColor clearColor]];
    [likeLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    likeLabel.textColor = [UIColor colorWithRed:108.0f/255.0f green:146.0f/255.0f blue:75.0f/255.0f alpha:1];
    [self addSubview:likeLabel];

    authorButton = [[UIButton alloc]initWithFrame:CGRectMake(168, 0, 120, 25)];
    [authorButton setTitle:@"" forState:UIControlStateNormal];
    [authorButton addTarget:nil action:@selector(onClickAuthor:) forControlEvents:UIControlEventTouchUpInside];

    authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(168, 0, 120, 20)];
    [authorLabel setText:@""];
    [authorLabel setBackgroundColor:[UIColor clearColor]];
    [authorLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [authorLabel setTextAlignment:NSTextAlignmentRight];
    authorLabel.textColor = [UIColor colorWithRed:108.0f/255.0f green:146.0f/255.0f blue:75.0f/255.0f alpha:1];
    
    shareButton = [[UIButton alloc]initWithFrame:CGRectMake(268, 164, 38, 30)];
    UIImage *shareButtonBg = [UIImage imageNamed:@"Images/recipe_share.png"];
    [shareButton setBackgroundImage:shareButtonBg forState:UIControlStateNormal];
    [shareButton addTarget:nil action:@selector(onClickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview: [self collectButton]];
    [self addSubview:[self collectImageButton]];
    [self addSubview:authorLabel];
    [self addSubview:authorButton];
    [self addSubview:shareButton];

    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    backView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];
    self.backgroundView = backView;

  }
  return self;
}


- (UILabel*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 130, 256, CGFLOAT_MAX)];
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

- (UIButton*)collectImageButton
{
  if (!collectImageButton) {
    collectImageButton = [[UIButton alloc]initWithFrame:CGRectMake(215, 100, 20, 20)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/CollectEmpty.png"];
    [collectImageButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [collectImageButton addTarget:nil action:@selector(collectRecipe:) forControlEvents:UIControlEventTouchUpInside];
  }

  return collectImageButton;
}

- (UIButton*)collectButton
{
  if (!collectButton) {
    collectButton = [[UIButton alloc]initWithFrame:CGRectMake(90, 100, 120, 34)];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [collectButton setTitleColor:[UIColor colorWithRed:108.0f/255.0f green:146.0f/255.0f blue:75.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [collectButton addTarget:nil action:@selector(collectRecipe:) forControlEvents:UIControlEventTouchUpInside];
  }

  return collectButton;
}

- (UIButton*)likeButton
{
  if (!likeButton) {
    likeButton = [[UIButton alloc]initWithFrame:CGRectMake(32, 155, 18, 18)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/unlike.png"];
    [likeButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [likeButton addTarget:nil action:@selector(likeRecipe:) forControlEvents:UIControlEventTouchUpInside];
  }

  return likeButton;
}

- (UIButton*)unlikeButton
{
  if (!unlikeButton) {
    unlikeButton = [[UIButton alloc]initWithFrame:CGRectMake(32, 155, 18, 18)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/like.png"];
    [unlikeButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [unlikeButton addTarget:nil action:@selector(unlikeRecipe:) forControlEvents:UIControlEventTouchUpInside];
  }

  return unlikeButton;
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

  mLikeButtonTop = mCellHeight + 8;
  mCellHeight += 40;

  //计算描述信息高度
  //CGSize introLabelSize = [introLabel.text sizeWithFont:introLabel.font constrainedToSize:CGSizeMake(256, 1000) lineBreakMode:NSLineBreakByWordWrapping];
  CGSize introLabelSize = [introLabel sizeThatFits:CGSizeMake(introLabel.frame.size.width, CGFLOAT_MAX)];
  introLabel.frame = CGRectMake(0.0, 0.0, introLabel.frame.size.width, introLabelSize.height);

  mIntroLabelTop = mCellHeight;
  mCellHeight += introLabelSize.height;
  mIntroLabelHeight = introLabelSize.height;

  mAuthorButtonTop = mCellHeight + 5;

  mCellHeight += 60;
}

- (void)ReformCell
{
  CGRect titleRect = CGRectMake(32, mTitleLabelTop, 256, mTitleLabelHeight);
  [titleLabel setFrame: titleRect];

  CGRect likeRect = CGRectMake(30, mLikeButtonTop - 12, 36, 36);
  [likeButton setFrame: likeRect];
  [unlikeButton setFrame: likeRect];

  CGRect likeLabelRect = CGRectMake(60, mLikeButtonTop, 120, 18);
  [likeLabel setFrame:likeLabelRect];

  CGRect collectImageRect = CGRectMake(215, mLikeButtonTop - 3, 19, 19);
  [collectImageButton setFrame:collectImageRect];

  CGSize collectButtonSize = [collectButton.titleLabel.text sizeWithFont:collectButton.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
  [collectButton setFrame:CGRectMake(237, mLikeButtonTop, collectButtonSize.width, collectButtonSize.height)];

  CGRect introRect = CGRectMake(32, mIntroLabelTop, 256, mIntroLabelHeight);
  [introLabel setFrame: introRect];

  [authorButton setFrame:CGRectMake(168, mAuthorButtonTop, 120, 25)];
  [authorLabel setFrame:CGRectMake(168, mAuthorButtonTop, 120, 20)];

  CGRect selfRect = CGRectMake(0, 0, 320, mCellHeight);
  [self setFrame:selfRect];
}

- (void)setData:(NSDictionary*) dictionary
{
  [titleLabel setText:dictionary[@"recipe_name"]];
  [likeLabel setText: [NSString stringWithFormat:@"%@人赞", dictionary[@"like_count"]]];
  if ([dictionary[@"like"] intValue] == 0) {
    likeButton.hidden = YES;
    unlikeButton.hidden = NO;
  } else {
    likeButton.hidden = NO;
    unlikeButton.hidden = YES;
  }

  [introLabel setText:dictionary[@"intro"]];
  if (dictionary)
  {
    if ([dictionary[@"collect"] intValue] == 0)
    {
      [collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
      [collectButton setAssociativeObject:@"已收藏" forKey:@"title"];
      [collectImageButton setBackgroundImage:[UIImage imageNamed:@"Images/CollectFull.png"] forState:UIControlStateNormal];
      [collectImageButton setAssociativeObject:@"已收藏" forKey:@"title"];
    }
    else{
      [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
      [collectButton setAssociativeObject:@"未收藏" forKey:@"title"];
      [collectImageButton setBackgroundImage:[UIImage imageNamed:@"Images/CollectEmpty.png"] forState:UIControlStateNormal];
      [collectImageButton setAssociativeObject:@"未收藏" forKey:@"title"];
    }
  }

  [authorLabel setText: dictionary[@"author_name"]];
  [authorButton setAssociativeObject:dictionary[@"author_id"] forKey:@"author_id"];
  [authorButton setAssociativeObject:dictionary[@"author_name"] forKey:@"author_name"];

  NetManager* netManager = [NetManager sharedInstance];

  NSString* imageUrl = [NSString stringWithFormat: @"http://%@/%@", netManager.host, dictionary[@"cover_image"]];

  [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Images/defaultUpload.png"]];
}


@end