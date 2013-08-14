//
//  TopHotController.h
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ShoppingListController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
  UITableView* tableView;
  UIImageView* fakeNavBarView;
  
  UIButton* leftListButton;
  UIButton* rightListButton;
  UILabel* listCountLabel;

  NSMutableArray* dataListArray;
  NSMutableArray* cellContentArray;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) UIButton* leftListButton;
@property (nonatomic, retain) UIButton* rightListButton;
@property (nonatomic, retain) UILabel* listCountLabel;
@property (nonatomic, retain) NSMutableArray* cellContentArray;

@end
