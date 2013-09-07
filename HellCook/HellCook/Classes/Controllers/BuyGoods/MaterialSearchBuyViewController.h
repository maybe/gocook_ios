//
//  MaterialSearchBuyViewController.h
//  HellCook
//
//  Created by lxw on 13-9-2.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialSearchBuyViewController : UIViewController
{
  UITableView *myTableView;
  NSMutableArray *unslashMaterialArray;
}

@property (nonatomic,retain) IBOutlet UITableView *myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableArray*)data;

@end
