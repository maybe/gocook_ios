//
//  HistoryDealTableViewCell.m
//  HellCook
//
//  Created by lxw on 13-9-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "HistoryDealTableViewCell.h"

@implementation HistoryDealTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320-_offset, 85)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //timeLabel
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320-_offset, 16)];
    timeLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    timeLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:16];
    [timeLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    //orderLabel
    orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 34, 320-_offset, 16)];
    orderLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    orderLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    orderLabel.backgroundColor = [UIColor clearColor];
    orderLabel.font = [UIFont systemFontOfSize:16];
    [orderLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    //detailLabel
    detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 58, 320-_offset, 16)];
    detailLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    detailLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont systemFontOfSize:16];
    [detailLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    
    sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 83, 320-_offset, 1)];
    [sepImageView setImage:[UIImage imageNamed:@"Images/homeHeaderSeperator.png"]];
    
    [self addSubview:timeLabel];
    [self addSubview:orderLabel];
    [self addSubview:detailLabel];
    [self addSubview:sepImageView];
  }
  return self;
}

-(void)setData:(NSMutableDictionary*)dict
{
  [timeLabel setText:[NSString stringWithFormat:@"时间：%@",dict[@"create_time"]]];
  [orderLabel setText:[NSString stringWithFormat:@"订单号：%@",dict[@"code"]]];
  
  NSMutableArray *waresArray = [NSMutableArray arrayWithArray:dict[@"order_wares"]];
  NSMutableString *content = [[NSMutableString alloc] init];
  for (int i=0; i<[waresArray count];i++)
  {
    NSMutableDictionary *ordersDict = [NSMutableDictionary dictionaryWithDictionary:waresArray[i]];
    [content appendString:ordersDict[@"name"]];
    [content appendString:@" "];
  }
  [detailLabel setText:content];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
