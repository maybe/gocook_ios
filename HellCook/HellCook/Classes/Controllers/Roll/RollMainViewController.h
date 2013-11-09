//
//  RollMainViewController.h
//  HellCook
//
//  Created by lxw on 13-11-4.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RollMainViewController : UIViewController
{
  UIImageView* backgroundView;
  BOOL bInRoll;
}

@property(nonatomic,retain)UIImageView* backgroundView;
@property (strong, nonatomic) MKNetworkOperation *netOperation;

@end
