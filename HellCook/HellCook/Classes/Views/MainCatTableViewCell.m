//
//  MainCatTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MainCatTableViewCell.h"
#import "QuartzCore/QuartzCore.h"


@implementation MainCatTableViewCell
@synthesize titleLabel, imageContainer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 116)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      [self addSubview: [self titleLabel]];
      [self addSubview: [self imageContainer]];
    }
    return self;
}


- (UIView*)titleLabel
{
  if (!titleLabel) {
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 13, 145, 90)];
  }
  return titleLabel;
}

- (UIView*)imageContainer
{
  if (!imageContainer) {
  }
  return imageContainer;
}

@end
