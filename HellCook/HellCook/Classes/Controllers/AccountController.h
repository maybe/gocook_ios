//
//  AccountController.h
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface AccountController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
  UITableView* tableView;
  UIImageView* bannerImageView;
  UIImageView* avataImageVIew;
  UILabel* nameLabel;
  UIButton* loginButton;
  UIButton* registerButton;
  UIButton* debugOptonButton;
  NSMutableArray* cellContentArray;
}

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) UIImageView* bannerImageView;
@property (nonatomic, retain) UIImageView* avataImageVIew;
@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain) UIButton* loginButton;
@property (nonatomic, retain) UIButton* registerButton;
@property (nonatomic, retain) NSMutableArray* cellContentArray;


@end