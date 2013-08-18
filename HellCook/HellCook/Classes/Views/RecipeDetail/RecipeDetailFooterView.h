//
//  RecipeDetailFooterView.h
//  HellCook
//
//  Created by lxw on 13-8-16.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeDetailFooterView : UIView
{
  UILabel *commentLabel;
  UIViewController *parentController;
  
  UIButton *commentBtn;
}

@property (retain, nonatomic) UILabel *commentLabel;
@property (retain, nonatomic) UIButton *commentBtn;

- (id)initWithFrame:(CGRect)frame withCommentNum:(NSInteger)commentNum;

@end
