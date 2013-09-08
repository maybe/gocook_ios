//
//  DebugOptionController.h
//  HellCook
//
//  Created by panda on 4/1/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugOptionController : UIViewController
{
  UITextField* ipField;
  UIButton* ipButton;
  UINavigationItem* navigationItem;
}

@property (nonatomic, retain) IBOutlet UITextField* ipField;
@property (nonatomic, retain) IBOutlet UIButton* ipButton;
@property (nonatomic, retain) IBOutlet UINavigationItem* navigationItem;


@end
