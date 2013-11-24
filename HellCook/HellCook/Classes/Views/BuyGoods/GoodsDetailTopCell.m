//
//  GoodsDetailTopCell.m
//  HellCook
//
//  Created by lxw on 13-9-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "GoodsDetailTopCell.h"
#import "NetManager.h"
#import "UIImageView+WebCache.h"

@implementation GoodsDetailTopCell
@synthesize imageView,defaultImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    defaultImage = [UIImage imageNamed:@"Images/M6DefaultImage.png"];
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320-_offset, 150)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320-_offset, 150)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [self addSubview:imageView];
  }
  return self;
}

-(void)setData:(NSMutableDictionary*)dict
{
  if (dict[@"image_url"]!=[NSNull null] && ![dict[@"image_url"] isEqual:@""])
  {
    [imageView setImageWithURL:[NSURL URLWithString:dict[@"image_url"]] placeholderImage:[UIImage imageNamed:@"Images/defaultUpload.png"]];
    
    defaultImage = imageView.image;
  }
  else
  {
    [imageView setImage:defaultImage];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
