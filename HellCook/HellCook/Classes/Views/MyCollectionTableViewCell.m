//
//  MyCollectionTableViewCell.m
//  HellCook
//
//  Created by lxw on 13-7-28.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyCollectionTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"

@implementation MyCollectionTableViewCell
@synthesize titleLabel, materialLabel, imageView, maskImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, _sideWindowWidth, 90)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 95, 70)];
      [imageView setContentMode:UIViewContentModeScaleAspectFill];
      [imageView setClipsToBounds:YES];
      [self addSubview:imageView];
      
      [self addSubview: [self titleLabel]];
      [self addSubview:[self materialLabel]];
      
//      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/topmask.png"];
//      UIImage *stretchedBackgroundImage = [buttonBackgroundImage stretchableImageWithLeftCapWidth:6 topCapHeight:6.5];
//      maskImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 95, 70)];
//      [maskImageView setImage:stretchedBackgroundImage];
//      [self addSubview:maskImageView];
      
      UIImage* dotImage = [UIImage imageNamed:@"Images/homeHeaderSeperator.png"];
      UIImageView* dotImageView = [[UIImageView alloc]initWithImage:dotImage];
      [dotImageView setFrame:CGRectMake(0, 89, _sideWindowWidth, 1)];
      
      [self addSubview:dotImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(124, 24, 148, 20)];
    [titleLabel setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
    [titleLabel setFont: [UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@""];
  }
  return titleLabel;
}

- (UILabel*)materialLabel
{
  if (!materialLabel) {
    materialLabel = [[UILabel alloc]initWithFrame:CGRectMake(124, 50, 148, 20)];
    [materialLabel setTextColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]];
    
    [materialLabel setFont: [UIFont systemFontOfSize:14]];
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
  
  [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}

@end
