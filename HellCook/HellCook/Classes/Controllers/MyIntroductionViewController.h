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
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) MyIntroductionIntroCell *pIntroCell;
@property (nonatomic, retain) MyIntroductionPicCell *pPicCell;

@end
