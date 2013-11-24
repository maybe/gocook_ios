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
#import "NetManager.h"

@implementation MyFollowTableViewCell
@synthesize avataImageView;
@synthesize nameLabel,fansLabel,recipeLabel,sepImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, 76)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //avatarImageView
    avataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 56, 56)];
    [avataImageView setContentMode:UIViewContentModeScaleAspectFill];
    [avataImageView setClipsToBounds:YES];
    avataImageView.layer.masksToBounds = YES;
    avataImageView.layer.borderColor = [UIColor clearColor].CGColor;
    avataImageView.layer.borderWidth = 1.0;

    //nameLabel
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 180, 18)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:17];
    [nameLabel setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];

    fansLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 34, 30, 15)];
    fansLabel.backgroundColor = [UIColor clearColor];
    fansLabel.font = [UIFont systemFontOfSize:15];
    [fansLabel setTextColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [fansLabel setTextAlignment:NSTextAlignmentCenter];

    recipeLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 55, 30, 15)];
    recipeLabel.backgroundColor = [UIColor clearColor];
    recipeLabel.font = [UIFont systemFontOfSize:15];
    [recipeLabel setTextColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [recipeLabel setTextAlignment:NSTextAlignmentCenter];

    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(122, 34, 48, 15)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:15];
    [label1 setTextColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [label1 setText:@"粉丝"];

    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(122, 55, 48, 15)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:15];
    [label2 setTextColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [label2 setText:@"菜谱"];

    //separator image
    sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 75, 320, 1)];
    [sepImageView setImage:[UIImage imageNamed:@"Images/TableCellSeparater.png"]];

    [self addSubview:avataImageView];
    [self addSubview:nameLabel];
    [self addSubview:recipeLabel];
    [self addSubview:fansLabel];
    [self addSubview:label1];
    [self addSubview:label2];
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

  if (dict[@"recipe_count"]!=[NSNull null] && ![dict[@"recipe_count"] isEqual:@""])
  {
    NSString *temString = [NSString stringWithFormat:@"%d", [dict[@"recipe_count"] intValue]];
    [recipeLabel setText: temString];
  }
  else
  {
    [recipeLabel setText:@"0"];
  }

  if (dict[@"followed_count"]!=[NSNull null] && ![dict[@"followed_count"] isEqual:@""])
  {
    NSString *temString = [NSString stringWithFormat:@"%d", [dict[@"followed_count"] intValue]];
    [fansLabel setText: temString];
  }
  else
  {
    [fansLabel setText:@"0"];
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
