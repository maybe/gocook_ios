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
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320-_offset, 14)];
    nameLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    nameLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    //specLabel
    specLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 29, 180, 18)];
    specLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    specLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    specLabel.backgroundColor = [UIColor clearColor];
    specLabel.font = [UIFont systemFontOfSize:16];
    [specLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    //unitLabel
    unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 180, 18)];
    unitLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    unitLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    unitLabel.backgroundColor = [UIColor clearColor];
    unitLabel.font = [UIFont systemFontOfSize:16];
    [unitLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    //priceLabel
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 71, 180, 16)];
    priceLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    priceLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont systemFontOfSize:16];
    [priceLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    
    sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 95, 320-_offset, 1)];
    [sepImageView setImage:[UIImage imageNamed:@"Images/homeHeaderSeperator.png"]];
    
    [self addSubview:nameLabel];
    [self addSubview:specLabel];
    [self addSubview:unitLabel];
    [self addSubview:priceLabel];
    [self addSubview:sepImageView];
  }
  return self;
}

- (void)setData:(NSMutableDictionary *)dict
{
  [nameLabel setText:dict[@"name"]];
  [specLabel setText:[NSString stringWithFormat:@"规格：%@",dict[@"norm"]]];
  [unitLabel setText:[NSString stringWithFormat:@"单位：%@",dict[@"unit"]]];
  [priceLabel setText:[NSString stringWithFormat:@"价格：¥%.2f",[dict[@"price"] floatValue]]];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
