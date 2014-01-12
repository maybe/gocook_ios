//
//  AccountTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
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
