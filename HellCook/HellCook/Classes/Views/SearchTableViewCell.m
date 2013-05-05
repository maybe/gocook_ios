//
//  SearchTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"


@implementation SearchTableViewCell
@synthesize titleLabel, materialLabel, imageView, maskImageView;;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 90)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 95, 70)];
      [self addSubview:imageView];
      
      [self addSubview: [self titleLabel]];
      [self addSubview:[self materialLabel]];
      
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/topmask.png"];
      UIImage *stretchedBackgroundImage = [buttonBackgroundImage stretchableImageWithLeftCapWidth:6 topCapHeight:6.5];
      maskImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 95, 70)];
      [maskImageView setImage:stretchedBackgroundImage];
      [self addSubview:maskImageView];
      
      UIImage* dotImage = [UIImage imageNamed:@"Images/homeHeaderSeperator.png"];
      UIImageView* dotImageView = [[UIImageView alloc]initWithImage:dotImage];
      [dotImageView setFrame:CGRectMake(0, 89, 320, 1)];
      
      [self addSubview:dotImageView];
    }
    return self;
}


- (UILabel*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(124, 17, 150, 20)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont: [UIFont systemFontOfSize:14]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@""];
  }
  return titleLabel;
}

- (UILabel*)materialLabel
{
  if (!materialLabel) {
    materialLabel = [[UILabel alloc]initWithFrame:CGRectMake(124, 40, 150, 20)];
    [materialLabel setTextColor:[UIColor whiteColor]];
    [materialLabel setFont: [UIFont systemFontOfSize:12]];
    [materialLabel setBackgroundColor:[UIColor clearColor]];
    [materialLabel setText:@""];
  }
  return materialLabel;
}

- (void)setData:(NSMutableDictionary*) dictionary
{
  [titleLabel setText:dictionary[@"name"]];
  
  [materialLabel setText:dictionary[@"materials"]];
  
  NetManager* netManager = [NetManager sharedInstance];
      
  NSString* imageUrl = [NSString stringWithFormat: @"http://%@/%@", netManager.host, dictionary[@"image"]];
        
  [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}


@end
