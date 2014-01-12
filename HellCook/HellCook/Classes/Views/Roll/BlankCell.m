//
//  BlankCell.m
//  HellCook
//
//  Created by lxw on 13-11-20.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "BlankCell.h"

@implementation BlankCell
@synthesize backgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self setBackgroundColor: [UIColor whiteColor]];
    [self setFrame:CGRectMake(0, 0, 320, 34)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //backgroundView
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    [backgroundView setImage:[UIImage imageNamed:@"Images/WhiteBlock.png"]];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:backgroundView];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
