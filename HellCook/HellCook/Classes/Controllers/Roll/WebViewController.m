//
//  WebViewController.m
//  HellCook
//
//  Created by lxw on 13-11-9.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil withURL:(NSString*)url bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    strURL = [NSString stringWithString:url];
    title = @"浏览";
  }
  return self;
}

- (void)loadWebPage:(NSString *)urlString usingSession:(NSString *)nameString withValue:(NSString*)valueString withTitle:(NSString*)titleString{
  NSURL *url = [NSURL URLWithString:urlString];
  mutableRequest = [[NSMutableURLRequest alloc]initWithURL: url];
  if (titleString) {
    title = titleString;
  }

  NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
  [cookieProperties setObject:nameString forKey:NSHTTPCookieName];
  [cookieProperties setObject:valueString forKey:NSHTTPCookieValue];
  [cookieProperties setObject:@"o2o.m6fresh.com" forKey:NSHTTPCookieDomain];
  [cookieProperties setObject:@"o2o.m6fresh.com" forKey:NSHTTPCookieOriginURL];
  [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
  [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
  [cookieProperties setObject:@"30000" forKey:NSHTTPCookieMaximumAge];
  NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self autoLayout];

  [self setLeftButton];
  
  CGRect webFrame = self.webView.frame;
  webFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.webView setFrame:webFrame];
  [self.webView setDelegate:self];

  if (strURL) {
    NSURL* url = [[NSURL alloc] initWithString:strURL];
    [webView loadRequest:[NSURLRequest requestWithURL: url]];
  }

  if (mutableRequest) {
    [webView loadRequest:mutableRequest];
  }

  self.title = title;
}

- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/BackButtonNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/BackButtonHighLight.png"]
                               forState:UIControlStateHighlighted];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {

  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {

  return UIInterfaceOrientationMaskPortrait;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
}

@end
