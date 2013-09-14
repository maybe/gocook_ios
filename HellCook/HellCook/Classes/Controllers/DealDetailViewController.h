//
//  DealDetailViewController.h
//  HellCook
//
//  Created by lxw on 13-9-13.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealDetailViewController : UIViewController
{
  UIScrollView *myScrollView;
  NSMutableDictionary *dataDict;
  
  UILabel *timeLabel;
  UILabel *orderLabel;
  UILabel *titleLabel;
  UILabel *totalLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableDictionary*)data;

@end
