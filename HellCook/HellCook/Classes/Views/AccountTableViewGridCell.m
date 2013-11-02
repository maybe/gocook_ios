//
//  ArticleTitleTableViewCell.m
//  HellCook
//
//  Created by panda on 11-11-27.
//  Copyright (c) 2011 panda. All rights reserved.
//

#import "AccountTableViewGridCell.h"

#define kAccountTableViewGridButton1Tag 10001
#define kAccountTableViewGridButton2Tag 10002
#define kAccountTableViewGridButton3Tag 10003
#define kAccountTableViewGridButton4Tag 10004
#define kAccountTableViewGridButton5Tag 10005
#define kAccountTableViewGridButton6Tag 10006

@implementation AccountTableViewGridCell
@synthesize countLabel1,countLabel2,countLabel3,countLabel4,countLabel5,countLabel6;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setBackgroundColor: [UIColor clearColor]];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      self.bottomLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 280, 1.2)];
      [self.bottomLine1 setImage: [UIImage imageNamed:@"Images/line.png"]];
     // [self.bottomLine1 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];

      self.bottomLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 128, 280, 1.2)];
      [self.bottomLine2 setImage: [UIImage imageNamed:@"Images/line.png"]];
     // [self.bottomLine2 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];

      self.bottomLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 191, 280, 1.2)];
      [self.bottomLine3 setImage: [UIImage imageNamed:@"Images/line.png"]];

      self.sepLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(140-30, 0+30, 64, 1.2)];
      [self.sepLine1 setImage: [UIImage imageNamed:@"Images/line.png"]];
      self.sepLine1.transform = CGAffineTransformMakeRotation(M_PI_2);
     // [self.sepLine1 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
      self.sepLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(140-30, 64+31, 64, 1.2)];
      [self.sepLine2 setImage: [UIImage imageNamed:@"Images/line.png"]];
      self.sepLine2.transform = CGAffineTransformMakeRotation(M_PI_2);
     // [self.sepLine2 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
      self.sepLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(140-30, 128+32, 64, 1.2)];
      [self.sepLine3 setImage: [UIImage imageNamed:@"Images/line.png"]];
      self.sepLine3.transform = CGAffineTransformMakeRotation(M_PI_2);
     // [self.sepLine3 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];

      countLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 30, 64)];
      [self.countLabel1 setBackgroundColor: [UIColor clearColor]];
      [self.countLabel1 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel1 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel1 setFont: [UIFont boldSystemFontOfSize:22]];
      
      countLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 30, 64)];
      countLabel2.backgroundColor = [UIColor clearColor];
      [self.countLabel2 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel2 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel2 setFont: [UIFont boldSystemFontOfSize:22]];

      countLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(40, 64, 30, 64)];
      countLabel3.backgroundColor = [UIColor clearColor];
      [self.countLabel3 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel3 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel3 setFont: [UIFont boldSystemFontOfSize:22]];

      countLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(180, 64, 30, 64)];
      countLabel4.backgroundColor = [UIColor clearColor];
      [self.countLabel4 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel4 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel4 setFont: [UIFont boldSystemFontOfSize:22]];

      countLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(40, 128, 30, 64)];
      countLabel5.backgroundColor = [UIColor clearColor];
      [self.countLabel5 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel5 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel5 setFont: [UIFont boldSystemFontOfSize:22]];

      countLabel6 = [[UILabel alloc]initWithFrame:CGRectMake(180, 128, 30, 64)];
      countLabel6.backgroundColor = [UIColor clearColor];
      [self.countLabel6 setTextAlignment:NSTextAlignmentCenter];
      [self.countLabel6 setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
      [self.countLabel6 setFont: [UIFont boldSystemFontOfSize:22]];

      self.nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 17, 50, 30)];
      [self.nameLabel1 setBackgroundColor: [UIColor clearColor]];
      [self.nameLabel1 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel1 setFont: [UIFont systemFontOfSize:17]];

      self.nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(210, 17, 50, 30)];
      self.nameLabel2.backgroundColor = [UIColor clearColor];
      [self.nameLabel2 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel2 setFont: [UIFont systemFontOfSize:17]];
      
      self.nameLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(70, 81, 50, 30)];
      self.nameLabel3.backgroundColor = [UIColor clearColor];
      [self.nameLabel3 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel3 setFont: [UIFont systemFontOfSize:17]];
      
      self.nameLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(210, 81, 50, 30)];
      self.nameLabel4.backgroundColor = [UIColor clearColor];
      [self.nameLabel4 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel4 setFont: [UIFont systemFontOfSize:17]];

      self.nameLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(70, 145, 50, 30)];
      self.nameLabel5.backgroundColor = [UIColor clearColor];
      [self.nameLabel5 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel5 setFont: [UIFont systemFontOfSize:17]];

      self.nameLabel6 = [[UILabel alloc]initWithFrame:CGRectMake(210, 145, 50, 30)];
      self.nameLabel6.backgroundColor = [UIColor clearColor];
      [self.nameLabel6 setTextColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
      [self.nameLabel6 setFont: [UIFont systemFontOfSize:17]];
      
      UIButton* button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 140, 64)];
      UIButton* button2 = [[UIButton alloc]initWithFrame:CGRectMake(140, 0, 140, 64)];
      UIButton* button3 = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, 140, 64)];
      UIButton* button4 = [[UIButton alloc]initWithFrame:CGRectMake(140, 64, 140, 64)];
      UIButton* button5 = [[UIButton alloc]initWithFrame:CGRectMake(0, 128, 140, 64)];
      UIButton* button6 = [[UIButton alloc]initWithFrame:CGRectMake(140, 128, 140, 64)];

      [button1 setBackgroundColor:[UIColor clearColor]];
      [button2 setBackgroundColor:[UIColor clearColor]];
      [button3 setBackgroundColor:[UIColor clearColor]];
      [button4 setBackgroundColor:[UIColor clearColor]];
      [button5 setBackgroundColor:[UIColor clearColor]];
      [button6 setBackgroundColor:[UIColor clearColor]];

      button1.tag = kAccountTableViewGridButton1Tag;
      button2.tag = kAccountTableViewGridButton2Tag;
      button3.tag = kAccountTableViewGridButton3Tag;
      button4.tag = kAccountTableViewGridButton4Tag;
      button5.tag = kAccountTableViewGridButton5Tag;
      button6.tag = kAccountTableViewGridButton6Tag;
      
      [button1 addTarget:[self viewController] action:@selector(onClickCountGrid:) forControlEvents:UIControlEventTouchUpInside];
      [button2 addTarget:[self viewController] action:@selector(onClickCountGrid:) forControlEvents:UIControlEventTouchUpInside];
      [button3 addTarget:[self viewController] action:@selector(onClickCountGrid:) forControlEvents:UIControlEventTouchUpInside];
      [button4 addTarget:[self viewController] action:@selector(onClickCountGrid:) forControlEvents:UIControlEventTouchUpInside];
      [button5 addTarget:[self viewController] action:@selector(onClickCountGrid:) forControlEvents:UIControlEventTouchUpInside];
      [button6 addTarget:[self viewController] action:@selector(onClickCountGrid:) forControlEvents:UIControlEventTouchUpInside];
      
      [self addSubview:self.bottomLine1];
      [self addSubview:self.bottomLine2];
      [self addSubview:self.bottomLine3];
      [self addSubview:self.sepLine1];
      [self addSubview:self.sepLine2];
      [self addSubview:self.sepLine3];
      [self addSubview:self.nameLabel1];
      [self addSubview:self.nameLabel2];
      [self addSubview:self.nameLabel3];
      [self addSubview:self.nameLabel4];
      [self addSubview:self.nameLabel5];
      [self addSubview:self.nameLabel6];
      [self addSubview:self.countLabel1];
      [self addSubview:self.countLabel2];
      [self addSubview:self.countLabel3];
      [self addSubview:self.countLabel4];
      [self addSubview:self.countLabel5];
      [self addSubview:self.countLabel6];

      [self addSubview:button1];
      [self addSubview:button2];
      [self addSubview:button3];
      [self addSubview:button4];
      [self addSubview:button5];
      [self addSubview:button6];

    }
    return self;
}

//to get the next responder controller
- (UIViewController*)viewController {
  for (UIView* next = [self superview]; next; next = next.superview) {
    UIResponder* nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
      return (UIViewController*)nextResponder;
    }
  }
  return nil;
}

@end
