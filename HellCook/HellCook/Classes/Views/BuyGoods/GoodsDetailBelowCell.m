//
//  GoodsDetailBelowCell.m
//  HellCook
//
//  Created by lxw on 13-9-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "GoodsDetailBelowCell.h"

@implementation GoodsDetailBelowCell
@synthesize nameLabel,priceTitleLabel,priceLabel,unitLabel,specLabel,processTitleLabel,introTitleLabel,introLabel;
@synthesize buyBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    mCellHeight = 150;
    dealMethodLabelArray = [[NSMutableArray alloc] init];
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320-_offset, mCellHeight)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //nameLabel
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320-_offset, 20)];
    nameLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    nameLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    //buyBtn
    buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(190, 38, 60, 27)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [buyBtn setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"];
    UIImage *stretchedBackgroundPressed = [btnBakimagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [buyBtn setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
    [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    [buyBtn addTarget:nil action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    //priceTitleLabel
    priceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 50, 16)];
    priceTitleLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    priceTitleLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    priceTitleLabel.backgroundColor = [UIColor clearColor];
    priceTitleLabel.font = [UIFont systemFontOfSize:16];
    [priceTitleLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [priceTitleLabel setText:@"价格："];
    //priceLabel
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 42, 120, 20)];
    priceLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    priceLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont systemFontOfSize:20];
    [priceLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [priceLabel setTextColor:[UIColor redColor]];
    //unitLabel
    unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 80, 18)];
    unitLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    unitLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    unitLabel.backgroundColor = [UIColor clearColor];
    unitLabel.font = [UIFont systemFontOfSize:16];
    [unitLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    //specLabel
    specLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, 80, 18)];
    specLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    specLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    specLabel.backgroundColor = [UIColor clearColor];
    specLabel.font = [UIFont systemFontOfSize:16];
    [specLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    //processTitleLabel
    processTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 95, 70, 16)];
    processTitleLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    processTitleLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    processTitleLabel.backgroundColor = [UIColor clearColor];
    processTitleLabel.font = [UIFont systemFontOfSize:16];
    [processTitleLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [processTitleLabel setText:@"加工方式"];
    //introTitleLabel
    introTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 16)];
    introTitleLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    introTitleLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    introTitleLabel.backgroundColor = [UIColor clearColor];
    introTitleLabel.font = [UIFont systemFontOfSize:16];
    [introTitleLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [introTitleLabel setText:@"商品介绍："];
    //introLabel
    introLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 320-_offset-10, 16)];
    introLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    introLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    introLabel.backgroundColor = [UIColor clearColor];
    introLabel.font = [UIFont systemFontOfSize:16];
    [introLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    
    [self addSubview:nameLabel];
    [self addSubview:priceTitleLabel];
    [self addSubview:priceLabel];
    [self addSubview:unitLabel];
    [self addSubview:specLabel];
    [self addSubview:processTitleLabel];
    [self addSubview:introTitleLabel];
    [self addSubview:introLabel];
    [self addSubview:buyBtn];
  }
  return self;
}

-(void)setData:(NSMutableDictionary*)dict
{
  [nameLabel setText:dict[@"name"]];
  [priceLabel setText:[NSString stringWithFormat:@"%.2f元",[dict[@"price"] floatValue]]];
  [unitLabel setText:[NSString stringWithFormat:@"单位：%@",dict[@"unit"]]];
  [specLabel setText:[NSString stringWithFormat:@"规格：%@",dict[@"norm"]]];
  
  [self caculateHeight:dict];
}

-(void)caculateHeight:(NSMutableDictionary*)dict
{
  char startC = 'A';
  NSInteger labelPositionY = 95;
  NSArray *dealMethodArray = dict[@"deal_method"];
  if ([dealMethodArray count] > 0)
  {
    for (int i=0; i<[dealMethodArray count]; i++)
    {
      UILabel *dmLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, labelPositionY, 100, 16)];
      dmLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
      dmLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
      dmLabel.backgroundColor = [UIColor clearColor];
      dmLabel.font = [UIFont systemFontOfSize:16];
      [dmLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
      [dmLabel setText:[dealMethodArray objectAtIndex:i]];
      [dealMethodLabelArray addObject:dmLabel];
      [self addSubview:dmLabel];
      
      labelPositionY += 21;
      startC = startC + 1;
    }
  }
  UILabel *dmLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, labelPositionY, 100, 16)];
  dmLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  dmLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  dmLabel.backgroundColor = [UIColor clearColor];
  dmLabel.font = [UIFont systemFontOfSize:16];
  [dmLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [dmLabel setText:[NSString stringWithFormat:@"%c：用户指定",startC]];
  [dealMethodLabelArray addObject:dmLabel];
  [self addSubview:dmLabel];
  
  labelPositionY += 25;
  [introTitleLabel setFrame:CGRectMake(10, labelPositionY, 100, 16)];
  labelPositionY += 21;
  if (dict[@"remark"]!=[NSNull null] && ![dict[@"remark"] isEqual:@""])
  {
    introLabel.text = dict[@"remark"];
    CGSize contentSize = [introLabel.text sizeWithFont:introLabel.font constrainedToSize:CGSizeMake(introLabel.frame.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];    
    
    mCellHeight = labelPositionY + contentSize.height + 10;
    CGRect cellRect = self.frame;
    cellRect.size.height = mCellHeight;
    [self setFrame:cellRect];
    
    [introLabel setFrame:CGRectMake(introLabel.frame.origin.x, labelPositionY, introLabel.frame.size.width, contentSize.height)];
  }
  else
  {
    introLabel.text = @"暂无商品介绍";
    
    mCellHeight = labelPositionY + 16 + 10;
    CGRect cellRect = self.frame;
    cellRect.size.height = mCellHeight;
    [self setFrame:cellRect];
    
    [introLabel setFrame:CGRectMake(introLabel.frame.origin.x, labelPositionY, introLabel.frame.size.width, 16)];
  }
}

-(NSInteger)getCellHeight
{
  return mCellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
