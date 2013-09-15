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
  NSInteger mUserID;
  ViewControllerCalledFrom eCalledFrom;
  UIBarButtonItem *rightBarButtonItem;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) MyIntroductionIntroCell *pIntroCell;
@property (nonatomic, retain) MyIntroductionPicCell *pPicCell;
@property (nonatomic, retain) UIBarButtonItem *rightBarButtonItem;
@property BOOL bShouldRefresh;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSInteger)userid from:(ViewControllerCalledFrom)calledFrom;

@end
