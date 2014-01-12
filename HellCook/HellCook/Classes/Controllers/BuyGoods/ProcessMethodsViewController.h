//
//  ProcessMethodsViewController.h
//  HellCook
//
//  Created by lxw on 13-11-23.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessMethodsViewController : UIViewController
{
  UITableView *myTableView;
  NSMutableArray *methodsArray;
}

@property (nonatomic,retain) IBOutlet UITableView *myTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil withMethods:(NSMutableArray*)data bundle:(NSBundle *)nibBundleOrNil;

@end
