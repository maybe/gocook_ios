//
//  MaterialSearchBuyTableViewCell.m
//  HellCook
//
//  Created by lxw on 13-9-2.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MaterialSearchBuyTableViewCell.h"
#import "Common.h"

@implementation MaterialSearchBuyTableViewCell
@synthesize nameLabel,stateLabel,goBuyBtn,sepImageView,goodsLabel,specLabel,amountLabel,priceLabel,processLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
  // Initialization code
    keyword = @"";
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320-_offset, 90)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //nameLabel
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 180, 16)];
    nameLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    nameLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    //stateLabel
    stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 31, 180, 16)];
    stateLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    stateLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    stateLabel.backgroundColor = [UIColor clearColor];
    stateLabel.font = [UIFont systemFontOfSize:16];
    [stateLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [stateLabel setText:@"尚未选购该商品"];
    //goBuyBtn
    goBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 57, 300-_offset, 20)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [goBuyBtn setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [btnBakimagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [goBuyBtn setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    [goBuyBtn setTitle:@"前往m6生鲜网络超市选购商品" forState:UIControlStateNormal];
    [goBuyBtn addTarget:nil action:@selector(GotoSearchGoods:) forControlEvents:UIControlEventTouchUpInside];
    //seperator image
    sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 88, 320-_offset, 1)];
    [sepImageView setImage:[UIImage imageNamed:@"Images/homeHeaderSeperator.png"]];
    
    [self initLabel:goodsLabel withFrame:CGRectMake(10, 31, 180, 16) withHidden:YES];
    [self initLabel:specLabel withFrame:CGRectMake(10, 31, 180, 16) withHidden:YES];
    [self initLabel:amountLabel withFrame:CGRectMake(10, 31, 180, 16) withHidden:YES];
    [self initLabel:priceLabel withFrame:CGRectMake(10, 31, 180, 16) withHidden:YES];
    [self initLabel:processLabel withFrame:CGRectMake(10, 31, 180, 16) withHidden:YES];
    

    [self addSubview:nameLabel];
    [self addSubview:stateLabel];
    [self addSubview:goBuyBtn];
    [self addSubview:sepImageView];
  }
  return self;
}

- (void)initLabel:(UILabel*)pLabel withFrame:(CGRect)rect withHidden:(BOOL)bHide
{
  pLabel = [[UILabel alloc]initWithFrame:rect];
  pLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  pLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  pLabel.backgroundColor = [UIColor clearColor];
  pLabel.font = [UIFont systemFontOfSize:16];
  [pLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [pLabel setHidden:bHide];
  [self addSubview:pLabel];
}

- (void)setData:(NSMutableDictionary*)dict
{
  keyword = [NSString stringWithString:dict[@"material"]];
  [goBuyBtn setAssociativeObject:keyword forKey:@"keyword"];
  NSString *foodContent = [NSString stringWithFormat:@"%@%@%@",@"目标食材：",dict[@"material"],dict[@"weight"]];
  [nameLabel setText:foodContent];
  
  if ([dict[@"state"] isEqual:@"NotBuy"])
  {
    CGRect cellRect = self.frame;
    cellRect.size.height = 90;
    [self setFrame:cellRect];
    
    [stateLabel setHidden:NO];
    [goBuyBtn setFrame:CGRectMake(10, 57, 300-_offset, 20)];
    [goodsLabel setHidden:YES];
    [specLabel setHidden:YES];
    [amountLabel setHidden:YES];
    [priceLabel setHidden:YES];
    [processLabel setHidden:YES];
    [sepImageView setFrame:CGRectMake(0, 88, 320-_offset, 1)];
  }
  else
  {
    CGRect cellRect = self.frame;
    cellRect.size.height = 135;
    [self setFrame:cellRect];
    
    [stateLabel setHidden:YES];
    [goodsLabel setHidden:YES];
    [goodsLabel setFrame:CGRectMake(10, 31, 180, 16)];
    [specLabel setHidden:YES];
    [specLabel setFrame:CGRectMake(10, 47, 180, 16)];
    [amountLabel setHidden:YES];
    [amountLabel setFrame:CGRectMake(10, 63, 180, 16)];
    [priceLabel setHidden:YES];
    [priceLabel setFrame:CGRectMake(10, 79, 180, 16)];
    [processLabel setHidden:YES];
    [processLabel setFrame:CGRectMake(10, 95, 180, 16)];
    [goBuyBtn setFrame:CGRectMake(10, 115, 300-_offset, 20)];
    [sepImageView setFrame:CGRectMake(0, 133, 320-_offset, 1)];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
