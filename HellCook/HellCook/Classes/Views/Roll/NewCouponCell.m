//
//  NewCouponCell.m
//  HellCook
//
//  Created by lxw on 13-11-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "NewCouponCell.h"

@implementation NewCouponCell
@synthesize backgroundView,contentLabel,rightView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    height = 90;
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, height)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //backgroundView
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 320, height-10)];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:backgroundView];
    //contentLabel
    contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, 270, 40)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont boldSystemFontOfSize:16];
    contentLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    contentLabel.numberOfLines = 2;
    [self addSubview:contentLabel];
  }
  return self;
}

-(CGFloat)getCellHeight;
{
  return height;
}

- (void)setData:(NSMutableDictionary*)data withType:(NSInteger)type
{
  NSString *content;
  switch (type) {
    case 0:
    {
      [backgroundView setImage:[UIImage imageNamed:@"Images/YellowBar.png"]];
      
      NSString *strEffDay = [NSString stringWithString:(NSString*)data[@"eff_day"]];
      NSRange range = [strEffDay rangeOfString:@" "];
      strEffDay = [strEffDay substringToIndex:range.location];
      NSString *strExpDay = [NSString stringWithString:(NSString*)data[@"exp_day"]];
      range = [strExpDay rangeOfString:@" "];
      strExpDay = [strExpDay substringToIndex:range.location];
      content = [NSString stringWithFormat:@"延期抽取机会 %@获得 有效期至%@",strEffDay,strExpDay];
      break;
    }
    case 1:
    {
      [backgroundView setImage:[UIImage imageNamed:@"Images/GreenBar.png"]];
      
      NSString *strEffDay = [NSString stringWithString:(NSString*)data[@"eff_day"]];
      NSRange range = [strEffDay rangeOfString:@" "];
      strEffDay = [strEffDay substringToIndex:range.location];
      NSString *strExpDay = [NSString stringWithString:(NSString*)data[@"exp_day"]];
      range = [strExpDay rangeOfString:@" "];
      strExpDay = [strExpDay substringToIndex:range.location];
      content = [NSString stringWithFormat:@"%@ 价值%.2f %@获得 有效期至%@",(NSString*)data[@"name"],[data[@"val"] floatValue],strEffDay,strExpDay];
      break;
    }
    case 2:
    {
      [backgroundView setImage:[UIImage imageNamed:@"Images/GreyBar.png"]];
      
      NSString *strEffDay = [NSString stringWithString:(NSString*)data[@"eff_day"]];
      NSRange range = [strEffDay rangeOfString:@" "];
      strEffDay = [strEffDay substringToIndex:range.location];
      NSString *strExpDay = [NSString stringWithString:(NSString*)data[@"exp_day"]];
      range = [strExpDay rangeOfString:@" "];
      strExpDay = [strExpDay substringToIndex:range.location];
      content = [NSString stringWithFormat:@"%@ 价值%.2f %@获得 有效期至%@",(NSString*)data[@"name"],[data[@"val"] floatValue],strEffDay,strExpDay];
      break;
    }
  }
  [contentLabel setText:content];
}

@end
