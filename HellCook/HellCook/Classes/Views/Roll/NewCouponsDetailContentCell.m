//
//  NewCouponsDetailContentCell.m
//  HellCook
//
//  Created by lxw on 13-11-17.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "NewCouponsDetailContentCell.h"

@implementation NewCouponsDetailContentCell
@synthesize contentLabel,labelBackgroundView,bottomBtn;

- (id)initWithStyle:(UITableViewCellStyle)style withType:(NSInteger)type withData:(NSMutableDictionary*)dict reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    NSString *strEffDay = [NSString stringWithString:(NSString*)dict[@"eff_day"]];
    NSRange range = [strEffDay rangeOfString:@" "];
    strEffDay = [strEffDay substringToIndex:range.location];
    NSString *strExpDay = [NSString stringWithString:(NSString*)dict[@"exp_day"]];
    range = [strExpDay rangeOfString:@" "];
    strExpDay = [strExpDay substringToIndex:range.location];
    
    BOOL bHaveBottomBtn = FALSE;
    NSString *content;
    switch (type)
    {
      case 0:
      {
        labelBackgroundView = [[UIImageView alloc] init];
        [labelBackgroundView setImage:[UIImage imageNamed:@"Images/YellowBar.png"]];
        [labelBackgroundView setContentMode:UIViewContentModeScaleToFill];
        
        content = [NSString stringWithFormat:@"%@，您获得了一次延期抽取优惠券的机会，有效期至%@。请您在有效期内点击上方的“摇一摇抽取优惠券”按钮抽取优惠券！",strEffDay,strExpDay];
        break;
      }
      case 1:
      {
        bHaveBottomBtn = TRUE;
        labelBackgroundView = [[UIImageView alloc] init];
        [labelBackgroundView setImage:[UIImage imageNamed:@"Images/GreenBar.png"]];
        [labelBackgroundView setContentMode:UIViewContentModeScaleToFill];
        
        content = [NSString stringWithFormat:@"%@您获得了由提供商%@提供的价值%d的%@券号%d 有效期%@。\n适用门店：%@\n %@",strEffDay,(NSString*)dict[@"supplier"],[dict[@"val"] intValue],(NSString*)dict[@"name"],[dict[@"coupon_id"] intValue],strExpDay,(NSString*)dict[@"stores"],(NSString*)dict[@"coupon_remark"]];
        break;
      }
      case 2:
      {
        labelBackgroundView = [[UIImageView alloc] init];
        [labelBackgroundView setImage:[UIImage imageNamed:@"Images/GreyBar.png"]];
        [labelBackgroundView setContentMode:UIViewContentModeScaleToFill];
        
        if ([dict[@"is_delay"] intValue] == 1){//抽奖机会
          content = [NSString stringWithFormat:@"%@，您获得了一次延期抽取优惠券的机会，有效期至%@。请您在有效期内点击上方的“摇一摇抽取优惠券”按钮抽取优惠券！",strEffDay,strExpDay];
        }
        else{//优惠券
          bHaveBottomBtn = TRUE;
          content = [NSString stringWithFormat:@"%@您获得了由提供商%@提供的价值%d的%@券号%d 有效期%@。\n适用门店：%@\n %@",strEffDay,(NSString*)dict[@"supplier"],[dict[@"val"] intValue],(NSString*)dict[@"name"],[dict[@"coupon_id"] intValue],strExpDay,(NSString*)dict[@"stores"],(NSString*)dict[@"coupon_remark"]];
        }
        break;
      }
    }
    
    contentLabel = [[UILabel alloc] init];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont boldSystemFontOfSize:20];
    contentLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.numberOfLines = 0;
    CGSize contentSize = [content sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    height = contentSize.height + 70;
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, height)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [labelBackgroundView setFrame:CGRectMake(20, 0, 280, height)];
    [self addSubview:labelBackgroundView];
    
    [contentLabel setFrame:CGRectMake(40, 15, 250, contentSize.height)];
    [contentLabel setText:content];
    [self addSubview:contentLabel];
    
    if (bHaveBottomBtn) {
      bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, height-15, 40, 18)];
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/detail.png"];
      [bottomBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
      UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/detail.png"];
      [bottomBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
      NSString *url = [NSString stringWithString:(NSString*)dict[@"url"]];
      [bottomBtn setAssociativeObject:url forKey:@"url"];
      [bottomBtn addTarget:nil action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:bottomBtn];
    }
  }
  return self;
}

-(CGFloat)getCellHeight;
{
  return height;
}

@end
