//
//  CouponViewCell.m
//  HellCook
//
//  Created by lxw on 13-11-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "CouponViewCell.h"

@implementation CouponViewCell
@synthesize backgroundView,rollLabel,contentLabel,rightBtn,bottomBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, 110)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //backgroundView
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 305, 100)];
    [backgroundView setImage:[UIImage imageNamed:@"Images/WhiteBlock.png"]];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:backgroundView];
    //rollLabel
    rollLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 100, 30)];
    rollLabel.backgroundColor = [UIColor clearColor];
    rollLabel.font = [UIFont boldSystemFontOfSize:30];
    rollLabel.textColor = [UIColor colorWithRed:107.0/255.0 green:174.0/255.0 blue:42.0/255.0 alpha:1];
    [rollLabel setText:@"摇一摇抽取优惠券"];
    [self addSubview:rollLabel];
    rollLabel.hidden = YES;
    //contentLabel
    contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 300, 30)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont boldSystemFontOfSize:14];
    contentLabel.textColor = [UIColor colorWithRed:107.0/255.0 green:174.0/255.0 blue:42.0/255.0 alpha:1];
    [self addSubview:contentLabel];
    contentLabel.hidden = YES;
    //rightButton
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, 50, 30, 30)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/GoToM6Buy.png"];
    [rightBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GoToM6BuyHighLight.png"];
    [rightBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
    [rightBtn addTarget:nil action:@selector(GoForRoll) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    //bottomButton
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, 50, 30, 30)];
    UIImage *buttonBackgroundImage2 = [UIImage imageNamed:@"Images/GoToM6Buy.png"];
    [rightBtn setBackgroundImage:buttonBackgroundImage2 forState:UIControlStateNormal];
    UIImage *btnBakimagePressed2 = [UIImage imageNamed:@"Images/GoToM6BuyHighLight.png"];
    [rightBtn setBackgroundImage:btnBakimagePressed2 forState:UIControlStateHighlighted];
    [rightBtn addTarget:nil action:@selector(GoDownDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSMutableDictionary*)dict withRow:(NSInteger)row withStatus:(NSInteger)status
{
  switch (row) {
    case 0://白色
      rollLabel.hidden = NO;
      contentLabel.hidden = YES;
      [backgroundView setImage:[UIImage imageNamed:@"Images/WhiteBlock.png"]];
      break;
    case 1://红色
      rollLabel.hidden = YES;
      contentLabel.hidden = NO;
      [contentLabel setText:@"orange"];
      [backgroundView setImage:[UIImage imageNamed:@"Images/OrangeBlock.png"]];
      break;
    case 2://绿色
      rollLabel.hidden = YES;
      contentLabel.hidden = NO;
      [contentLabel setText:@"green"];
      [backgroundView setImage:[UIImage imageNamed:@"Images/GreenBlock.png"]];
      break;
    case 3://灰色
      rollLabel.hidden = YES;
      contentLabel.hidden = NO;
      [contentLabel setText:@"gray"];
      [backgroundView setImage:[UIImage imageNamed:@"Images/GrayBlock.png"]];
      break;
  }
}

@end
