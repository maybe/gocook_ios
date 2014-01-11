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
@synthesize nameLabel,stateLabel,goBuyBtn,backgroundView,goodsLabel,specLabel,amountLabel,priceLabel,processLabel,closeButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
  // Initialization code
    keyword = @"";
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320-_offset, 130)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 280 - 20, 120)];
    [backgroundView setImage:[UIImage imageNamed:@"Images/WhiteBlock.png"]];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:backgroundView];

    //nameLabel
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 26, 320-_offset, 16)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textColor = [UIColor colorWithRed:107.0/255.0 green:174.0/255.0 blue:42.0/255.0 alpha:1];
    //stateLabel
    stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 52, 180, 16)];
    stateLabel.backgroundColor = [UIColor clearColor];
    stateLabel.font = [UIFont systemFontOfSize:16];
    [stateLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [stateLabel setText:@"尚未选购该商品"];
    //goBuyBtn
    goBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 80, 230, 30)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/GoToM6Buy.png"];
    [goBuyBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GoToM6BuyHighLight.png"];
    [goBuyBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
    [goBuyBtn addTarget:nil action:@selector(GotoSearchGoods:) forControlEvents:UIControlEventTouchUpInside];

//    //seperator image
//    sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 88, 320-_offset, 1)];
//    [sepImageView setImage:[UIImage imageNamed:@"Images/homeHeaderSeperator.png"]];
    
    //goodsLabel
    goodsLabel = [[UILabel alloc] init];
    goodsLabel.backgroundColor = [UIColor clearColor];
    goodsLabel.font = [UIFont systemFontOfSize:16];
    [goodsLabel setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
    [goodsLabel setHidden:YES];
    //specLabel
    specLabel = [[UILabel alloc] init];
    specLabel.backgroundColor = [UIColor clearColor];
    specLabel.font = [UIFont systemFontOfSize:16];
    [specLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0]];
    [specLabel setHidden:YES];
    //amountLabel
    amountLabel = [[UILabel alloc] init];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.font = [UIFont systemFontOfSize:16];
    [amountLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0]];
    [amountLabel setHidden:YES];
    //priceLabel
    priceLabel = [[UILabel alloc] init];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont systemFontOfSize:16];
    [priceLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0]];
    [priceLabel setHidden:YES];
    //processLabel
    processLabel = [[UILabel alloc] init];
    processLabel.backgroundColor = [UIColor clearColor];
    processLabel.font = [UIFont systemFontOfSize:16];
    [processLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0]];
    [processLabel setHidden:YES];

    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(238, 15, 27, 27)];
    UIImage *closeButtonBackgroundImage = [UIImage imageNamed:@"Images/CloseMaterialSearchBuyNormal.png"];
    [closeButton setBackgroundImage:closeButtonBackgroundImage forState:UIControlStateNormal];

    UIImage *closeButtonBackgroundImage2 = [UIImage imageNamed:@"Images/CloseMaterialSearchBuyHighLight.png"];
    [closeButton setBackgroundImage:closeButtonBackgroundImage2 forState:UIControlStateHighlighted];

    [closeButton addTarget:nil action:@selector(removeMaterial:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:nameLabel];
    [self addSubview:stateLabel];
    [self addSubview:goBuyBtn];
    // [self addSubview:sepImageView];
    [self addSubview:goodsLabel];
    [self addSubview:specLabel];
    [self addSubview:amountLabel];
    [self addSubview:priceLabel];
    [self addSubview:processLabel];

    [self addSubview:closeButton];
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
    cellRect.size.height = 130;
    [self setFrame:cellRect];
    
    [stateLabel setHidden:NO];
    [goBuyBtn setFrame:CGRectMake(25, 80, 230, 30)];
    goBuyBtn.hidden = NO;
    [goodsLabel setHidden:YES];
    [specLabel setHidden:YES];
    [amountLabel setHidden:YES];
    [priceLabel setHidden:YES];
    [processLabel setHidden:YES];

    [backgroundView setFrame: CGRectMake(10, 10, 280 - 20, 120)];
  }
  else
  {
    CGRect cellRect = self.frame;
    cellRect.size.height = 253;
    [self setFrame:cellRect];
    
    [stateLabel setHidden:YES];
    [goBuyBtn setHidden:NO];
    [goBuyBtn setFrame:CGRectMake(25, 205, 230, 30)];

    [goodsLabel setHidden:NO];
    [goodsLabel setFrame:CGRectMake(25, 52, 230, 16)];
    [goodsLabel setText:dict[@"name"]];
    [specLabel setHidden:NO];
    [specLabel setFrame:CGRectMake(25, 78, 230, 16)];
    [specLabel setText:[NSString stringWithFormat:@"规格：%@",dict[@"norm"]]];
    [amountLabel setHidden:NO];
    [amountLabel setFrame:CGRectMake(25, 104, 230, 16)];
    NSString *strAmount;
    double price = 0;
    if ([(NSString*)dict[@"unit"] isEqualToString:@"kg"])
    {
      strAmount = [NSString stringWithFormat:@"￥%.2f/500g × %@市斤(500g)",[dict[@"price"] floatValue]/2,dict[@"Quantity"]];
      price = [dict[@"price"] floatValue]/2 * [dict[@"Quantity"] floatValue];
    }
    else
    {
      strAmount = [NSString stringWithFormat:@"￥%.2f/%@ × %@%@",[dict[@"price"] floatValue],dict[@"unit"],dict[@"Quantity"],dict[@"unit"]];
      price = [dict[@"price"] floatValue] * [dict[@"Quantity"] floatValue];
    }
    
    [amountLabel setText:strAmount];
    [priceLabel setHidden:NO];
    [priceLabel setFrame:CGRectMake(25, 130, 230, 16)];
    [priceLabel setText:[NSString stringWithFormat:@"=￥%.2f",price]];
    [processLabel setHidden:NO];
    [processLabel setFrame:CGRectMake(25, 156, 230, 16)];
    [processLabel setText:[NSString stringWithFormat:@"加工方式：%@",dict[@"Remark"]]];
    
    [backgroundView setFrame:CGRectMake(10, 10, 280 - 20, 244)];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
