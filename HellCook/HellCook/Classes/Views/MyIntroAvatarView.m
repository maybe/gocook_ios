//
//  MyIntroAvatarView.m
//  HellCook
//
//  Created by lxw on 13-8-11.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyIntroAvatarView.h"
#import "UIImageView+WebCache.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImage+Blurring.h"
#import "NetManager.h"

@implementation MyIntroAvatarView
@synthesize bannerImageView,avataImageView,defaultImage,uploadBtn;

- (id)initWithFrame:(CGRect)frame withData:(NSMutableDictionary*)dict
{
  self = [super initWithFrame:frame];
  if (self) {
  // Initialization code
    defaultImage = [UIImage imageNamed:@"Images/avatar.jpg"];
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, 150)];
    
    //bannerImageView
//    bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)];
//    [bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
//    [bannerImageView setClipsToBounds:YES];
    //avatarImageView
    avataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(131, 35, 58, 58)];
    [avataImageView setContentMode:UIViewContentModeScaleAspectFill];
    avataImageView.layer.masksToBounds = YES;
    avataImageView.layer.borderColor = [UIColor clearColor].CGColor;
    avataImageView.layer.borderWidth = 1.0;
    [avataImageView setClipsToBounds:YES];

    UIButton *avatarButton = [[UIButton alloc] initWithFrame:avataImageView.frame];
    [avatarButton addTarget:[self viewController] action:@selector(loadImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [avatarButton setBackgroundColor:[UIColor clearColor]];

    //uploadButton
    uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadBtn setFrame:CGRectMake(105,100,110,20)];
    [uploadBtn setBackgroundColor:[UIColor clearColor]];
    [uploadBtn setTitle:@"上传头像" forState:UIControlStateNormal];
    [uploadBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [uploadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uploadBtn addTarget:[self viewController] action:@selector(loadImagePicker) forControlEvents:UIControlEventTouchUpInside];
    
    //[self addSubview:bannerImageView];
    [self addSubview:avataImageView];
    [self addSubview:avatarButton];
    [self addSubview:uploadBtn];
    
    data = [NSMutableDictionary dictionaryWithDictionary:dict];
    [self setData:data];
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

- (void)setData:(NSMutableDictionary*)dict
{
  if (dict[@"avatar"]!=[NSNull null] && ![dict[@"avatar"] isEqual:@""])
  {
    NSString* avatarUrl = nil;

    if ([[dict[@"avatar"] substringToIndex:15] isEqualToString:@"images/avatars/"]) {
      avatarUrl = [NSString stringWithFormat:@"http://%@/%@", [[NetManager sharedInstance] host], dict[@"avatar"]];
    } else {
      avatarUrl = [NSString stringWithFormat:@"http://%@/images/avatars/%@", [[NetManager sharedInstance] host], dict[@"avatar"]];
    }

    [avataImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:defaultImage];
    //[bannerImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:defaultImage options:0  andGaussianBlurWithBias:20];
    
    defaultImage = avataImageView.image;
  }
  else
  {
    [avataImageView setImage:defaultImage];
    //[bannerImageView setImage: [defaultImage gaussianBlurWithBias:20]];
  }
}

- (void)setNewImage:(UIImage*)newImage
{
  [avataImageView setImage:newImage];
  //[bannerImageView setImage:[newImage gaussianBlurWithBias:20]];
}

@end
