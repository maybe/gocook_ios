//
//  ArticleTitleTableViewCell.h
//  LilyBBS
//
//  Created by panda on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewCell : UITableViewCell{
  UIImageView* imageView;
  UILabel* titleLabel;
  UIImageView* bottomlineView;
}

@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIImageView* bottomlineView;


@end
