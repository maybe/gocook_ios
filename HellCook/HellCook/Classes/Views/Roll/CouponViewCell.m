//
//  CouponViewCell.m
//  HellCook
//
//  Created by lxw on 13-11-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "CouponViewCell.h"

@implementation CouponViewCell
@synthesize backgroundView,rollLabel,bottomBtn;

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
    [backgroundView setImage:[UIImage imageNamed:@"Images/WhiteBlock.png"]];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:backgroundView];
    //rollLabel
    rollLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, 220, 30)];
    rollLabel.backgroundColor = [UIColor clearColor];
    rollLabel.font = [UIFont boldSystemFontOfSize:26];
    rollLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [rollLabel setText:@"摇一摇抽取优惠券"];
    [self addSubview:rollLabel];
    rollLabel.hidden = YES;
    //bottomButton
    bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 70, 20, 20)];
    [bottomBtn addTarget:nil action:@selector(GoDownDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomBtn];
    
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSMutableArray*)data withRow:(NSInteger)row withStatus:(NSInteger)status
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
  
  if (row == 0)
  {
    rollLabel.hidden = NO;
    bottomBtn.hidden = YES;
    [backgroundView setImage:[UIImage imageNamed:@"Images/WhiteBlock.png"]];
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  }
  else
  {
    rollLabel.hidden = YES;
    bottomBtn.hidden = NO;
    [self caculateCellHeight:data withRow:row withStatus:status];
    //统一设置背景
    if (row == 1){
      [backgroundView setImage:[UIImage imageNamed:@"Images/OrangeBlock.png"]];
    }
    else if (row == 2){
      [backgroundView setImage:[UIImage imageNamed:@"Images/GreenBlock.png"]];
    }
    else{
      [backgroundView setImage:[UIImage imageNamed:@"Images/GrayBlock.png"]];
    }
    [backgroundView setFrame:CGRectMake(10, 10, 300, height-10)];
    
    
    if (status == 0)//收起
    {
/*      UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 40, 35, 35)];
      [rightBtn addTarget:nil action:@selector(RightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:rightBtn];
      [rightBtnsArray addObject:rightBtn];*/
      NSString *content;
      if ([data count] > 0)
      {
        NSMutableDictionary *dict = [data objectAtIndex:0];
        if (row == 1)
        {
          content = [NSString stringWithFormat:@"%@（优惠券延期生效日期），您有一次延迟抽取优惠券的机会，有效期至%@",(NSString*)dict[@"eff_day"],(NSString*)dict[@"exp_day"]];
          
          UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/OrangeBottom.png"];
          [bottomBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
          UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GreyBottom.png"];
          [bottomBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
        }
        else
        {
          content = [NSString stringWithFormat:@"%@，您获得价值%.2f的%@，有效期至%@。券号%@适用门店%@ \n%@",(NSString*)dict[@"eff_day"],[dict[@"val"] floatValue],(NSString*)dict[@"name"],(NSString*)dict[@"exp_day"],(NSString*)dict[@"coupon_id"],(NSString*)dict[@"stores"],(NSString*)dict[@"coupon_remark"]];
          
          if (row == 2)
          {
            UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/GreenBottom.png"];
            [bottomBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
            UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GreyBottom.png"];
            [bottomBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
          }
          else
          {
            UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/GreyBottom.png"];
            [bottomBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
            UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/OrangeBottom.png"];
            [bottomBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
          }
        }
      }
      else
      {
        content = @"暂无数据";
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
    }
    else//展开
    {
      if ([data count] > 0)
      {
        
      }
      else
      {
        [bottomBtn setFrame:CGRectMake(150, 70, 20, 20)];
        
      }
      
    }
    
    
    
    
    
    
    
    
  }
}

-(CGFloat)getCellHeight
{
  return height;
}

-(CGFloat)caculateCellHeight:(NSMutableArray*)data withRow:(NSInteger)row withStatus:(NSInteger)status
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
        NSString *content;
        if (row == 1)
        {
          content = [NSString stringWithFormat:@"%@（优惠券延期生效日期），您有一次延迟抽取优惠券的机会，有效期至%@",(NSString*)dict[@"eff_day"],(NSString*)dict[@"exp_day"]];
        }
        else
        {
          content = [NSString stringWithFormat:@"%@，您获得价值%.2f的%@，有效期至%@。券号%@适用门店%@ \n%@",(NSString*)dict[@"eff_day"],[dict[@"val"] floatValue],(NSString*)dict[@"name"],(NSString*)dict[@"exp_day"],(NSString*)dict[@"coupon_id"],(NSString*)dict[@"stores"],(NSString*)dict[@"coupon_remark"]];
        }
        
        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(270, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        height = height + contentSize.height + 10;
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
