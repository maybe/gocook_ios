//
//  BuyGoodsBelowCell.m
//  HellCook
//
//  Created by lxw on 13-9-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "BuyGoodsBelowCell.h"

@implementation BuyGoodsBelowCell
@synthesize nameLabel,priceTitleLabel,priceLabel,unitLabel,specLabel,processTitleLabel,introTitleLabel,introLabel;
@synthesize buyBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    mCellHeight = 150;
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320-_offset, mCellHeight)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //nameLabel
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 180, 20)];
    nameLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    nameLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    //priceTitleLabel
    [self initLabel:priceTitleLabel withFrame:CGRectMake(10, 45, 50, 16)];
    [priceTitleLabel setText:@"价格"];
    //priceLabel
    [self initLabel:priceLabel withFrame:CGRectMake(70, 35, 80, 26)];
    [priceLabel setTextColor:[UIColor redColor]];
    //unitLabel
    [self initLabel:unitLabel withFrame:CGRectMake(10, 70, 80, 16)];
    //specLabel
    [self initLabel:specLabel withFrame:CGRectMake(100, 70, 80, 16)];
    //processTitleLabel
    [self initLabel:processTitleLabel withFrame:CGRectMake(10, 95, 50, 16)];
    //introTitleLabel
    [self initLabel:introTitleLabel withFrame:CGRectMake(10, 120, 50, 16)];
    //introLabel
    [self initLabel:introLabel withFrame:CGRectMake(10, 140, 50, 16)];
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
