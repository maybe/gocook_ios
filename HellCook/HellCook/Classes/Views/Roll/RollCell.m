//
//  RollCell.m
//  HellCook
//
//  Created by lxw on 13-11-9.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "RollCell.h"

@implementation RollCell
@synthesize backgroundView,rollLabel;

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
    
  }
  return self;
}

-(CGFloat)getCellHeight
{
  return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
