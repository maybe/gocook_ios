//
//  AccountTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
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
      [self.titleLabel setFont: [UIFont systemFontOfSize:17]];
      [titleLabel setBackgroundColor: [UIColor clearColor]];

      bottomlineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 62, 280, 1.2)];
      imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 16, 26, 26)];
      [imageView setContentMode:UIViewContentModeTopLeft];

      [imageView setBackgroundColor: [UIColor clearColor]];

      [self.bottomlineView setImage: [UIImage imageNamed:@"Images/line.png"]];

      [self addSubview:titleLabel];
      [self addSubview:bottomlineView];
      [self addSubview:imageView];
      
    }
    return self;
}

@end
