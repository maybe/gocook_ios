//
//  TopHotController.h
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SearchBarView.h"

@interface MainController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
  UITableView* tableView;
  SearchBarView* searchBarView;
  
  NSMutableArray* catArray;
  NSDictionary* iosMainDataDic;
  UILabel *rightNumLabel;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain)SearchBarView* searchBarView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain)UILabel* rightNumLabel;

- (void)getIOSMainData;

@end
