//
//  MyIntroductionPicCell.m
//  HellCook
//
//  Created by lxw on 13-8-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyIntroductionPicCell.h"
#import "User.h"
#import "NetManager.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Blurring.h"

@implementation MyIntroductionPicCell
@synthesize bannerImageView;
@synthesize avataImageView;
@synthesize nameLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 150)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
 
      //namelabel
      nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 60, 180, 30)];
      nameLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
      nameLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
      nameLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
      nameLabel.backgroundColor = [UIColor clearColor];
      nameLabel.font = [UIFont boldSystemFontOfSize:20];
      //bannerImageView
      bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
      [bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
      [bannerImageView setClipsToBounds:YES];
      //avatarImageView
      avataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 55, 40, 40)];
      [avataImageView setContentMode:UIViewContentModeScaleAspectFill];
      [avataImageView setClipsToBounds:YES];
      avataImageView.layer.cornerRadius = 4.0;
      avataImageView.layer.masksToBounds = YES;
      avataImageView.layer.borderColor = [UIColor clearColor].CGColor;
      avataImageView.layer.borderWidth = 1.0;
      
      [self addSubview:bannerImageView];
      [self addSubview:avataImageView];
      [self addSubview:nameLabel];
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
  if (dict[@"nickname"]!=[NSNull null] && ![dict[@"nickname"] isEqual:@""])
  {
    [nameLabel setText: dict[@"nickname"]];
  }
  else
  {
    [nameLabel setText:[[[User sharedInstance] account] username]];
  }
  
  if (dict[@"avatar"]!=[NSNull null] && ![dict[@"avatar"] isEqual:@""])
  {
    NSString* avatarUrl = [NSString stringWithFormat: @"http://%@/%@", [[NetManager sharedInstance] host], dict[@"avatar"]];
    [avataImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
    [bannerImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"Images/avatar.jpg"] options:0  andGaussianBlurWithBias:20];
  }
  else
  {
    [avataImageView setImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
    [bannerImageView setImage: [[UIImage imageNamed:@"Images/avatar.jpg"] gaussianBlurWithBias:20]];
  }
}

@end
