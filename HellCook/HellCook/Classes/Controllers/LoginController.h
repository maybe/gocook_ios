//
//  LoginController.h
//  HellCook
//
//  Created by panda on 3/28/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate, UIWebViewDelegate> {
  MBProgressHUD *HUD;
  UIWebView *webView;
  NSString *callerClassName;
  NSInteger rndValue;
}

@property(nonatomic, retain) IBOutlet UIWebView *webView;
@property(strong, nonatomic) MKNetworkOperation *loginOperation;
@property NSInteger rndValue;
@property(nonatomic, retain) NSString *callerClassName;

@end
