//
//  AccountController.h
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface AccountController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
  UITableView* tableView;
  UIImageView* bannerImageView;
  UIImageView* avatarImageView;
  UILabel* nameLabel;
  UIButton* loginButton;
  UIButton* registerButton;
  UILabel* loginTitleLabel;
  UIButton* debugOptionButton;
  NSMutableArray* cellContentArray;
  BOOL shouldRefreshKitchenInfo;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) UIImageView* bannerImageView;
@property (nonatomic, retain) UIImageView*avatarImageView;
@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain) UIButton* loginButton;
@property (nonatomic, retain) UIButton* registerButton;
@property (nonatomic, retain) NSMutableArray* cellContentArray;
@property (strong, nonatomic) MKNetworkOperation *netOperation;

-(IBAction)tapNameLabel:(id)sender;

@end
