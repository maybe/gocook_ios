//
//  HistoryDealTableViewCell.h
//  HellCook
//
//  Created by lxw on 13-9-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryDealTableViewCell : UITableViewCell
{
  UILabel *timeLabel;
  UILabel *orderLabel;
  UILabel *detailLabel;
  
  UIImageView* sepImageView;
}

-(void)setData:(NSMutableDictionary*)dict;

@end
