//
//  SearchGoodsTableViewCell.m
//  HellCook
//
//  Created by lxw on 13-9-4.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "SearchGoodsTableViewCell.h"

@implementation SearchGoodsTableViewCell
@synthesize nameLabel,specLabel,unitLabel,priceLabel,sepImageView,rightImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
  // Initialization code
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320-_offset, 97)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //nameLabel
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 180, 14)];
    nameLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    nameLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    //specLabel
    [self initLabel:specLabel withFrame:CGRectMake(10, 29, 180, 16)];
    //unitLabel
    [self initLabel:unitLabel withFrame:CGRectMake(10, 50, 180, 16)];
    //priceLabel
    [self initLabel:priceLabel withFrame:CGRectMake(10, 71, 180, 16)];
    
    sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 85, 320-_offset, 1)];
    [sepImageView setImage:[UIImage imageNamed:@"Images/homeHeaderSeperator.png"]];
    
    [self addSubview:nameLabel];
    [self addSubview:sepImageView];
  }
  return self;
}

- (void)initLabel:(UILabel*)pLabel withFrame:(CGRect)rect
{
  pLabel = [[UILabel alloc]initWithFrame:rect];
  pLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  pLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  pLabel.backgroundColor = [UIColor clearColor];
  pLabel.font = [UIFont systemFontOfSize:16];
  [pLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];

  [self addSubview:pLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
