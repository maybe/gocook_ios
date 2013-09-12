//
//  BuyViewController.h
//  HellCook
//
//  Created by lxw on 13-9-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class MBProgressHUD;
@interface BuyViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
  UILabel *nameLabel;
  UILabel *priceTitleLabel;
  UILabel *priceLabel;
  UILabel *unitLabel;
  UILabel *unitLabel2;
  UILabel *specLabel;
  UILabel *processTitleLabel;
  UILabel *buyTitleLabel;
  UITextField *amountTextField;
  UIButton *confirmBtn;
  UIButton *dropBtn;
  UITextField *methodTextField;
  UIPickerView *picker;
  
  NSMutableArray *dealMethodLabelArray;
  NSMutableDictionary *goodsDataDict;
  
  MBProgressHUD *HUD;
}

@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *priceTitleLabel;
@property (nonatomic,retain) UILabel *priceLabel;
@property (nonatomic,retain) UILabel *unitLabel;
@property (nonatomic,retain) UILabel *unitLabel2;
@property (nonatomic,retain) UILabel *specLabel;
@property (nonatomic,retain) UILabel *processTitleLabel;
@property (nonatomic,retain) UILabel *buyTitleLabel;
@property (nonatomic,retain) UITextField *amountTextField;
@property (nonatomic,retain) UIButton *confirmBtn;
@property (nonatomic,retain) UIButton *dropBtn;
@property (nonatomic,retain) UITextField *methodTextField;
@property (nonatomic,retain) IBOutlet UIPickerView *picker;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableDictionary*)data;

@end
