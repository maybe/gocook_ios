//
//  ValidLotteryCell.m
//  HellCook
//
//  Created by lxw on 13-11-9.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "ValidLotteryCell.h"

@implementation ValidLotteryCell
@synthesize backgroundView,bottomBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    height = OriginHeight;
    rightBtnsArray = [[NSMutableArray alloc] init];
    contentLabelsArray = [[NSMutableArray alloc] init];
    seperatorsArray =[[NSMutableArray alloc] init];
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, height)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //backgroundView
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, height-10)];
    [backgroundView setImage:[UIImage imageNamed:@"Images/OrangeBlock.png"]];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:backgroundView];
    //bottomButton
    bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(145, height-30, 30, 30)];
    [bottomBtn addTarget:nil action:@selector(ValidLotteryShowDetail) forControlEvents:UIControlEventTouchUpInside];
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
  for (int i=0; i<[seperatorsArray count]; i++)
  {
    UIImageView *sep = [seperatorsArray objectAtIndex:i];
    sep.hidden = YES;
    [sep removeFromSuperview];
  }
  [seperatorsArray removeAllObjects];
  
  
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
      
      content = [NSString stringWithFormat:@"%@，您有一次延迟抽取优惠券的机会，有效期至%@",strEffDay,strExpDay];
    }
    else
    {
      content = @"暂无有效的抽奖机会数据";
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
    
    [bottomBtn setFrame:CGRectMake(145, height-30, 30, 30)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/OrangeBottom.png"];
    [bottomBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GreyBottom.png"];
    [bottomBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
    [self bringSubviewToFront:bottomBtn];
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
        
        NSString *content = [NSString stringWithFormat:@"%@，您有一次延迟抽取优惠券的机会，有效期至%@",strEffDay,strExpDay];
        
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
        UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/OrangeRight.png"];
        [rightBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/OrangeRightHighlighted.png"];
        [rightBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
        rightBtn.tag = i;
        [rightBtn addTarget:nil action:@selector(RightButtonOfValidLotteryClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        [rightBtnsArray addObject:rightBtn];
        
        tempHeight = tempHeight + contentSize.height +20;
        
        if (i != [data count]-1) {
          UIImageView *sepImageView = [[UIImageView alloc] init];;
          [sepImageView setImage:[UIImage imageNamed:@"Images/TableCellSeparater.png"]];
          [sepImageView setFrame:CGRectMake(10, tempHeight-2, 300, 1)];
          [self addSubview:sepImageView];
          [self bringSubviewToFront:sepImageView];
          [seperatorsArray addObject:sepImageView];
        }
      }
      
    }
    else
    {
      UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, 270, 40)];
      contentLabel.backgroundColor = [UIColor clearColor];
      contentLabel.font = [UIFont boldSystemFontOfSize:16];
      contentLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
      contentLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
      contentLabel.numberOfLines = 2;
      [contentLabel setText:@"暂无有效的抽奖机会数据"];
      [self addSubview:contentLabel];
      [contentLabelsArray addObject:contentLabel];
    }
    
    [bottomBtn setFrame:CGRectMake(145, height-30, 30, 30)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/OrangeBottomUp.png"];
    [bottomBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GreyBottomUp.png"];
    [bottomBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
    [self bringSubviewToFront:bottomBtn];
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
        
        NSString *content = [NSString stringWithFormat:@"%@，您有一次延迟抽取优惠券的机会，有效期至%@",strEffDay,strExpDay];
        
        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(270, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        height = height + contentSize.height + 20;
      }
      height += 20;
    }
    else
    {
      height = OriginHeight;
    }
  }
  [self setFrame:CGRectMake(0, 0, 320, height)];
  return height;
}

@end
