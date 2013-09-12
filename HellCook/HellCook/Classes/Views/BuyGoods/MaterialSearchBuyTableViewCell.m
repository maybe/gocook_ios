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
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320-_offset, 16)];
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
    
    //goodsLabel
    goodsLabel = [[UILabel alloc] init];
    goodsLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    goodsLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    goodsLabel.backgroundColor = [UIColor clearColor];
    goodsLabel.font = [UIFont systemFontOfSize:16];
    [goodsLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [goodsLabel setHidden:YES];
    //specLabel
    specLabel = [[UILabel alloc] init];
    specLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    specLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    specLabel.backgroundColor = [UIColor clearColor];
    specLabel.font = [UIFont systemFontOfSize:16];
    [specLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [specLabel setHidden:YES];
    //amountLabel
    amountLabel = [[UILabel alloc] init];
    amountLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    amountLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.font = [UIFont systemFontOfSize:16];
    [amountLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [amountLabel setHidden:YES];
    //priceLabel
    priceLabel = [[UILabel alloc] init];
    priceLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    priceLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont systemFontOfSize:16];
    [priceLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [priceLabel setHidden:YES];
    //processLabel
    processLabel = [[UILabel alloc] init];
    processLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    processLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    processLabel.backgroundColor = [UIColor clearColor];
    processLabel.font = [UIFont systemFontOfSize:16];
    [processLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [processLabel setHidden:YES];
    

    [self addSubview:nameLabel];
    [self addSubview:stateLabel];
    [self addSubview:goBuyBtn];
    [self addSubview:sepImageView];
    [self addSubview:goodsLabel];
    [self addSubview:specLabel];
    [self addSubview:amountLabel];
    [self addSubview:priceLabel];
    [self addSubview:processLabel];
  }
  return self;
}

- (void)setData:(NSMutableDictionary*)dict withRow:(NSInteger)row
{
  keyword = [NSString stringWithString:dict[@"material"]];
  [goBuyBtn setAssociativeObject:keyword forKey:@"keyword"];
  goBuyBtn.tag = row;
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
    [goBuyBtn setHidden:YES];
    
    [specLabel setHidden:NO];
    [specLabel setFrame:CGRectMake(10, 41, 180, 16)];
    [specLabel setText:[NSString stringWithFormat:@"规格：%@",dict[@"norm"]]];
    [amountLabel setHidden:NO];
    [amountLabel setFrame:CGRectMake(10, 60, 180, 16)];
    NSString *strAmount = [NSString stringWithFormat:@"￥%.2f/%@ × %@%@",[dict[@"price"] floatValue],dict[@"unit"],dict[@"Quantity"],dict[@"unit"]];
    [amountLabel setText:strAmount];
    [priceLabel setHidden:NO];
    [priceLabel setFrame:CGRectMake(10, 79, 180, 16)];
    double price = [dict[@"price"] floatValue] * [dict[@"Quantity"] intValue];
    [priceLabel setText:[NSString stringWithFormat:@"=￥%.2f",price]];
    [processLabel setHidden:NO];
    [processLabel setFrame:CGRectMake(10, 98, 180, 16)];
    [processLabel setText:[NSString stringWithFormat:@"加工方式：%@",dict[@"Remark"]]];
    
    [sepImageView setFrame:CGRectMake(0, 133, 320-_offset, 1)];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
