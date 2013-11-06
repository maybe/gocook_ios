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
    height = 90;
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
    //contentLabel
    contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, 270, 20)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont boldSystemFontOfSize:16];
    contentLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [self addSubview:contentLabel];
    contentLabel.hidden = YES;
    //rightButton
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 40, 35, 35)];
    [rightBtn addTarget:nil action:@selector(GoForRoll) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
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

- (void)setData:(NSMutableDictionary*)dict withRow:(NSInteger)row withStatus:(NSInteger)status
{
  switch (row) {
    case 0://白色
      rollLabel.hidden = NO;
      contentLabel.hidden = YES;
      [backgroundView setImage:[UIImage imageNamed:@"Images/WhiteBlock.png"]];
      [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      rightBtn.hidden = YES;
      break;
    case 1://红色
    {
      rollLabel.hidden = YES;
      contentLabel.hidden = NO;
      [contentLabel setText:@"orange"];
      [backgroundView setImage:[UIImage imageNamed:@"Images/OrangeBlock.png"]];
      [rightBtn setFrame:CGRectMake(270, 50, 35, 35)];
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/OrangeRight.png"];
      [rightBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
      UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/OrangeRightHighlighted.png"];
      [rightBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
      UIImage *buttonBackgroundImage2 = [UIImage imageNamed:@"Images/OrangeBottom.png"];
      [bottomBtn setBackgroundImage:buttonBackgroundImage2 forState:UIControlStateNormal];
      UIImage *btnBakimagePressed2 = [UIImage imageNamed:@"Images/GreyBottom.png"];
      [bottomBtn setBackgroundImage:btnBakimagePressed2 forState:UIControlStateHighlighted];
      break;
    }
    case 2://绿色
    {
      rollLabel.hidden = YES;
      contentLabel.hidden = NO;
      [contentLabel setText:@"green"];
      [backgroundView setImage:[UIImage imageNamed:@"Images/GreenBlock.png"]];
      [rightBtn setFrame:CGRectMake(270, 50, 35, 35)];
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/GreenRight.png"];
      [rightBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
      UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GreenRightHighlighted.png"];
      [rightBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
      UIImage *buttonBackgroundImage2 = [UIImage imageNamed:@"Images/GreenBottom.png"];
      [bottomBtn setBackgroundImage:buttonBackgroundImage2 forState:UIControlStateNormal];
      UIImage *btnBakimagePressed2 = [UIImage imageNamed:@"Images/GreyBottom.png"];
      [bottomBtn setBackgroundImage:btnBakimagePressed2 forState:UIControlStateHighlighted];
      break;
    }
    case 3://灰色
    {
      rollLabel.hidden = YES;
      contentLabel.hidden = NO;
      [contentLabel setText:@"gray"];
      [backgroundView setImage:[UIImage imageNamed:@"Images/GrayBlock.png"]];
      [rightBtn setFrame:CGRectMake(270, 50, 35, 35)];
      UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/GreyRight.png"];
      [rightBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
      UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/GreyRightHighlighted.png"];
      [rightBtn setBackgroundImage:btnBakimagePressed forState:UIControlStateHighlighted];
      UIImage *buttonBackgroundImage2 = [UIImage imageNamed:@"Images/GreyBottom.png"];
      [bottomBtn setBackgroundImage:buttonBackgroundImage2 forState:UIControlStateNormal];
      UIImage *btnBakimagePressed2 = [UIImage imageNamed:@"Images/OrangeBottom.png"];
      [bottomBtn setBackgroundImage:btnBakimagePressed2 forState:UIControlStateHighlighted];
      break;
    }
  }
}

-(NSInteger)getCellHeight
{
  return height;
}

@end
