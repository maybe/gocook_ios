//
//  ValidLotteryCell.h
//  HellCook
//
//  Created by lxw on 13-11-9.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OriginHeight 90

@interface ValidLotteryCell : UITableViewCell
{
  UIImageView* backgroundView;
  UIButton *bottomBtn;
  CGFloat height;
  
  NSMutableArray *rightBtnsArray;
  NSMutableArray *contentLabelsArray;
}

@property(nonatomic,retain)UIImageView* backgroundView;
@property(nonatomic,retain)UIButton *bottomBtn;

- (void)setData:(NSMutableArray*)data withStatus:(NSInteger)status;
//status=0表示未展开状态，status=1表示展开状态

-(CGFloat)getCellHeight;
-(CGFloat)caculateCellHeight:(NSMutableArray*)data withStatus:(NSInteger)status;


@end
