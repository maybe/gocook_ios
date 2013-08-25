//
//  MyIntroEditViewController.h
//  HellCook
//
//  Created by lxw on 13-8-11.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardHandlerDelegate.h"
#import "MBProgressHUD.h"
#import "SSTextView.h"
#import "MyIntroductionPicCell.h"
#import "MyIntroAvatarView.h"

@class KeyboardHandler;
@class MBProgressHUD;
@interface MyIntroEditViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,KeyboardHandlerDelegate,MBProgressHUDDelegate>
{
  UITableView* myTableView;
  NSMutableArray* cellContentList;
  NSMutableDictionary *data;
  
  UITextField* nameField;
  UITextField* careerField;
  UITextField* provinceField;
  UITextField* cityField;
  SSTextView* introTextView;
  UITextField *ageField;
  UIButton *maleBtn;
  UIButton *femaleBtn;
  UIButton *otherBtn;
  
  MyIntroAvatarView* headImageView;
  
  KeyboardHandler *keyboard;
  MBProgressHUD *HUD;
  BOOL isChanged;
  UIActivityIndicatorView* mLoadingActivity;
  int waitCallBack;
}

@property (nonatomic, retain) IBOutlet UITableView* myTableView;
@property (nonatomic, retain) UITextField* nameField;
@property (nonatomic, retain) UITextField* careerField;
@property (nonatomic, retain) UITextField* provinceField;
@property (nonatomic, retain) UITextField* cityField;
@property (nonatomic, retain) SSTextView* introTextView;
@property (nonatomic, retain) UITextField *ageField;
@property (nonatomic, retain) UIButton *maleBtn;
@property (nonatomic, retain) UIButton *femaleBtn;
@property (nonatomic, retain) UIButton *otherBtn;
@property (strong, nonatomic) MKNetworkOperation *netOperation;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSMutableDictionary*)dict;
- (IBAction) maleBtnPressed;
- (IBAction) femaleBtnPressed;
- (IBAction) otherBtnPressed;

@end
