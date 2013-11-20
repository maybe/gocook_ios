//
//  BlankCell.m
//  HellCook
//
//  Created by lxw on 13-11-20.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "BlankCell.h"

@implementation BlankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, 34)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
