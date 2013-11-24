//
//  ProcessMethodCell.m
//  HellCook
//
//  Created by lxw on 13-11-24.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "ProcessMethodCell.h"

@implementation ProcessMethodCell
@synthesize contentLabel,sepImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withContent:(NSString*)content
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320-_offset, 70)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    //contentLabel
    contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 320-_offset, 30)];
    contentLabel.backgroundColor = [UIColor clearColor];
    [contentLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0]];
    contentLabel.font = [UIFont boldSystemFontOfSize:16];
    [contentLabel setText:content];
    [self addSubview:contentLabel];
    
    sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68, 320-_offset, 1)];
    [sepImageView setImage:[UIImage imageNamed:@"Images/homeHeaderSeperator.png"]];
    [self addSubview:sepImageView];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
