//
//  NewCouponsDetailContentCell.m
//  HellCook
//
//  Created by lxw on 13-11-17.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "NewCouponsDetailContentCell.h"
#import "UIImageView+WebCache.h"

@implementation NewCouponsDetailContentCell
@synthesize contentLabel,labelBackgroundView,bottomBtn,contentImage,contentLabel2;

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
    BOOL bHaveContentImage = FALSE;
    NSString *content;
    switch (type)
    {
      case 2://延期
      {
        labelBackgroundView = [[UIImageView alloc] init];
        [labelBackgroundView setImage:[UIImage imageNamed:@"Images/redBar.png"]];
        [labelBackgroundView setContentMode:UIViewContentModeScaleToFill];
        
        content = [NSString stringWithFormat:@"%@，您获得了一次延期抽取优惠券的机会，有效期至%@。请您在有效期内点击上方的“摇一摇抽取优惠券”按钮抽取优惠券！",strEffDay,strExpDay];
        break;
      }
      case 0://M6券
      {
        bHaveBottomBtn = TRUE;
        bHaveContentImage = TRUE;
        labelBackgroundView = [[UIImageView alloc] init];
        [labelBackgroundView setImage:[UIImage imageNamed:@"Images/GreenBar.png"]];
        [labelBackgroundView setContentMode:UIViewContentModeScaleToFill];
        
        content = [NSString stringWithFormat:@"%@您获得了由提供商%@提供的价值%d元的%@券号%@\n有效期%@至%@。\n适用门店：%@\n",strEffDay,(NSString*)dict[@"supplier"],[dict[@"val"] intValue],(NSString*)dict[@"name"],(NSString*)dict[@"coupon"],strEffDay,strExpDay,(NSString*)dict[@"stores"]];
        break;
      }
      case -1://已使用
      {
        bHaveBottomBtn = TRUE;
        bHaveContentImage = TRUE;
        labelBackgroundView = [[UIImageView alloc] init];
        [labelBackgroundView setImage:[UIImage imageNamed:@"Images/GreyBar.png"]];
        [labelBackgroundView setContentMode:UIViewContentModeScaleToFill];
        
        content = [NSString stringWithFormat:@"%@您获得了由提供商%@提供的价值%d元的%@券号%@\n有效期%@至%@。\n适用门店：%@\n",strEffDay,(NSString*)dict[@"supplier"],[dict[@"val"] intValue],(NSString*)dict[@"name"],(NSString*)dict[@"coupon"],strEffDay,strExpDay,(NSString*)dict[@"stores"]];
        break;
      }
      case 1://广告
      {
        bHaveBottomBtn = TRUE;
        bHaveContentImage = TRUE;
        labelBackgroundView = [[UIImageView alloc] init];
        [labelBackgroundView setImage:[UIImage imageNamed:@"Images/blueBar.png"]];
        [labelBackgroundView setContentMode:UIViewContentModeScaleToFill];
        
        NSString *strCreateTime = [NSString stringWithString:(NSString*)dict[@"ctime"]];
        range = [strCreateTime rangeOfString:@" "];
        strCreateTime = [strCreateTime substringToIndex:range.location];
        
        content = [NSString stringWithFormat:@"券名称：%@\n供应商：%@\n创建时间：%@",(NSString*)dict[@"name"],(NSString*)dict[@"supplier"],strCreateTime];
        break;
      }
      case 3://网络商家券
      {
        bHaveBottomBtn = TRUE;
        bHaveContentImage = TRUE;
        labelBackgroundView = [[UIImageView alloc] init];
        [labelBackgroundView setImage:[UIImage imageNamed:@"Images/YellowBar.png"]];
        [labelBackgroundView setContentMode:UIViewContentModeScaleToFill];
        
        content = [NSString stringWithFormat:@"%@您获得了由提供商%@提供的价值%d元的%@券号%@\n有效期%@至%@。\n适用门店：%@\n",strEffDay,(NSString*)dict[@"supplier"],[dict[@"val"] intValue],(NSString*)dict[@"name"],(NSString*)dict[@"coupon"],strEffDay,strExpDay,(NSString*)dict[@"stores"]];
        break;
      }
    }
    //第一段描述
    contentLabel = [[UILabel alloc] init];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.numberOfLines = 0;
    CGSize contentSize = [content sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    //图片（如果有的话）
    if (bHaveContentImage)
    {
      contentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
      [contentImage setContentMode:UIViewContentModeScaleAspectFill];
      contentImage.layer.masksToBounds = YES;
      contentImage.layer.borderColor = [UIColor clearColor].CGColor;
      contentImage.layer.borderWidth = 1.0;
      [contentImage setClipsToBounds:YES];
      NSString *strURL = [NSString stringWithString:(NSString*)dict[@"img"]];
      [contentImage setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"Images/M6DefaultImage.png"]];
      
      contentImage.userInteractionEnabled = YES;
      UITapGestureRecognizer *tapGestureAva = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentImage:)];
      [contentImage addGestureRecognizer:tapGestureAva];
      strUrl = [NSString stringWithString:(NSString*)dict[@"url"]];
    }
    //第二段描述
    NSString *content2 = [NSString stringWithString:(NSString*)dict[@"coupon_remark"]];
    contentLabel2 = [[UILabel alloc] init];
    contentLabel2.backgroundColor = [UIColor clearColor];
    contentLabel2.font = [UIFont systemFontOfSize:17];
    contentLabel2.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    contentLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel2.numberOfLines = 0;
    CGSize contentSize2 = [content2 sizeWithFont:contentLabel2.font constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    if (bHaveContentImage)
    {
      height = 15 + contentSize.height + 8 + contentImage.frame.size.height + 8 + contentSize2.height + 40;
    }
    else
    {
      height = 15 + contentSize.height + 8 + contentSize2.height + 40;
    }
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, height)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [labelBackgroundView setFrame:CGRectMake(20, 0, 280, height)];
    [self addSubview:labelBackgroundView];
    
    [contentLabel setFrame:CGRectMake(40, 15, 250, contentSize.height)];
    [contentLabel setText:content];
    [self addSubview:contentLabel];
    
    if (bHaveContentImage)
    {
      [contentImage setFrame:CGRectMake(40, 15 + contentSize.height + 8, 240, contentImage.frame.size.height)];
      [contentLabel2 setFrame:CGRectMake(40, 15 + contentSize.height + 8 + contentImage.frame.size.height + 8, 250, contentSize2.height)];
      [contentLabel2 setText:content2];
      [self addSubview:contentImage];
      [self addSubview:contentLabel2];
    }
    else
    {
      [contentLabel2 setFrame:CGRectMake(40, 15 + contentSize.height + 8, 250, contentSize2.height)];
      [contentLabel2 setText:content2];
      [self addSubview:contentLabel2];
    }
    
    if (bHaveBottomBtn) {
      bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, height-25, 40, 13)];
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

- (IBAction)tapContentImage:(id)sender {  
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
}


-(CGFloat)getCellHeight;
{
  return height;
}

@end
