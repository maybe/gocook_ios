//
//  MainCatTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MainCatTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"


@implementation MainCatTableViewCell
@synthesize titleLabel, imageContainer, backImageView;;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 64)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/roundBackground.png"];
      UIImage *stretchedBackgroundImage = [buttonBackgroundImage stretchableImageWithLeftCapWidth:6 topCapHeight:6.5];
      backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 300, 54)];
      [backImageView setImage:stretchedBackgroundImage];
      [self addSubview:backImageView];
      
      [self addSubview: [self titleLabel]];
      [self addSubview: [self imageContainer]];
    }
    return self;
}


- (UIView*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 22, 70, 20)];
    [titleLabel setTextColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]];
    [titleLabel setFont: [UIFont systemFontOfSize:14]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@""];
  }
  return titleLabel;
}

- (UIView*)imageContainer
{
  if (!imageContainer) {
    imageContainer = [[UIView alloc]initWithFrame:CGRectMake(113, 9, 372, 45)];
    for (int i = 0; i < 4; i++) {
      UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*49, 0, 45, 45)];
      //[imageView setImage: [UIImage imageNamed:@"Images/tmpcat.png"]];
      [imageView setContentMode:UIViewContentModeScaleAspectFill];
      [imageView setClipsToBounds:YES];
      [imageContainer addSubview:imageView];
    }
    for (int i = 0; i < 4; i++) {
      UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*49, 0, 45, 45)];
      [imageView setImage: [UIImage imageNamed:@"Images/roundMask.png"]];
      [imageContainer addSubview:imageView];
    }
    
  }
  return imageContainer;
}

- (void)setData:(NSMutableDictionary*) dictionary
{
  [titleLabel setText:dictionary[@"name"]];
  
  for (int i = 0; i < 4; i++) {
    UIImageView* imageView = [[imageContainer subviews] objectAtIndex:i];
    //[imageView setImage: [UIImage imageNamed:@"Images/tmpcat.png"]];
    int imageLen = [dictionary[@"images"] count];
    if (i<imageLen) {
      NetManager* netManager = [NetManager sharedInstance];
      
      NSString* imageUrl = [NSString stringWithFormat: @"http://%@/%@", netManager.host, [dictionary[@"images"] objectAtIndex:i]];
      
      [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    }
    else{
      [imageView setImage:nil];
    }
  }
}


@end
