//
//  MainCatTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "TopListTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"


@implementation TopListTableViewCell
@synthesize titleLabel, materialLabel, imageView, maskImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 208)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 192)];
      [imageView setContentMode:UIViewContentModeScaleAspectFill];
      [imageView setClipsToBounds:YES];
      [self addSubview:imageView];
      
      [self addSubview: [self titleLabel]];
      [self addSubview:[self materialLabel]];
      
      //UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/topmask.png"];
      //UIImage *stretchedBackgroundImage = [buttonBackgroundImage stretchableImageWithLeftCapWidth:6 topCapHeight:6.5];
      //maskImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
      //[maskImageView setImage:stretchedBackgroundImage];
      //[self addSubview:maskImageView];
      
    }
    return self;
}


- (UILabel*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 150, 290, 20)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont: [UIFont boldSystemFontOfSize:20]];
    titleLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    titleLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@""];
  }
  return titleLabel;
}

- (UILabel*)materialLabel
{
  if (!materialLabel) {
    materialLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 180, 240, 20)];
    [materialLabel setTextColor:[UIColor whiteColor]];
    [materialLabel setFont: [UIFont systemFontOfSize:14]];
    materialLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    materialLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    [materialLabel setBackgroundColor:[UIColor clearColor]];
    [materialLabel setText:@""];
  }
  return materialLabel;
}

- (void)setData:(NSMutableDictionary*) dictionary
{
  [titleLabel setText:dictionary[@"name"]];
  
  NSArray* materialArray = [dictionary[@"materials"] componentsSeparatedByString:@"|"];

  NSString* materialStr = @"";
  for (int i = 0; i < materialArray.count; i = i + 2) {
    materialStr = [materialStr stringByAppendingFormat:@"%@ " ,[materialArray objectAtIndex:i]];
  }
  
  [materialLabel setText: materialStr];
  
  NetManager* netManager = [NetManager sharedInstance];
      
  NSString* imageUrl = [NSString stringWithFormat: @"http://%@/%@", netManager.host, dictionary[@"image"]];

  [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage: [UIImage imageNamed:@"Images/TopListPlaceHolder.png"]];
}


@end
