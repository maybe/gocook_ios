//
//  ValidCouponCell.m
//  HellCook
//
//  Created by lxw on 13-11-9.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "ValidCouponCell.h"

@implementation ValidCouponCell
@synthesize backgroundView,bottomBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    height = OriginHeight;
    rightBtnsArray = [[NSMutableArray alloc] init];
    contentLabelsArray = [[NSMutableArray alloc] init];
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, height)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //backgroundView
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, height-10)];
    [backgroundView setImage:[UIImage imageNamed:@"Images/GreenBlock.png"]];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:backgroundView];
    //bottomButton
    bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, height-20, 20, 20)];
    [bottomBtn addTarget:nil action:@selector(ValidCouponShowDetail) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomBtn];
  }
    return self;
}

- (void)setData:(NSMutableArray*)data withStatus:(NSInteger)status
{
  for (int i=0; i<[rightBtnsArray count]; i++)
  {
    UIButton *btn = [rightBtnsArray objectAtIndex:i];
    btn.hidden = YES;
    [btn removeFromSuperview];
  }
  [rightBtnsArray removeAllObjects];
  for (int i=0; i<[contentLabelsArray count]; i++)
  {
    UILabel *label = [contentLabelsArray objectAtIndex:i];
    label.hidden = YES;
    [label removeFromSuperview];
  }
  [contentLabelsArray removeAllObjects];
  
  
  [self caculateCellHeight:data withStatus:status];
  [backgroundView setFrame:CGRectMake(10, 10, 300, height-10)];
  if (status == 0)//收起
  {
    NSString *content;
    if ([data count] > 0)
    {
      NSMutableDictionary *dict = [data objectAtIndex:0];
      NSString *strEffDay = [NSString stringWithString:(NSString*)dict[@"eff_day"]];
      NSRange range = [strEffDay rangeOfString:@" "];
      strEffDay = [strEffDay substringToIndex:range.location];
      NSString *strExpDay = [NSString stringWithString:(NSString*)dict[@"exp_day"]];
      range = [strExpDay rangeOfString:@" "];
      strExpDay = [strExpDay substringToIndex:range.location];
      
      content = [NSString stringWithFormat:@"%@，您获得价值%.2f的%@，有效期至%@。券号%@适用门店%@ \n%@",strEffDay,[dict[@"val"] floatValue],(NSString*)dict[@"name"],strExpDay,(NSString*)dict[@"coupon_id"],(NSString*)dict[@"stores"],(NSString*)dict[@"coupon_remark"]];
    }
    else
    {
      content = @"暂无有效的优惠券数据";
    }
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, 270, 40)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont boldSystemFontOfSize:16];
    contentLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    contentLabel.numberOfLines = 2;
    [contentLabel setText:content];
    [self addSubview:contentLabel];
    [contentLabelsArray addObject:contentLabel];
    
    [bottomBtn setFrame:CGRectMake(150, height-20, 20, 20)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/GreenBottom.png"];
    [bottomBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GreyBottom.png"];
    [bottomBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
  }
  else//展开
  {
    if ([data count] > 0)
    {
      CGFloat tempHeight = 20;
      for (int i=0; i<[data count]; i++)
      {
        NSMutableDictionary *dict = [data objectAtIndex:i];
        NSString *strEffDay = [NSString stringWithString:(NSString*)dict[@"eff_day"]];
        NSRange range = [strEffDay rangeOfString:@" "];
        strEffDay = [strEffDay substringToIndex:range.location];
        NSString *strExpDay = [NSString stringWithString:(NSString*)dict[@"exp_day"]];
        range = [strExpDay rangeOfString:@" "];
        strExpDay = [strExpDay substringToIndex:range.location];
        
        NSString *content = [NSString stringWithFormat:@"%@，您获得价值%.2f的%@，有效期至%@。券号%@适用门店%@ \n%@",strEffDay,[dict[@"val"] floatValue],(NSString*)dict[@"name"],strExpDay,(NSString*)dict[@"coupon_id"],(NSString*)dict[@"stores"],(NSString*)dict[@"coupon_remark"]];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont boldSystemFontOfSize:16];
        contentLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        CGSize contentSize = [content sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(270, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        [contentLabel setFrame:CGRectMake(25, tempHeight, 270, contentSize.height)];
        [contentLabel setText:content];
        [self addSubview:contentLabel];
        [contentLabelsArray addObject:contentLabel];
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, tempHeight+contentSize.height-20, 35, 35)];
        UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/GreenRight.png"];
        [rightBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GreenRightHighlighted.png"];
        [rightBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
        rightBtn.tag = i;
        [rightBtn addTarget:nil action:@selector(RightButtonOfValidCouponClicked:) forControlEvents:UIControlEventTouchUpInside];
        [contentLabel addSubview:rightBtn];
        [rightBtnsArray addObject:rightBtn];
        
        tempHeight = tempHeight + contentSize.height +15;
      }
      
    }
    
    [bottomBtn setFrame:CGRectMake(150, height-20, 20, 20)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/GreenBottomUp.png"];
    [bottomBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GreyBottomUp.png"];
    [bottomBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
  }
}


-(CGFloat)getCellHeight
{
  return height;
}
-(CGFloat)caculateCellHeight:(NSMutableArray*)data withStatus:(NSInteger)status
{
  if (status == 0)
  {
    height = OriginHeight;
  }
  else
  {
    if ([data count] > 0)
    {
      height = 10;
      for (int i=0; i<[data count]; i++)
      {
        NSMutableDictionary *dict = [data objectAtIndex:i];
        NSString *strEffDay = [NSString stringWithString:(NSString*)dict[@"eff_day"]];
        NSRange range = [strEffDay rangeOfString:@" "];
        strEffDay = [strEffDay substringToIndex:range.location];
        NSString *strExpDay = [NSString stringWithString:(NSString*)dict[@"exp_day"]];
        range = [strExpDay rangeOfString:@" "];
        strExpDay = [strExpDay substringToIndex:range.location];
        
        NSString *content = [NSString stringWithFormat:@"%@，您获得价值%.2f的%@，有效期至%@。券号%@适用门店%@ \n%@",strEffDay,[dict[@"val"] floatValue],(NSString*)dict[@"name"],strExpDay,(NSString*)dict[@"coupon_id"],(NSString*)dict[@"stores"],(NSString*)dict[@"coupon_remark"]];
                
        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(270, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        height = height + contentSize.height + 15;
      }
    }
    else
    {
      height = OriginHeight;
    }
  }
  
  return height;
}

@end
