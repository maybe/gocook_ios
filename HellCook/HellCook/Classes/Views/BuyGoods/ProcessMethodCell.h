//
//  ProcessMethodCell.h
//  HellCook
//
//  Created by lxw on 13-11-24.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessMethodCell : UITableViewCell
{
  UILabel *contentLabel;
}

@property (nonatomic,retain) UILabel *contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withContent:(NSString*)content;

@end
