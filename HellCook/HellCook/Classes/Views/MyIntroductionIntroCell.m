//
//  MyIntroductionIntroCell.m
//  HellCook
//
//  Created by lxw on 13-8-6.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "MyIntroductionIntroCell.h"

@implementation MyIntroductionIntroCell
@synthesize introLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      mCellHeight = _screenHeight_NoStBar-_navigationBarHeight-150;
      [self setBackgroundColor: [UIColor clearColor]];
      [self setFrame:CGRectMake(0, 0, 320, mCellHeight)];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      introLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 15, 268, mCellHeight-30)];
      [introLabel setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
      introLabel.lineBreakMode = NSLineBreakByWordWrapping;
      introLabel.numberOfLines = 0;
      [introLabel setBackgroundColor:[UIColor clearColor]];
      
      [self addSubview:introLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)GetCellHeight
{
  return mCellHeight;
}

- (void)calculateCellHeight:(NSString*)strIntro
{
  if (![strIntro isEqualToString:@""]) {
    introLabel.text = strIntro;
  } else {
    introLabel.text = @"暂时无个人信息";
  }

  CGSize contentSize = [introLabel.text sizeWithFont:introLabel.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
  if ((contentSize.height+30) > mCellHeight)
  {
    mCellHeight = contentSize.height+30;
    
    CGRect cellRect = self.frame;
    cellRect.size.height = mCellHeight;
    [self setFrame:cellRect];
  }
  
  CGRect labelRect = introLabel.frame;
  labelRect.size.height = contentSize.height;
  [introLabel setFrame:labelRect];
}

@end
