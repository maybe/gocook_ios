//
//  WebViewController.h
//  HellCook
//
//  Created by lxw on 13-11-9.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
{
  UIWebView *webView;
  NSString *strURL;
  NSMutableURLRequest* mutableRequest;
  NSString *title;
}

@property(nonatomic, retain) IBOutlet UIWebView *webView;

- (id)initWithNibName:(NSString *)nibNameOrNil withURL:(NSString*)url bundle:(NSBundle *)nibBundleOrNil;
- (void)loadWebPage:(NSString *)urlString usingSession:(NSString *)nameString withValue:(NSString*)valueString withTitle:(NSString*)titleString;

@end
