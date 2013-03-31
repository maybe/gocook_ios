//
//  ArticleTitleTableViewCell.h
//  HC
//
//  Created by panda on 11-11-27.
//  Copyright (c) 2011 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewGridCell : UITableViewCell{

  UILabel* countLabel1;
  UILabel* countLabel2;
  UILabel* countLabel3;
  UILabel* countLabel4;
  UILabel* countLabel5;
  
}

@property (nonatomic, retain) UILabel* countLabel1;
@property (nonatomic, retain) UILabel* countLabel2;
@property (nonatomic, retain) UILabel* countLabel3;
@property (nonatomic, retain) UILabel* countLabel4;
@property (nonatomic, retain) UILabel* countLabel5;

@property (nonatomic, retain) UILabel* nameLabel1;
@property (nonatomic, retain) UILabel* nameLabel2;
@property (nonatomic, retain) UILabel* nameLabel3;
@property (nonatomic, retain) UILabel* nameLabel4;
@property (nonatomic, retain) UILabel* nameLabel5;

@property (nonatomic, retain) UIImageView* bottomLine1;
@property (nonatomic, retain) UIImageView* bottomLine2;
@property (nonatomic, retain) UIImageView* sepLine1;
@property (nonatomic, retain) UIImageView* sepLine2;
@property (nonatomic, retain) UIImageView* sepLine3;

@end
