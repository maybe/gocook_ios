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
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
