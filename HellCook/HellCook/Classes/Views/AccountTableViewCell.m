//
//  ArticleTitleTableViewCell.m
//  HellCook
//
//  Created by panda on 11-11-27.
//  Copyright (c) 2011 panda. All rights reserved.
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell
@synthesize titleLabel,imageView,bottomlineView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, 20, 150, 23)];
      [self.titleLabel setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.titleLabel setFont: [UIFont systemFontOfSize:16]];
      [titleLabel setBackgroundColor: [UIColor clearColor]];

      bottomlineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 62, 280, 1)];
      imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 23, 23)];

      [imageView setBackgroundColor: [UIColor clearColor]];

      [self.bottomlineView setImage: [UIImage imageNamed:@"Images/line.png"]];
     // [bottomlineView setBackgroundColor:[UIColor colorWithRed:216.0f/255.0f green:216.0f/255.0f blue:216.0f/255.0f alpha:1.0f]];

      [self addSubview:titleLabel];
      [self addSubview:bottomlineView];
      [self addSubview:imageView];
      
    }
    return self;
}

@end
