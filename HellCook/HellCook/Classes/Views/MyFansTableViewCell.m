//
//  MyFansTableViewCell.m
//  HellCook
//
//  Created by lxw on 13-8-9.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyFansTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "QuartzCore/QuartzCore.h"
#import "NetManager.h"


@implementation MyFansTableViewCell
@synthesize avataImageView;
@synthesize nameLabel,sepImageView;

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
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 17, 180, 25)];
    nameLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    nameLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:25];
    //seperator image
    sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 89, 320, 1)];
    [sepImageView setImage:[UIImage imageNamed:@"Images/TableCellSeparater.png"]];
    
    [self addSubview:avataImageView];
    [self addSubview:nameLabel];
    [self addSubview:sepImageView];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSMutableDictionary*)dict
{
  if (dict[@"name"]!=[NSNull null] && ![dict[@"name"] isEqual:@""])
  {
    [nameLabel setText: dict[@"name"]];
  }
  else
  {
    [nameLabel setText:@""];
  }
  
  if (dict[@"portrait"]!=[NSNull null] && ![dict[@"portrait"] isEqual:@""])
  {
    NSString* avatarUrl = [NSString stringWithFormat: @"http://%@/%@", [[NetManager sharedInstance] host], dict[@"portrait"]];
    [avataImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
  }
  else
  {
    [avataImageView setImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
  }
}

@end
