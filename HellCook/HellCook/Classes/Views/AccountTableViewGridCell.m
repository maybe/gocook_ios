//
//  ArticleTitleTableViewCell.m
//  HellCook
//
//  Created by panda on 11-11-27.
//  Copyright (c) 2011 panda. All rights reserved.
//

#import "AccountTableViewGridCell.h"

@implementation AccountTableViewGridCell
@synthesize countLabel1,countLabel2,countLabel3,countLabel4,countLabel5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      self.bottomLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 280, 1.2)];
      [self.bottomLine1 setImage: [UIImage imageNamed:@"Images/line.png"]];
     // [self.bottomLine1 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];

      self.bottomLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 87, 280, 1.2)];
      [self.bottomLine2 setImage: [UIImage imageNamed:@"Images/line.png"]];
     // [self.bottomLine2 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
      
      self.sepLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(140-21, 0+21, 43, 1.2)];
      [self.sepLine1 setImage: [UIImage imageNamed:@"Images/line.png"]];
      self.sepLine1.transform = CGAffineTransformMakeRotation(M_PI_2);
     // [self.sepLine1 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
      self.sepLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(93-21, 44+21, 43, 1.2)];
      [self.sepLine2 setImage: [UIImage imageNamed:@"Images/line.png"]];
      self.sepLine2.transform = CGAffineTransformMakeRotation(M_PI_2);
     // [self.sepLine2 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
      self.sepLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(186-21, 44+21, 43, 1.2)];
      [self.sepLine3 setImage: [UIImage imageNamed:@"Images/line.png"]];
      self.sepLine3.transform = CGAffineTransformMakeRotation(M_PI_2);
     // [self.sepLine3 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];

      countLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 30, 20)];
      [self.countLabel1 setBackgroundColor: [UIColor clearColor]];
      [self.countLabel1 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel1 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel1 setFont: [UIFont boldSystemFontOfSize:17]];
      
      countLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(180, 12, 30, 20)];
      countLabel2.backgroundColor = [UIColor clearColor];
      [self.countLabel2 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel2 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel2 setFont: [UIFont boldSystemFontOfSize:17]];

      countLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 56, 30, 20)];
      countLabel3.backgroundColor = [UIColor clearColor];
      [self.countLabel3 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel3 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel3 setFont: [UIFont boldSystemFontOfSize:17]];

      countLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(103, 56, 30, 20)];
      countLabel4.backgroundColor = [UIColor clearColor];
      [self.countLabel4 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel4 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel4 setFont: [UIFont boldSystemFontOfSize:17]];

      countLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(196, 56, 30, 20)];
      countLabel5.backgroundColor = [UIColor clearColor];
      [self.countLabel5 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel5 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel5 setFont: [UIFont boldSystemFontOfSize:17]];

      self.nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 12, 50, 20)];
      [self.nameLabel1 setBackgroundColor: [UIColor clearColor]];
      [self.nameLabel1 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel1 setFont: [UIFont systemFontOfSize:15]];

      self.nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(210, 12, 50, 20)];
      self.nameLabel2.backgroundColor = [UIColor clearColor];
      [self.nameLabel2 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel2 setFont: [UIFont systemFontOfSize:15]];
      
      self.nameLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(40, 56, 50, 20)];
      self.nameLabel3.backgroundColor = [UIColor clearColor];
      [self.nameLabel3 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel3 setFont: [UIFont systemFontOfSize:15]];
      
      self.nameLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(133, 56, 50, 20)];
      self.nameLabel4.backgroundColor = [UIColor clearColor];
      [self.nameLabel4 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel4 setFont: [UIFont systemFontOfSize:15]];

      self.nameLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(226, 56, 50, 20)];
      self.nameLabel5.backgroundColor = [UIColor clearColor];
      [self.nameLabel5 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel5 setFont: [UIFont systemFontOfSize:15]];
      
      [self addSubview:self.bottomLine1];
      [self addSubview:self.bottomLine2];
      [self addSubview:self.sepLine1];
      [self addSubview:self.sepLine2];
      [self addSubview:self.sepLine3];
      [self addSubview:self.nameLabel1];
      [self addSubview:self.nameLabel2];
      [self addSubview:self.nameLabel3];
      [self addSubview:self.nameLabel4];
      [self addSubview:self.nameLabel5];
      [self addSubview:self.countLabel1];
      [self addSubview:self.countLabel2];
      [self addSubview:self.countLabel3];
      [self addSubview:self.countLabel4];
      [self addSubview:self.countLabel5];
      
    }
    return self;
}

@end
