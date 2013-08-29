//
//  RecipeDetailFooterView.m
//  HellCook
//
//  Created by lxw on 13-8-16.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "RecipeDetailFooterView.h"

@implementation RecipeDetailFooterView
@synthesize commentLabel, commentBtn;

- (id)initWithFrame:(CGRect)frame withCommentNum:(NSInteger)commentNum
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:frame];
   
/*    commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 180, 30)];
    commentLabel.textColor = [UIColor blackColor];
    commentLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
    commentLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.font = [UIFont systemFontOfSize:18];
    
    NSString *str = [NSString stringWithFormat:@"%d条评论",commentNum];
    [commentLabel setText:str];
    
    commentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:parentController action:@selector(tapCommentLabel)];
    [commentLabel addGestureRecognizer:tapGestureTel];
    
    [self addSubview:commentLabel];*/
    
    
    commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setFrame:CGRectMake(50, 0, 180, 30)];
    [commentBtn setBackgroundColor:[UIColor clearColor]];
    NSString *str = [NSString stringWithFormat:@"%d条评论",commentNum];
    [commentBtn setTitle:str forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commentBtn addTarget:nil action:@selector(tapComment) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentBtn];
  }
  return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
