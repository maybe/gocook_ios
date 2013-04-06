//
//  MainTopTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "MainTopTableViewCell.h"

@implementation MainTopTableViewCell
@synthesize leftView, rightView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (UIView*)leftView
{
  if (!leftView) {
    leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 100)];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:@""];
    
    
  }
  return leftView;
}

- (UIView*)rightView
{
  if (!rightView) {
    
  }
  return rightView;
}

@end
