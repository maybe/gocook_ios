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
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UIImageView* bannerImageView;

@end
