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
@synthesize followBtn;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, 150)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
 
      //namelabel
      nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 65, 160, 30)];
      nameLabel.textColor = [UIColor colorWithRed:101.0 / 255.0 green:107.0 / 255.0 blue:55.0 / 255.0 alpha:0.8];
      nameLabel.font = [UIFont boldSystemFontOfSize:20];
      //bannerImageView
      bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
      [bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
      [bannerImageView setClipsToBounds:YES];
      [bannerImageView setImage:[UIImage imageNamed:@"Images/AvatarBackground.png"]];
      //avatarImageView
      avataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 40, 58, 58)];
      [avataImageView setContentMode:UIViewContentModeScaleAspectFill];
      [avataImageView setClipsToBounds:YES];
      avataImageView.layer.masksToBounds = YES;
      avataImageView.layer.borderColor = [UIColor clearColor].CGColor;
      avataImageView.layer.borderWidth = 1.0;

      //follow button
      followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [followBtn setFrame:CGRectMake(240,60,68,29)];
      [followBtn setBackgroundColor:[UIColor clearColor]];
      [followBtn setTitle:@"已关注" forState:UIControlStateNormal];
      [followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [followBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];

      [followBtn setBackgroundImage:[UIImage imageNamed:@"Images/GreenButtonNormal136.png"] forState:UIControlStateNormal];
      [followBtn setBackgroundImage:[UIImage imageNamed:@"Images/GreenButtonHighLight136.png"] forState:UIControlStateHighlighted];

      [followBtn addTarget:[self viewController] action:@selector(followBtnTapped) forControlEvents:UIControlEventTouchUpInside];
      
      [self addSubview:bannerImageView];
      [self addSubview:avataImageView];
      [self addSubview:nameLabel];
      [self addSubview:followBtn];
      [followBtn setHidden:YES];
    }
    return self;
}

- (UIViewController*)viewController {
  for (UIView* next = [self superview]; next; next = next.superview)
  {
    UIResponder* nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
      return (UIViewController*)nextResponder;
    }
  }
  return nil;
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
    //[bannerImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"Images/avatar.jpg"] options:0  andGaussianBlurWithBias:20];
  }
  else
  {
    [avataImageView setImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
    //[bannerImageView setImage: [[UIImage imageNamed:@"Images/avatar.jpg"] gaussianBlurWithBias:20]];
  }
}

@end
