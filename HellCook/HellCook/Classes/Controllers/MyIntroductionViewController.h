//
//  MyIntroductionViewController.h
//  HellCook
//
//  Created by lxw on 13-8-3.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyIntroductionPicCell.h"
#import "MyIntroductionIntroCell.h"

@interface MyIntroductionViewController : UIViewController
{
  NSMutableDictionary *pMyInfo;
  MyIntroductionPicCell *pPicCell;
  MyIntroductionIntroCell *pIntroCell;
  BOOL bShouldRefresh;
  NSInteger userId;
  UIBarButtonItem *rightBarButtonItem;
  NSString* titleName;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) MyIntroductionIntroCell *pIntroCell;
@property (nonatomic, retain) MyIntroductionPicCell *pPicCell;
@property (nonatomic, retain) UIBarButtonItem *rightBarButtonItem;
@property BOOL bShouldRefresh;
@property (nonatomic, retain) NSString* titleName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userID AndName:(NSString *)userName;

@end
