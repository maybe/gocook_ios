//
//  MyFollowTableViewCell.m
//  HellCook
//
//  Created by lxw on 13-8-7.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyFollowTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "QuartzCore/QuartzCore.h"

@implementation MyFollowTableViewCell
@synthesize avataImageView;
@synthesize nameLabel,fanLabel,recipeLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, 90)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //avatarImageView
    avataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 60)];
    [avataImageView setContentMode:UIViewContentModeScaleAspectFill];
    [avataImageView setClipsToBounds:YES];
    avataImageView.layer.cornerRadius = 4.0;
    avataImageView.layer.masksToBounds = YES;
    avataImageView.layer.borderColor = [UIColor clearColor].CGColor;
    avataImageView.layer.borderWidth = 1.0;
    //nameLabel
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 20, 180, 15)];
    nameLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    nameLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    nameLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    //fanLabel
    fanLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 40, 180, 10)];
    fanLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    fanLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    fanLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    fanLabel.backgroundColor = [UIColor clearColor];
    [fanLabel.font fontWithSize:10];
    
    
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
